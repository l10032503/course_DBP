
CREATE OR REPLACE FUNCTION get_prof_credit(
session_id IN VARCHAR2,
nYear IN NUMBER,
nSemester IN NUMBER
)
RETURN NUMBER
IS
v_credit NUMBER;
BEGIN

select SUM(c_credit)
into v_credit
from course
where c_year = nYear and c_semester = nSemester and p_id = session_id;

RETURN v_credit;

END;
/