/* update.jsp */
CREATE OR REPLACE PROCEDURE show_stu_info(
id IN VARCHAR2,
pwd OUT VARCHAR2,
name OUT VARCHAR2,
grade OUT NUMBER,
major OUT VARCHAR2,
isLeaved_out OUT NUMBER
)
IS

BEGIN

select s_pwd, s_name, s_grade, s_major, isLeaved
into pwd, name, grade, major, isLeaved_out
from student
where s_id = id;

END;
/