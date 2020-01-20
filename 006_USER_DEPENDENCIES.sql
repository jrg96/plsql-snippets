/*
 * Examples of how user_dependencies and user_objetcs can help us detect invalid dependencies 
 */


-- Get dependencies from an object
SELECT * FROM USER_DEPENDENCIES WHERE NAME = 'DEPARTMENTS';

-- Knowing which objects depends of 'OBJ'
SELECT * FROM USER_DEPENDENCIES WHERE REFERENCED_NAME = 'EMPLOYEES';

