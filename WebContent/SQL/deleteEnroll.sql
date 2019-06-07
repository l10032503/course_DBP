CREATE OR REPLACE PROCEDURE deleteEnroll(studentID IN VARCHAR2, courseID IN VARCHAR2,
               courseIDNO IN NUMBER)
IS
   CURSOR courseLIST(student_id VARCHAR2) IS
   SELECT NVL(c_id, 0) c_id
   FROM enroll
   WHERE s_id = student_id;


   courseMAX NUMBER;
   coursecurrent NUMBER;
   nYEAR NUMBER;
   nSEMESTER NUMBER;
   courseCREDIT NUMBER;
   
BEGIN
   
   nYEAR := Date2EnrollYear(SYSDATE);
   nSEMESTER := Date2EnrollSemester(SYSDATE);
   
   DBMS_OUTPUT.put_line(studentID || ' / ' || courseID ||
   ' / ' || courseIDNO );
   
 
select c_current, c_credit
into coursecurrent, courseCREDIT
from course
where c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;

UPDATE COURSE
SET c_current = coursecurrent -1
where c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;



DELETE FROM ENROLL
where c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;

   
COMMIT;
 


END;
/

 show error;