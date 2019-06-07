CREATE OR REPLACE PROCEDURE change_pwd(
enterId IN VARCHAR2,
enterPwd IN VARCHAR2
)
IS
BEGIN
 UPDATE student
 SET s_pwd = enterPwd
 WHERE s_id = enterId;
END;
/
