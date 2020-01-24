/*
 * Examples of how to enchance PL/SQL Performance with CACHING
 */

/*
 * Example 1: Change CACHE SIZE (as SYS)
 */
ALTER SYSTEM SET RESULT_CACHE_MAX_SIZE = 100M;


/*
 * Example 2: Get status of the cache, and report status
 */
SET SERVEROUTPUT ON;
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE(DBMS_RESULT_CACHE.STATUS);
    DBMS_RESULT_CACHE.MEMORY_REPORT;
END;

/*
 * Example 3: Using CACHE through Hints
 */
 SELECT /*+ RESULT_CACHE */ * FROM EMPLOYEES;

/*
 * Example 4: Check if we are really using the cache (need to be logged as SYS)
 */
SELECT * FROM V$RESULT_CACHE_STATISTICS;