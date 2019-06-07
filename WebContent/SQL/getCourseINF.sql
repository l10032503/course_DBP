CREATE OR REPLACE PROCEDURE getCourseINF
(vs_id IN varchar, 
vc_year IN number, 
vc_semester IN number,
vcourse OUT SYS_REFCURSOR)
AS
BEGIN
OPEN vcourse FOR
SELECT DISTINCT c.c_id, c.c_name, c.p_id, c.c_credit, c.c_number, c.c_major, c.c_period1, c.c_period2, c.c_day1, c.c_day2 FROM enroll e, course c WHERE e.s_id = vs_id AND (c.c_id, c.c_number, c.c_year, c.c_semester) IN ((e.c_id, e.c_number, vc_year, vc_semester));
END;
/