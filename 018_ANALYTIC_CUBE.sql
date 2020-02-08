/*
 * CUBE is an analytical function for all aggregation functions. Unlike the ROLLUP function, CUBE allows us to get all
 * subtotal combinations based on the columns selected for CUBE
 *
 * NOTE: ORDER BY affects how the given combinations of CUBE are displayed, take that into account when you read the table
 */

-- Example 1: Cube with only 1 column
--            Getting all employees for each department, and the grand total

-- Using it with one column, is nothing special, is like using a simple ROLLUP
SELECT department_id, COUNT(*) AS emp_count
FROM EMPLOYEES
WHERE department_id IS NOT NULL
GROUP BY CUBE(department_id)
ORDER BY department_id ASC;

-- Example 2: Cube with 2 variables
--            Getting the number of employees for each JOB_ID, for each department

/*
 * With 2 variables, we get some interesting results.....
 *     - On the first half of the table, JOB_ID is NULL, indicating CUBE is calculating the subtotals of the # of employees for each
 *       department
 *     - On the second half of the table, DEPARTMENT_ID is null, indicating CUBE is calculating the # of employes for each JOB_ID
 *     - At the end, we get the grand total of employees (106)
 *
 * So, to put it simple, we calculated the following combinations
 *     - (department_id, job_id) = Number of employees for that JOB_ID and DEPARTMENT_ID
 *     - (department_id, NULL  ) = Number of employees for that DEPARTMENT_ID
 *     - (NULL         , job_id) = Number of employees for a given JOB_ID
 *     - (NULL         , NULL  ) = The grand total of employees in this calculus
 */
SELECT department_id, job_id, COUNT(*) AS emp_count
FROM EMPLOYEES
WHERE department_id IS NOT NULL
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id ASC;

-- Example 3: CUBE with 3 variables
--            Getting all employees for each JOB_ID, in a given department, in a given country

/*
 * With CUBE, we are calculating the following combinations
 *     - (COUNTRY_ID, DEPARTMENT_ID, JOB_ID) = # of employees working in a specific JOB_ID for a given department in a given country
 *     - (COUNTRY_ID, DEPARTMENT_ID, NULL  ) = # of employees working in a given department in a given country
 *     - (COUNTRY_ID, NULL         , JOB_ID) = # of employees in a given JOB_ID for a given country
 *     - (COUNTRY_ID, NULL         , NULL  ) = # of employees working in a given country
 *     - (NULL      , DEPARTMENT_ID, JOB_ID) = # of employees working in a JOB_ID, inside a given department, around the world
 *     - (NULL      , DEPARTMENT_ID, NULL  ) = # of employees working in a given department, around the world
 *     - (NULL      , NULL         , JOB_ID) = # of employees working in a JOB_ID, around the world
 *     - (NULL      , NULL         , NULL  ) = # of employees working currently in the company
 */
SELECT country_id, department_id, job_id, COUNT(*) AS emp_count
FROM EMPLOYEES
JOIN DEPARTMENTS USING(department_id)
JOIN LOCATIONS USING(location_id)
WHERE department_id IS NOT NULL
GROUP BY CUBE(country_id, department_id, job_id)
ORDER BY country_id ASC;