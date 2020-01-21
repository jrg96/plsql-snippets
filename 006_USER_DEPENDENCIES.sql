/*
 * Examples of how user_dependencies and user_objetcs can help us detect invalid dependencies 
 */


-- Get dependencies from an object
SELECT * FROM USER_DEPENDENCIES WHERE NAME = 'DEPARTMENTS';

-- Knowing which objects depends of 'OBJ'
SELECT * FROM USER_DEPENDENCIES WHERE REFERENCED_NAME = 'EMPLOYEES';

-- Knowing which objects have a STATUS of INVALID
SELECT * FROM USER_OBJECTS WHERE STATUS = 'INVALID';


/*
 * Example of how invalidation happens in oracle
 */

-- Step 1: create table
CREATE TABLE test_tbl(f1 NUMBER, f2 NUMBER);

-- Step 2: create a view who is dependent on test_tbl
CREATE VIEW dependent_view AS SELECT f1 FROM test_tbl;

-- Step 3: let's check the status of each obj (the table and the view)
SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME = 'TEST_TBL';
SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME = 'DEPENDENT_VIEW';

-- Step 4: let's invalidate DEPENDENT_VIEW by changing the type of column f1
--         And later let's see the status (now the view will be invalid)
ALTER TABLE TEST_TBL MODIFY f1 VARCHAR2(400);
SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME = 'DEPENDENT_VIEW';

-- Step 5: Oracle is very smart, so even if the view is invalid, it will try to solve the problem
--         When we invoke the view, instead of giving us an error. If it is not possible, it will give us an error
SELECT * FROM DEPENDENT_VIEW;
SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME = 'DEPENDENT_VIEW';

-- Step 6: We will drop the column on purpose, to see this time, Oracle won't solve the invalid problem
ALTER TABLE TEST_TBL DROP COLUMN f1;
SELECT * FROM DEPENDENT_VIEW;
SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME = 'DEPENDENT_VIEW';