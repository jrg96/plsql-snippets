/*
 * Examples of using NESTED TABLES in PL/SQL
 */

/*
 * Example 1: NESTED TABLES, BULK COLLECT, REF CURSORS
 */
DECLARE
    -- Declaring types
    TYPE type_nested_emp IS TABLE OF EMPLOYEES%ROWTYPE;
    TYPE type_ref_cur IS REF CURSOR;
    
    -- Declaring variables
    tbl_emp type_nested_emp;
    ref_cur type_ref_cur;
BEGIN
    OPEN ref_cur FOR 'SELECT * FROM EMPLOYEES';
    LOOP
        tbl_emp := type_nested_emp();
        FETCH ref_cur BULK COLLECT INTO tbl_emp LIMIT 100;
        EXIT WHEN tbl_emp.COUNT = 0;
        
        FOR i IN 1..tbl_emp.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Full name: ' || tbl_emp(i).first_name || ' ' || tbl_emp(i).last_name);
        END LOOP;
    END LOOP;
    CLOSE ref_cur;
END;