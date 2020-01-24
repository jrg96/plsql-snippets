/*
 * Examples of Database triggers
 */

/*
 * Example 1: database trigger that registers all objects dropped
 */
CREATE TABLE trigger_log(
    trigger_desc VARCHAR2(4000),
    event_date DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER delete_obj_trigger
AFTER DROP
ON DATABASE
BEGIN
    INSERT INTO trigger_log(trigger_desc) 
    VALUES('Deleted the object: ' || ORA_DICT_OBJ_NAME || ' type: ' || ORA_DICT_OBJ_TYPE || ' Owner: ' || ORA_DICT_OBJ_OWNER);
END;

/*
 * Example 2: system trigger
 */
CREATE TABLE user_login_control(
    logged_user VARCHAR2(100),
    logged_ip VARCHAR2(20),
    logged_date DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER register_login
AFTER LOGON
ON DATABASE
BEGIN
    INSERT INTO user_login_control(logged_user, logged_ip) VALUES(ORA_LOGIN_USER, ORA_CLIENT_IP_ADDRESS);
END;

/*
 * Example 3: trigger that registers all errors generated from SQL code
 */
CREATE TABLE error_sql_control(
    logged_user VARCHAR2(100),
    error_message VARCHAR2(4000),
    sql_command VARCHAR2(4000),
    logged_date DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER sql_error_trigger
AFTER SERVERERROR
ON DATABASE
DECLARE
    SQL_TEXT ORA_NAME_LIST_T;
    MESSAGE VARCHAR2(2000):=NULL;
    COMMAND VARCHAR2(200):=NULL;
BEGIN
    FOR X IN 1..ORA_SERVER_ERROR_DEPTH LOOP
        MESSAGE:=MESSAGE || ORA_SERVER_ERROR_MSG(X);
    END LOOP;
    
    FOR I IN 1..ORA_SQL_TXT(SQL_TEXT) LOOP
        COMMAND:=COMMAND||SQL_TEXT(I);
    END LOOP;
    
    INSERT INTO error_sql_control(logged_user, error_message, sql_command) VALUES(ORA_LOGIN_USER, MESSAGE, COMMAND);
END;