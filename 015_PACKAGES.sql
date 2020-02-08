/*
 * Examples of packages in PL/SQL
 */

/*
 * Example 1: A basic example of packages
 */

-- Part 1: package specification
CREATE OR REPLACE PACKAGE EMP_DATA AS
    -- Types
    TYPE type_rec_emp_dept IS RECORD(first_name EMPLOYEES.first_name%TYPE,
                                last_name EMPLOYEES.last_name%TYPE,
                                department_name DEPARTMENTS.department_name%TYPE);
    TYPE type_tbl_emp_dept IS TABLE OF type_rec_emp_dept; 
    TYPE type_ref_cur IS REF CURSOR;
    
    -- Variables
    
    -- Procedures
    PROCEDURE GET_ALL_EMP_DEPT;
    PROCEDURE GET_EMP_BY_DEPT_ID(p_dept_id IN DEPARTMENTS.department_id%TYPE);
    
    -- Functions
    FUNCTION CALC_AVG_DEPT(p_dept_id IN DEPARTMENTS.department_id%TYPE) RETURN NUMBER;
END EMP_DATA;

-- Part 2: package body
CREATE OR REPLACE PACKAGE BODY EMP_DATA AS
    
    PROCEDURE GET_ALL_EMP_DEPT
    AS
        tbl_emp type_tbl_emp_dept;
        ref_cur type_ref_cur;
        
        v_query VARCHAR2(4000);
    BEGIN
        v_query := 'SELECT first_name, last_name, department_name FROM EMPLOYEES
                    JOIN DEPARTMENTS USING(department_id)';
        
        OPEN ref_cur FOR v_query;
        LOOP
            FETCH ref_cur BULK COLLECT INTO tbl_emp LIMIT 100;
            EXIT WHEN tbl_emp.COUNT = 0;
            
            FOR i IN 1..tbl_emp.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE('FULL NAME: ' || tbl_emp(i).first_name || ' ' || tbl_emp(i).last_name || ' DEPARTMENT: '
                                     || tbl_emp(i).department_name);
            END LOOP;
        END LOOP;
        CLOSE ref_cur;
    END;
    
    PROCEDURE GET_EMP_BY_DEPT_ID(p_dept_id IN DEPARTMENTS.department_id%TYPE)
    AS
        tbl_emp type_tbl_emp_dept;
        ref_cur type_ref_cur;
        
        v_query VARCHAR2(4000);
    BEGIN
        v_query := 'SELECT first_name, last_name, department_name FROM EMPLOYEES
                    JOIN DEPARTMENTS USING(department_id) WHERE department_id = :v0';
        
        OPEN ref_cur FOR v_query USING p_dept_id;
        LOOP
            FETCH ref_cur BULK COLLECT INTO tbl_emp LIMIT 100;
            EXIT WHEN tbl_emp.COUNT = 0;
            
            FOR i IN 1..tbl_emp.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE('FULL NAME: ' || tbl_emp(i).first_name || ' ' || tbl_emp(i).last_name || ' DEPARTMENT: '
                                     || tbl_emp(i).department_name);
            END LOOP;
        END LOOP;
        CLOSE ref_cur;
    END;
    
    FUNCTION CALC_AVG_DEPT(p_dept_id IN DEPARTMENTS.department_id%TYPE) RETURN NUMBER
    AS
        avg_sal NUMBER;
    BEGIN
        SELECT AVG(salary) INTO avg_sal
        FROM EMPLOYEES
        JOIN DEPARTMENTS USING(department_id)
        WHERE department_id = p_dept_id;
        
        RETURN avg_sal;
    END;
    
END EMP_DATA;

-- part 3: Let's test the package's functions
SET SERVEROUTPUT ON;
DECLARE
    avg_salary NUMBER;
BEGIN
    EMP_DATA.GET_ALL_EMP_DEPT();
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    EMP_DATA.GET_EMP_BY_DEPT_ID(30);
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    avg_salary := EMP_DATA.CALC_AVG_DEPT(30);
    DBMS_OUTPUT.PUT_LINE('The avg salary for department with ID 30 is: ' || avg_salary);
END;