/*
 * Examples of using Dynamic SQL using EXECUTE IMMEDIATE
 */

-- Example table to use with some records
CREATE TABLE dbusers(
    username VARCHAR2(100),
    userpass VARCHAR2(100),
    usertype VARCHAR2(50)
);

INSERT INTO dbusers VALUES('user1', 'user1', 'USER');
INSERT INTO dbusers VALUES('user2', 'user2', 'USER');
INSERT INTO dbusers VALUES('admin', 'admin', 'ADMIN');
COMMIT;



/*
 * Example 1: Basic usage of EXECUTE IMMEDIATE
 */
SET SERVEROUTPUT ON;
DECLARE
    command VARCHAR2(4000);
BEGIN
    -- You can create your own SQL, using if, for, etc, whatever you need to build the final query
    command := 'DELETE FROM dbusers';
    EXECUTE IMMEDIATE command;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Delete executed successfully');
END;

/*
 * Example 2: Filling a record, giving parameters
 */
DECLARE
    command VARCHAR2(4000);
    rec_dbuser dbusers%ROWTYPE;
BEGIN
    -- :v0 is the param we will fill later, when we execute the SQL string
    command := 'SELECT * FROM dbusers WHERE usertype=:v0';
    
    -- We give the parameters in order, using the "USING" keyword
    EXECUTE IMMEDIATE command INTO rec_dbuser USING 'ADMIN';
    
    DBMS_OUTPUT.PUT_LINE('Username: ' || rec_dbuser.username || ' type: ' || rec_dbuser.usertype);
END;

/*
 * Example 3: Dynamic SQL, BULK COLLECT, WEAK REF CURSORS, ASSCIATIVE ARRAYS -- Combining all together
 */
DECLARE
    -- Declaring table type, weak ref cur type
    TYPE type_tbl_dbuser IS TABLE OF DBUSERS%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE type_ref_cur IS REF CURSOR;
    
    -- Declaring variables
    tbl_dbuser type_tbl_dbuser;
    ref_cur type_ref_cur;
    
    command VARCHAR2(4000);
BEGIN
    command := 'SELECT * FROM dbusers WHERE usertype = :v0';
    
    -- Using Dynamic SQL with WEAK REF CURSORS is very easy
    OPEN ref_cur FOR command USING 'ADMIN';
    LOOP
        FETCH ref_cur BULK COLLECT INTO tbl_dbuser LIMIT 2;
        EXIT WHEN tbl_dbuser.COUNT = 0;
        
        FOR i IN 1..tbl_dbuser.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Username: ' || tbl_dbuser(i).username);
        END LOOP;
    END LOOP;
    CLOSE ref_cur;
END;