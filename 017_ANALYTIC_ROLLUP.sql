/*
 * ROLLUP is a function used with GROUP BY. This function returns the grand total for a given group or
 * subgroup
 */

-- Example 1: Returning the Number of employees for each department, and the grand total of employees
SELECT department_id, COUNT(*) AS num_employees
FROM EMPLOYEES 
WHERE department_id IS NOT NULL
GROUP BY ROLLUP(department_id)
ORDER BY department_id;

-- Example 2: returning the number of employees for each job and each department, and the subtotal of number of employees
-- working on that department
SELECT department_id, job_id, COUNT(*) AS num_employees
FROM EMPLOYEES
WHERE department_id IS NOT NULL
GROUP BY ROLLUP(department_id, job_id)
ORDER BY department_id;

-- Example 3: returning number of employees for each job, by department, by country location, and the subtotal of number of
-- employees working on that department, working by each country
SELECT country_id, department_id, job_id, COUNT(*) AS emp_count, SUM(salary) AS cost FROM EMPLOYEES
JOIN DEPARTMENTS USING(department_id)
JOIN LOCATIONS USING(location_id)
WHERE department_id IS NOT NULL
GROUP BY ROLLUP(country_id, department_id, job_id)
ORDER BY country_id, department_id;


-- Example 4: What happens if we want to save the information given by the ROLLUP/GROUP BY query, just in case we need it
--            for future use?. Here's an example how we can do that, if you ant, you can convert the anonymous block into
--            a procedure or function
CREATE TABLE rollup_emp_dept_loc(
    report_id NUMBER(11),
    create_date DATE,
    country_id CHAR(2),
    department_id NUMBER(4),
    job_id VARCHAR2(10),
    emp_count NUMBER,
    cost_salary NUMBER(10,2)
);

CREATE SEQUENCE rollup_emp_dept_loc_seq
START WITH 1
INCREMENT BY 1;

DECLARE
    TYPE type_rec_rollup IS RECORD(country_id rollup_emp_dept_loc.country_id%TYPE,
                                    department_id rollup_emp_dept_loc.department_id%TYPE,
                                    job_id rollup_emp_dept_loc.job_id%TYPE,
                                    emp_count rollup_emp_dept_loc.emp_count%TYPE,
                                    cost_salary rollup_emp_dept_loc.cost_salary%TYPE);
    
    TYPE type_tbl_rollup IS TABLE OF type_rec_rollup INDEX BY BINARY_INTEGER;
    
    tbl_rollup type_tbl_rollup;
    report_id NUMBER;
    create_date DATE;
BEGIN
    -- Step 1: let's get the sequence number, and creation date
    report_id := rollup_emp_dept_loc_seq.NEXTVAL;
    create_date := sysdate;
    
    -- Step 2: make the query and store it in the table
    --         Remember to use BULK COLECT to store all the report data into the virtual table
    SELECT country_id, department_id, job_id, COUNT(*) AS emp_count, SUM(salary) AS cost_salary 
    BULK COLLECT INTO tbl_rollup
    FROM EMPLOYEES
    JOIN DEPARTMENTS USING(department_id)
    JOIN LOCATIONS USING(location_id)
    WHERE department_id IS NOT NULL
    GROUP BY ROLLUP(country_id, department_id, job_id)
    ORDER BY country_id, department_id;
    
    -- Step 3: now that we have the data, report_id, create_date, and report data, lets store it
    FOR i IN 1..tbl_rollup.COUNT LOOP
        INSERT INTO rollup_emp_dept_loc VALUES(report_id, create_date, tbl_rollup(i).country_id, tbl_rollup(i).department_id,
            tbl_rollup(i).job_id, tbl_rollup(i).emp_count, tbl_rollup(i).cost_salary);
    END LOOP;
    
    -- Step 4: show a message in console and commit if you want
    DBMS_OUTPUT.PUT_LINE('Report ID: ' || report_id || ' DATE: ' || create_date || ' Created successfully');
    COMMIT;
END;

-- Check the table to see the results
SELECT * FROM rollup_emp_dept_loc;