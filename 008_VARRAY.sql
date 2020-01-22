/*
 * Examples of how VARRAY is used
 */

/*
 * Example 1: VARRAY with BULK COLLECT and ref cursors
 */
SET SERVEROUTPUT ON;
DECLARE
    TYPE type_varray_emp IS VARRAY(100) OF EMPLOYEES%ROWTYPE;
    TYPE type_ref_cur IS REF CURSOR;
    
    tbl_emp type_varray_emp;
    
    ref_cur type_ref_cur;
BEGIN
    OPEN ref_cur FOR 'SELECT * FROM EMPLOYEES';
    LOOP
        -- For each loop, let's initiaize the VARRAY with 0 elements
        tbl_emp := type_varray_emp();
        
        -- Let's load some data and do the processing
        FETCH ref_cur BULK COLLECT INTO tbl_emp LIMIT 100;
        EXIT WHEN tbl_emp.COUNT = 0;
        
        FOR i IN 1..tbl_emp.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Full name: ' || tbl_emp(i).first_name || ' ' || tbl_emp(i).last_name);
        END LOOP;
    END LOOP;
    CLOSE ref_cur;
END;

/*
 * Example 2: VARRAYS as columns in a table
 */

-- Step 1: let's create a VARRAY object into the schema
CREATE OR REPLACE TYPE type_varray_varchar IS VARRAY(80) OF VARCHAR2(100);

-- Step2: let's create a table using our new VARRAY type
CREATE TABLE tbl_varray_ex(
    first_name VARCHAR2(100) NOT NULL,
    phones type_varray_varchar
);

-- Step 3: let's see what we can do with VARRAYS column type
-- Insert
INSERT INTO tbl_varray_ex(first_name, phones) VALUES('Jorge', type_varray_varchar('1111-1111', '2222-2222'));
COMMIT;

-- Select
SELECT * FROM tbl_varray_ex;

-- Let's query the VARRAY data
SELECT first_name, T.* FROM tbl_varray_ex, TABLE(tbl_varray_ex.phones) T
WHERE T.COLUMN_VALUE = '2222-2222';

