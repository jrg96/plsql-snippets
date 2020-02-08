/*
 * Examples of triggers
 */
SET SERVEROUTPUT ON;

/*
 * Example 1: Choosing the TIMING and ACTION of DML triggers
 *
 * There are 3 timings: BEFORE, AFTER, INSTEAD OF
 * There are 3 actions: INSERT, DELETE, UPDATE
 */
CREATE OR REPLACE TRIGGER test_trigger
BEFORE INSERT OR UPDATE
ON EMPLOYEES_COPY
BEGIN
    DBMS_OUTPUT.PUT_LINE('An insert/update of EMPLOYEES_COPY has been detected');
END;

UPDATE EMPLOYEES_COPY SET salary = salary + 10;
ROLLBACK;

/*
 * Example 2: ROW LEVEL triggers (using OLD and NEW), logging values of EMP table
 */

-- Step 1: Let's create the table that will log the old values (just in case we need to rollback for any reason)
CREATE TABLE EMPLOYEES_LOG AS SELECT * FROM EMPLOYEES WHERE 1 = 2;
ALTER TABLE EMPLOYEES_LOG ADD log_operation VARCHAR2(100);
ALTER TABLE EMPLOYEES_LOG ADD log_date DATE;

-- Step 2: Let's create the trigger will affect the EMPLOYEES_COPY
CREATE OR REPLACE TRIGGER log_old_val_emp
AFTER UPDATE
ON EMPLOYEES_COPY
FOR EACH ROW
BEGIN
    -- Since we are trying to log the old values, we are just gonna use OLD
    INSERT INTO EMPLOYEES_LOG VALUES(:OLD.employee_id, :OLD.first_name, :OLD.last_name, :OLD.email, :OLD.phone_number,
        :OLD.hire_date, :OLD.job_id, :OLD.salary, :OLD.commission_pct, :OLD.manager_id, :OLD.department_id, 'UPDATE', SYSDATE);
END;

-- Step 3: Let's update a record and let's see the log
UPDATE EMPLOYEES_COPY SET salary = salary + 10 WHERE employee_id = 100;
SELECT * FROM EMPLOYEES_LOG;
SELECT * FROM EMPLOYEES_COPY WHERE employee_id = 100;