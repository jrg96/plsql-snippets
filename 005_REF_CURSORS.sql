/*
 * REF CURSORS: cursors which SQL statement is a dynamic query (String generated queries)
 *
 * There are 2 types of ref cursors:
 *     - STRONG: we specify the type (record) it will return
 *     - WEAK: we don't specify the type (record) it will return
 */


/*
 * Example 1: declaring a strong ref cursor
 *
 * SIDE NOTE: Strong ref cursors doesn't allow strings as queries, but you can open the cursor
 *            with any SQL statement when you OPEN it
 */
SET SERVEROUTPUT ON;
DECLARE
    -- the record could be a %ROWTYPE for the strong ref cursor
    TYPE type_rec_emp_dept IS RECORD(employee_id EMPLOYEES.employee_id%TYPE,
                                     first_name EMPLOYEES.first_name%TYPE,
                                     last_name EMPLOYEES.last_name%TYPE,
                                     department_name DEPARTMENTS.department_name%TYPE);
    
    -- the record could be a %ROWTYPE for the strong cursor, i.e EMPLOYEES%ROWTYPE
    TYPE type_cur_emp_dept IS REF CURSOR RETURN type_rec_emp_dept;
    
    rec_emp_dept type_rec_emp_dept;
    cur_emp_dept type_cur_emp_dept;
    
    v_department_id DEPARTMENTS.department_id%TYPE;
BEGIN
    v_department_id := 30;
    
    -- Now open the cursor using the SQL query
    OPEN cur_emp_dept FOR 
        SELECT employee_id, first_name, last_name, department_name
        FROM EMPLOYEES JOIN DEPARTMENTS USING(department_id)
        WHERE department_id = v_department_id;
    LOOP
        FETCH cur_emp_dept INTO rec_emp_dept;
        EXIT WHEN cur_emp_dept%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec_emp_dept.employee_id || ' Full name: ' || rec_emp_dept.first_name || ' ' || rec_emp_dept.last_name
                          || ' Department: ' || rec_emp_dept.department_name);
    END LOOP;
    CLOSE cur_emp_dept;
END;


/*
 * Example 2: declaring a wek ref cursor
 *
 * SIDE NOTE: weak ref cursors can be used with string dynamic queries, but you have to be careful that the rows returned by 
 *            the dynamic query, return the columns of the same type of your declared type record
 */
SET SERVEROUTPUT ON;
DECLARE
    TYPE type_rec_emp_dept IS RECORD(employee_id EMPLOYEES.employee_id%TYPE,
                                     first_name EMPLOYEES.first_name%TYPE,
                                     last_name EMPLOYEES.last_name%TYPE,
                                     department_name DEPARTMENTS.department_name%TYPE);
    
    -- In weak ref cursors, we don't specify the return TYPE
    TYPE type_cur_emp_dept IS REF CURSOR;
    
    rec_emp_dept type_rec_emp_dept;
    ref_cur_emp_dept type_cur_emp_dept;
    
    v_query VARCHAR2(4000);
BEGIN
    v_query := 'SELECT employee_id, first_name, last_name, department_name
                FROM EMPLOYEES JOIN DEPARTMENTS USING(department_id)
                WHERE department_id = :v0';
    
    OPEN ref_cur_emp_dept FOR v_query USING 30;
    LOOP
        FETCH ref_cur_emp_dept INTO rec_emp_dept;
        EXIT WHEN ref_cur_emp_dept%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec_emp_dept.employee_id || ' Full name: ' || rec_emp_dept.first_name || ' ' || rec_emp_dept.last_name
                          || ' Department: ' || rec_emp_dept.department_name);
    END LOOP;
    CLOSE ref_cur_emp_dept;
END;