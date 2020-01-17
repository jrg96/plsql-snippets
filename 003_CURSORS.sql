/*
 * Examples of cursors
 */

-- Example 1: basic usage of a cursor
SET SERVEROUTPUT ON;
DECLARE
    CURSOR cur_emp_dept IS
        SELECT employee_id, first_name, last_name, department_name FROM EMPLOYEES
        JOIN DEPARTMENTS USING(department_id);
    
    -- We can declare a record that is the type of a cursor
    rec_emp_dept cur_emp_dept%ROWTYPE;
BEGIN
    OPEN cur_emp_dept;
    FETCH cur_emp_dept INTO rec_emp_dept;
    CLOSE cur_emp_dept;
    
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec_emp_dept.employee_id || ' Full name: ' || rec_emp_dept.first_name || ' ' || rec_emp_dept.last_name
                          || ' Department: ' || rec_emp_dept.department_name);
END;


/*
 * Example 2: you can declare a record to fetch a cursor too
 */
SET SERVEROUTPUT ON;
DECLARE
    TYPE type_rec_emp_dept IS RECORD(employee_id EMPLOYEES.employee_id%TYPE,
                                     first_name EMPLOYEES.first_name%TYPE,
                                     last_name EMPLOYEES.last_name%TYPE,
                                     department_name DEPARTMENTS.department_name%TYPE);
    
    CURSOR cur_emp_dept IS 
        SELECT employee_id, first_name, last_name, department_name
        FROM EMPLOYEES JOIN DEPARTMENTS USING(department_id);
        
    rec_emp_dept type_rec_emp_dept;
BEGIN
    OPEN cur_emp_dept;
    FETCH cur_emp_dept INTO rec_emp_dept;
    CLOSE cur_emp_dept;
    
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec_emp_dept.employee_id || ' Full name: ' || rec_emp_dept.first_name || ' ' || rec_emp_dept.last_name
                          || ' Department: ' || rec_emp_dept.department_name);
END;

/*
 * Example 3: Form 1 to get all records from a cursor
 */
DECLARE
    CURSOR cur_emp_dept IS
        SELECT employee_id, first_name, last_name, department_name
        FROM EMPLOYEES JOIN DEPARTMENTS USING(department_id);
    
    rec_emp_dept cur_emp_dept%ROWTYPE;
BEGIN
    OPEN cur_emp_dept;
    LOOP
        -- Fetch first, and later check if we found a record
        FETCH cur_emp_dept INTO rec_emp_dept;
        EXIT WHEN cur_emp_dept%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec_emp_dept.employee_id || ' Full name: ' || rec_emp_dept.first_name || ' ' || rec_emp_dept.last_name
                          || ' Department: ' || rec_emp_dept.department_name);
    END LOOP;
    CLOSE cur_emp_dept;
END;

/*
 * Example 4: Form 2 to get all records from a cursor (we don't need to specify a record at all)
 */
DECLARE
    CURSOR cur_emp_dept IS
        SELECT employee_id, first_name, last_name, department_name
        FROM EMPLOYEES JOIN DEPARTMENTS USING(department_id);
BEGIN
    FOR rec_emp_dept IN cur_emp_dept LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec_emp_dept.employee_id || ' Full name: ' || rec_emp_dept.first_name || ' ' || rec_emp_dept.last_name
                          || ' Department: ' || rec_emp_dept.department_name);
    END LOOP;
END;