CREATE OR REPLACE PROCEDURE getCourseINF_Prof
(vp_id IN varchar, 
vc_year IN number, 
vc_semester IN number,
vcourse OUT SYS_REFCURSOR)
AS
BEGIN
OPEN vcourse FOR
SELECT DISTINCT c_id, c_name, c_credit, c_number, c_major, c_period1, c_period2, c_day1, c_day2, c_max, c_current 
FROM course c 
WHERE  p_id = vp_id 
AND (c_year, c_semester) IN ((vc_year, vc_semester));
END;
/