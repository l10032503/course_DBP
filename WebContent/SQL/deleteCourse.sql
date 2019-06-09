CREATE OR REPLACE PROCEDURE deleteCourse(courseID IN VARCHAR2,
               courseIDNO IN NUMBER)
IS

   coursecurrent NUMBER;
   nYEAR NUMBER;
   nSEMESTER NUMBER;
   courseCREDIT NUMBER;
   
BEGIN
   
   nYEAR := Date2EnrollYear(SYSDATE);
   nSEMESTER := Date2EnrollSemester(SYSDATE);
 
select c_current, c_credit
into coursecurrent, courseCREDIT
from course
where c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;

DELETE FROM ENROLL
where c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;

DELETE FROM COURSE
where c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;

COMMIT;
 
END;
/

 show error;