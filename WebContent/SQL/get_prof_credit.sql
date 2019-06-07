CREATE OR REPLACE FUNCTION get_prof_credit(
session_id IN VARCHAR2
)
RETURN NUMBER
IS
v_credit NUMBER;
BEGIN

select SUM(c_credit)
into v_credit
from professor p, course c
where p.p_id = c.p_id and p.p_id = session_id;

RETURN v_credit;

END;
/