/*
 * Examples of using records in PL/SQL with queries
 *
 */
 
 

-- Example 1: Make a record based on a row (%ROWTYPE)
--            Remember to load the whole row into the record
SET SERVEROUTPUT ON;
DECLARE
    rec_employee EMPLOYEES%ROWTYPE;
BEGIN
    SELECT * INTO rec_employee
    FROM EMPLOYEES
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec_employee.employee_id || ' Full name: ' || rec_employee.first_name || ' ' || rec_employee.last_name);
END;


/* Example 2: Declaring your own record, only with the data you need
 *
 * ADVANTAGES: you can get only the data you need
 * DISADVANTAGES: if your DB model changes or you need to get more data, you have to add the new fields to the record
 */
SET SERVEROUTPUT ON;
DECLARE
    TYPE type_rec_emp IS RECORD(employee_id EMPLOYEES.employee_id%TYPE,
                                first_name EMPLOYEES.first_name%TYPE,
                                last_name EMPLOYEES.last_name%TYPE);
    
    -- Don't forget to declare a variable that uses the type_rec_emp type
    rec_employee type_rec_emp;
BEGIN
    -- We don't need to specify each field of the record where data will be stored into the record, if we query
    -- it in the same order of the record (first employee_id like the record, 2nd the first_name like the record
    -- 3rd last_name like the record)
    SELECT employee_id, first_name, last_name
    INTO rec_employee
    FROM EMPLOYEES
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec_employee.employee_id || ' Full name: ' || rec_employee.first_name || ' ' || rec_employee.last_name);
END;


/*
 * Example 3: querying the data into a user defined record, specifying the order of the record fields to store the data
 */
SET SERVEROUTPUT ON;
DECLARE
    TYPE type_rec_emp IS RECORD(employee_id EMPLOYEES.employee_id%TYPE,
                                first_name EMPLOYEES.first_name%TYPE,
                                last_name EMPLOYEES.last_name%TYPE);
    
    -- Don't forget to declare a variable that uses the type_rec_emp type
    rec_employee type_rec_emp;
BEGIN
    -- We specify the fields of the record where the data of the query will be stored
    SELECT employee_id, first_name, last_name
    INTO rec_employee.employee_id, rec_employee.first_name, rec_employee.last_name
    FROM EMPLOYEES
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec_employee.employee_id || ' Full name: ' || rec_employee.first_name || ' ' || rec_employee.last_name);
END;


/*
 * Example 4: Storing the result of a JOIN into a record
 */ 
SET SERVEROUTPUT ON;
DECLARE
    TYPE type_rec_emp_dept IS RECORD(employee_id EMPLOYEES.employee_id%TYPE,
                                     first_name EMPLOYEES.first_name%TYPE,
                                     last_name EMPLOYEES.last_name%TYPE,
                                     department_name DEPARTMENTS.department_name%TYPE);
    
    rec_employee type_rec_emp_dept;
BEGIN 
    SELECT employee_id, first_name, last_name, department_name
    INTO rec_employee
    FROM EMPLOYEES
    JOIN DEPARTMENTS USING(department_id)
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec_employee.employee_id || ' Full name: '
                         || rec_employee.first_name || ' ' || rec_employee.last_name
                         || ' Department: ' || rec_employee.department_name);
END;