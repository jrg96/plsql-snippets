/*
 * Example of Associative Arrays (INDEX BY tables)
 */


/*
 * Example 1: Basic usage of associative arrays
 */
SET SERVEROUTPUT ON;
DECLARE
    -- First we must declare type
    TYPE type_tbl_employees IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY PLS_INTEGER;
    
    -- And later declare the variable itself
    tbl_employees type_tbl_employees;
    
    -- Creating a simple ref cursor
    TYPE type_ref_cur IS REF CURSOR;
    ref_cur type_ref_cur;
    
    i NUMBER := 1;
BEGIN
    OPEN ref_cur FOR 'SELECT * FROM EMPLOYEES';
    LOOP
        FETCH ref_cur INTO tbl_employees(i);
        EXIT WHEN ref_cur%NOTFOUND;
        
        i := i + 1;
    END LOOP;
    CLOSE ref_cur;
    
    -- Now we loop into the Data
    FOR b IN 1..i-1 LOOP
        DBMS_OUTPUT.PUT_LINE('Full name: ' || tbl_employees(b).first_name || ' ' || tbl_employees(b).last_name);
    END LOOP;
END;


/*
 * Example 2: Load multiple rows using Bulk Collect
 */
DECLARE
    TYPE type_tbl_emp IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE type_ref_cur IS REF CURSOR;
    
    tbl_emp type_tbl_emp;
    ref_cur type_ref_cur;
BEGIN
    OPEN ref_cur FOR 'SELECT * FROM EMPLOYEES';
    LOOP
        -- Now let's process 100 by 100
        FETCH ref_cur BULK COLLECT INTO tbl_emp LIMIT 100;
        EXIT WHEN tbl_emp.COUNT = 0;
        
        -- Let's loop all records
        FOR i IN 1 .. tbl_emp.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Full name: ' || tbl_emp(i).first_name || ' ' || tbl_emp(i).last_name);
        END LOOP;
    END LOOP;
    CLOSE ref_cur;
END;