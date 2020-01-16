/*
 * Examples of using Records with DML operations (Insert/Update/Delete)
 *
 * Schema used: HR
 */
 
-- PREPARE THE TABLE IN ORDER TO MAKE THE PRACTICE
CREATE TABLE retired_employees AS SELECT * FROM employees WHERE 1 = 2;


/*
 * Example 1: Make an insert using a record
 */
SET SERVEROUTPUT ON;
DECLARE
    rec_employee EMPLOYEES%ROWTYPE;
BEGIN
    -- Let's query a row from the EMPLOYEES table
    SELECT * 
    INTO rec_employee
    FROM employees
    WHERE employee_id = 100;
    
    rec_employee.salary := 0;
    rec_employee.commission_pct := 0;
    
    -- Instead of specyfing each value in the VALUES() keyword, we simply pass the record
    INSERT INTO retired_employees VALUES rec_employee;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Retired employee inserted successfully!');
END;


/*
 * Example 2: make an update using a record
 */
SET SERVEROUTPUT ON;
DECLARE
    rec_employee RETIRED_EMPLOYEES%ROWTYPE;
BEGIN
    SELECT *
    INTO rec_employee
    FROM RETIRED_EMPLOYEES
    WHERE employee_id = 100;
    
    -- Doing some changes just to see the result
    rec_employee.salary := 100;
    
    -- Instead of using SET for each column we want to modify, we use the keyword SET ROW
    UPDATE RETIRED_EMPLOYEES SET ROW = rec_employee WHERE employee_id = rec_employee.employee_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Row updated successfully!');
END;


/*
 * Example 3: delete a row using a record
 */
SET SERVEROUTPUT ON;
DECLARE
    rec_employee RETIRED_EMPLOYEES%ROWTYPE;
BEGIN
    SELECT *
    INTO rec_employee
    FROM RETIRED_EMPLOYEES
    WHERE employee_id = 100;
    
    -- DELETE doesn't change at all, because we always delete the entire row
    DELETE FROM RETIRED_EMPLOYEES WHERE employee_id = rec_employee.employee_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Row deleted successfully');
END;