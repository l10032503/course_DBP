CREATE OR REPLACE FUNCTION IS_NUMBER(str VARCHAR2) RETURN NUMBER
IS
   v_ret NUMBER;
BEGIN
   IF str IS NULL OR LENGTH(TRIM(str)) = 0 THEN
      RETURN 0;
   END IF;

   v_ret := TO_NUMBER(str);
   RETURN 1;

EXCEPTION WHEN OTHERS THEN
   RETURN 0;
END ;
/