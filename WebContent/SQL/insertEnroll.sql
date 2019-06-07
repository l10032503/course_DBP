CREATE OR REPLACE PROCEDURE InsertEnroll(studentID IN VARCHAR2, courseID IN VARCHAR2,
               courseIDNO IN NUMBER, result OUT VARCHAR2 )
IS
   CURSOR courseLIST(student_id VARCHAR2) IS
   SELECT NVL(c_id, 0) c_id
   FROM enroll
   WHERE s_id = student_id;

   credit_limit_over EXCEPTION;
   duplicate_course EXCEPTION;
   too_many_students EXCEPTION;
   duplicate_period EXCEPTION;
   courseSUM NUMBER;
   courseCREDIT NUMBER;
   courseCOUNT NUMBER;
   periodCOUNT1 NUMBER;
   periodCOUNT2 NUMBER;
   courseMAX NUMBER;
   courseCURRENT NUMBER;
   nYEAR NUMBER;
   nSEMESTER NUMBER;

BEGIN
   result := ' ';
   nYEAR := Date2EnrollYear(SYSDATE);
   nSEMESTER := Date2EnrollSemester(SYSDATE);
   
   DBMS_OUTPUT.put_line(studentID || ' / ' || courseID ||
   ' / ' || courseIDNO );

   /*�ִ����� �ʰ�*/
   SELECT SUM(c.c_credit)
   INTO courseSUM
   FROM course c, enroll e
   WHERE e.s_id = studentID AND e.c_id = c.c_id AND e.c_number = c.c_number AND e.c_year = nYEAR AND e.c_semester = nSEMESTER
	AND c.c_year = nYEAR AND c.c_semester = nSEMESTER;
   
   IF courseSUM IS NULL THEN
      courseSUM := 0;
   END IF;   

   SELECT c_credit
   INTO courseCREDIT
   FROM course
   WHERE c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;
   
   DBMS_OUTPUT.put_line(courseSUM || ' / ' || courseCREDIT);
   
   IF (courseSUM + courseCREDIT) >18 THEN
      RAISE credit_limit_over;
   END IF;

   /*�ߺ��� ����*/
   FOR course_list IN courseLIST(studentID) LOOP
      IF course_list.c_id = courseID THEN
         RAISE duplicate_course;
      END IF;
   END LOOP;

   /*������û �ο� �ʰ�*/
   SELECT c_max, c_current
   INTO courseMAX, courseCURRENT
   FROM course
   WHERE c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;

   DBMS_OUTPUT.put_line(courseMAX || ' / ' || courseCURRENT);

   IF (courseCURRENT+1) > courseMAX THEN
      RAISE too_many_students;
   END IF;
   
   /*�ߺ��� �ð�*/
   SELECT COUNT(*)
   INTO periodCOUNT1
   FROM course c
   WHERE c.c_id = courseID AND c_number = courseIDNO AND c.c_year = nYEAR AND c.c_semester = nSEMESTER AND c.c_period1 IN (SELECT c.c_period1
         FROM enroll e, course c 
         WHERE e.s_id = studentID AND e.c_id = c.c_id AND c.c_id != courseID AND e.c_number = c.c_number 
                     AND e.c_year = nYEAR AND e.c_semester = nSEMESTER AND c.c_year = nYEAR AND c.c_semester = nSEMESTER
	        AND (e.c_id, e.c_number) IN (
                     SELECT enrolled_c.c_id, enrolled_c.c_number
                     FROM course new_c INNER JOIN course enrolled_c
                     ON new_c.c_day1 = enrolled_c.c_day1
                     WHERE new_c.c_id = courseID AND new_c.c_number = courseIDNO));

   SELECT COUNT(*)
   INTO periodCOUNT2
   FROM course c
   WHERE c.c_id = courseID AND c_number = courseIDNO AND c.c_year = nYEAR AND c.c_semester = nSEMESTER AND c.c_period2 IN (SELECT c.c_period2
         FROM enroll e, course c 
         WHERE e.s_id = studentID AND e.c_id = c.c_id AND c.c_id != courseID AND e.c_number = c.c_number 
                     AND e.c_year = nYEAR AND e.c_semester = nSEMESTER AND c.c_year = nYEAR AND c.c_semester = nSEMESTER
	        AND (e.c_id, e.c_number) IN (
                     SELECT enrolled_c.c_id, enrolled_c.c_number
                     FROM course new_c INNER JOIN course enrolled_c
                     ON new_c.c_day2 = enrolled_c.c_day2
                     WHERE new_c.c_id = courseID AND new_c.c_number = courseIDNO));

   DBMS_OUTPUT.put_line(periodCOUNT1 || ' / ' || periodCOUNT2);

   IF periodCOUNT1 > 0 OR periodCOUNT2 > 0 THEN
      RAISE duplicate_period;
   END IF;

   INSERT INTO enroll(s_id, c_id, c_number, c_year, c_semester)
   VALUES (studentID, courseID, courseIDNO, nYEAR, nSEMESTER);
   
   UPDATE course
   SET c_current = courseCURRENT + 1
   WHERE c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;


   result := '������û�� �Ϸ�Ǿ����ϴ�.';
   DBMS_OUTPUT.put_line(result);

   COMMIT;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line('no data found');
   WHEN credit_limit_over THEN
      result := '�ִ������� �ʰ��Ͽ����ϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_course THEN
      result :='�̹� ������û�� �����Դϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN too_many_students THEN
      result :='�ִ� ������û �ο��� �ʰ��Ͽ� ����� �� �����ϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_period THEN
      result :='���� �ð��� ������û�� ������ �ֽ��ϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN OTHERS THEN
      ROLLBACK;
      result := SQLCODE;
      DBMS_OUTPUT.put_line(result);
END;
/