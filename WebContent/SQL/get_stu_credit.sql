CREATE OR REPLACE FUNCTION get_stu_credit(
session_id IN VARCHAR2
)
RETURN NUMBER
IS
v_credit NUMBER;
BEGIN

select SUM(c_credit)
into v_credit
from course
where (c_id, c_number, c_year, c_semester) IN
(select e.c_id, e.c_number, e.c_year, e.c_semester
from enroll e, student s
where e.s_id = s.s_id and s.s_id = session_id);

RETURN v_credit;

END;
/