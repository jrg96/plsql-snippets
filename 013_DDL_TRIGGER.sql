/*
 * Examples of DDL triggers
 */

/*
 * Example 1: DLL trigger to register when a user drops an objetc
 */
CREATE TABLE trigger_log(
    trigger_desc VARCHAR2(4000),
    event_date DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER delete_obj_trigger
AFTER DROP
ON SCHEMA
BEGIN
    INSERT INTO trigger_log(trigger_desc) VALUES('Deleted the object: ' || ORA_DICT_OBJ_NAME || ' type: ' || ORA_DICT_OBJ_TYPE);
END;

-- Example to see if we capture the correct info
CREATE TABLE tabl(f1 VARCHAR2(100));
DROP TABLE tabl;
SELECT * FROM trigger_log;