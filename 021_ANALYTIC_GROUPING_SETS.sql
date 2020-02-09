/*
 * GROUPING SETS is a function that simplifies the need of getting subtotals. With ROLLUP/CUBE, you can't choose the specific
 * subtotal combinations you want. With GROUPING SETS, you can choose the different combinations you want
 */

-- Example 1: using GROUPING SETS to get some specific combinations of subtotals
-- NOTE: YOU MUST add in the grouping sets, one combination that contains all columns of the SELECT query
SELECT 
    country_id, department_id, job_id, COUNT(*) AS emp_count,
    GROUPING_ID(country_id, department_id, job_id) AS subtotal_lvl
FROM EMPLOYEES
JOIN DEPARTMENTS USING(department_id)
JOIN LOCATIONS USING(location_id)
WHERE department_id IS NOT NULL
GROUP BY 
    GROUPING SETS(
        (country_id, department_id, job_id),
        (country_id),
        () -- This means "Get the grand total"
    )
ORDER BY country_id ASC;