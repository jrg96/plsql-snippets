/*
 * Examples of using LOBS (CLOB, BLOB, BFILE) in PL/SQL
 */

/*
 * Example 1: Creating CLOB and BLOB with tables, and basic usage
 */
CREATE TABLE test_lob(
    first_name VARCHAR2(100),
    text CLOB,
    photo BLOB
);

-- If we don't have the CLOB and BLOB data yet, we can insert a row using EMPTY_CLOB, EMPTY_BLOB
INSERT INTO test_lob VALUES('Jorge', EMPTY_CLOB(), EMPTY_BLOB());
COMMIT;
SELECT * FROM test_lob;


/*
 * Eample 2: Using Directory objects
 */

-- Step 1: create a physical directory in your OS (will create mine at C:/data_dir)

-- Step 2: We create the Oracle Object that represents the physical directory
CREATE OR REPLACE DIRECTORY DATA_DIR_DIRECTORY AS 'c:/data_dir';


/*
 * Example 3: Load a BFILE into a row
 */

-- Step 1: let's create the table that will store the BFILE
CREATE TABLE test_photo(
    photo_name VARCHAR2(200),
    photo_data BFILE
);

-- Step 2: let's insert the file using PL/SQL
DECLARE
    photo BFILE;
BEGIN
    -- BFILENAME receives 2 parameters: the name of the DIRECTORY OBJECT, and the physical name of the file we want to point
    photo := BFILENAME('DATA_DIR_DIRECTORY', 'cat.jpg');
    
    -- Let's insert the photo
    INSERT INTO test_photo VALUES('image name', photo);
    COMMIT;
END;

SELECT * FROM test_photo;


/*
 * Example 4: Load a BFILE into a BLOB row
 */
DECLARE
    filename VARCHAR2(100);
    file_obj BFILE;
    
    temporary_blob BLOB;
BEGIN
    -- Step 1: Let's load the BFILE in memory first
    filename := 'cat.jpg';
    file_obj := BFILENAME('DATA_DIR_DIRECTORY', filename);
    
    -- Step 2: Let's move the data of the BFILE, into a BLOB
    DBMS_LOB.OPEN(file_obj, DBMS_LOB.LOB_READONLY);
    DBMS_LOB.CREATETEMPORARY(temporary_blob, TRUE);
    DBMS_LOB.LOADFROMFILE(temporary_blob, file_obj, DBMS_LOB.GETLENGTH(file_obj));
    
    -- Step 3: Make the insert/update
    INSERT INTO test_lob VALUES('Jorge', 'CLOB_DATA', temporary_blob);
    COMMIT;
    
    -- Step 4: free resources
    DBMS_LOB.CLOSE(file_obj);
END;