/*
 * Example of using cursors with variables
 */
SET SERVEROUTPUT ON;
DECLARE
    CURSOR cur_emp_dept(p_department_id NUMBER)IS
        SELECT employee_id, first_name, last_name, department_name
        FROM EMPLOYEES JOIN DEPARTMENTS USING(department_id)
        WHERE department_id = p_department_id;
BEGIN
    FOR rec_emp_dept IN cur_emp_dept(30) LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec_emp_dept.employee_id || ' Full name: ' || rec_emp_dept.first_name || ' ' || rec_emp_dept.last_name
                          || ' Department: ' || rec_emp_dept.department_name);
    END LOOP;
END;