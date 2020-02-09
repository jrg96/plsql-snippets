/*
 * GROUPING_ID is a function similiar to GROUPING. GROUPING_ID returns numbers greater than zero, to identify the subtotal level
 * the row represents.
 */

-- Example 1: CUBE with GROUPING_ID 3 columns
SELECT 
    country_id, department_id, job_id, COUNT(*) AS emp_count,
    GROUPING_ID(country_id, department_id, job_id) AS subtotal_lvl
FROM EMPLOYEES
JOIN DEPARTMENTS USING(department_id)
JOIN LOCATIONS USING(location_id)
WHERE department_id IS NOT NULL
GROUP BY CUBE(country_id, department_id, job_id)
ORDER BY country_id ASC;

-- Example 2: Combining DECODE, GROUPING_ID 3 columns

/*
 * As you saw in the Example 1, the subtotal_lvl follows the folowwing rules:
 *     - LVL 0 = It's row data, not generated by CUBE
 *     - LVL 1 = subtotal given a department, in a specific country
 *     - LVL 2 = subtotal of a JOB_ID, in a specific country
 *     - LVL 3 = subtotal of employees, in a given country
 *     - LVL 4 = subtotal of JOB_ID in a specific department (doesn't matter the country)
 *     - LVL 5 = subtotal of employees, in a given department (deoen't matter country or job_id)
 *     - LVL 6 = subtotal of JOB_ID (doesn't matter country or department)
 *     - LVL 7 = grand total of employees working on any country, any department with any job
 *
 * With this little table, we can use DECODE to make the table even more readable than we made in last example at 019_ANALYTIC_GROUPING
 */
SELECT 
    country_id, department_id, job_id, COUNT(*) AS emp_count,
    DECODE(
        GROUPING_ID(country_id, department_id, job_id), 0, '-',
                                                        1, 'subtotal per department and country',
                                                        2, 'subtotal per job per country',
                                                        3, 'subtotal per country',
                                                        4, 'subtotal per job per department',
                                                        5, 'subtotal per department',
                                                        6, 'subtotal per job',
                                                        7, 'grand total'
    ) AS result 
FROM EMPLOYEES
JOIN DEPARTMENTS USING(department_id)
JOIN LOCATIONS USING(location_id)
WHERE department_id IS NOT NULL
GROUP BY CUBE(country_id, department_id, job_id)
ORDER BY country_id ASC;