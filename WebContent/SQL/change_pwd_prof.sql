CREATE OR REPLACE PROCEDURE change_pwd_prof(
enterId IN VARCHAR2,
enterPwd IN VARCHAR2
)
IS
BEGIN
 UPDATE professor
 SET p_pwd = enterPwd
 WHERE p_id = enterId;
END;
/
