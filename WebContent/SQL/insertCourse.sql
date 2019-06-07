CREATE OR REPLACE PROCEDURE InsertCourse(professorID IN VARCHAR2, courseID IN VARCHAR2,
			courseIDNO IN NUMBER, courseNAME IN VARCHAR2, courseCREDIT IN NUMBER,
			courseMAJOR IN VARCHAR2, courseMAX IN NUMBER,
			courseDAY1 IN NUMBER, coursePERIOD1 IN NUMBER,
			courseDAY2 IN NUMBER, coursePERIOD2 IN NUMBER,
			result OUT VARCHAR2)
IS
	credit_limit_over EXCEPTION;
	too_many_students EXCEPTION;
	same_days EXCEPTION;
	duplicate_period EXCEPTION;
	duplicate_course_id EXCEPTION;
	duplicate_course_name EXCEPTION;
	diffrent_course_name EXCEPTION;

	courseSUM NUMBER;
	courseCOUNT NUMBER;
	courseORIGINNAME VARCHAR2(50);
	periodCOUNT1 NUMBER;
	periodCOUNT2 NUMBER;
	nYEAR NUMBER;
	nSEMESTER NUMBER;
BEGIN
	result := ' ';
	nYEAR := Date2EnrollYear(SYSDATE);
	nSEMESTER := Date2EnrollSemester(SYSDATE);

	DBMS_OUTPUT.put_line(professorID || ' / ' || courseID ||
   	' / ' || courseIDNO );
	
	/*ù��° ���� �ι�° ���� ������*/
	IF courseDAY1 = courseDAY2 THEN
		RAISE same_days;
	END IF;

	/*�ִ� ���� ���� �ʰ�*/
	SELECT SUM(c_credit)
	INTO courseSUM
	FROM course
	WHERE p_id = professorID AND c_year = nYEAR AND c_semester = nSEMESTER;
	
	IF courseSUM IS NULL THEN
		courseSUM := 0;
	END IF; 
	
	DBMS_OUTPUT.put_line(courseSUM);
	
	IF (courseSUM + courseCREDIT) >10 THEN
		RAISE credit_limit_over;
	END IF;

	/*�ִ� ���� �ο� �ʰ�*/
	IF courseMAX > 200 THEN
		RAISE too_many_students;
	END IF;

	/*�̹� �ִ� ���� ��ȣ�� �й�*/
	SELECT count(*)
	INTO courseCOUNT
	FROM course
	WHERE c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;

	DBMS_OUTPUT.put_line(courseCOUNT);

	IF courseCOUNT > 0 THEN
		RAISE duplicate_course_id;
	END IF;
	
	/*�̹� �ִ� ���� �̸�*/
	SELECT count(*)
	INTO courseCOUNT
	FROM course
	WHERE c_name = courseNAME AND c_year = nYEAR AND c_semester = nSEMESTER AND c_id != courseID;

	DBMS_OUTPUT.put_line(courseCOUNT);

	IF courseCOUNT > 0 THEN
		RAISE duplicate_course_name;
	END IF;

	/*�й� �̸� �ٸ�*/
	SELECT count(*)
	INTO courseCOUNT
	FROM course
	WHERE c_id = courseID;

	DBMS_OUTPUT.put_line(courseCOUNT);

	IF courseCOUNT>0 THEN
		SELECT count(*)
		INTO courseCOUNT
		FROM course
		WHERE c_id = courseID AND c_name != courseNAME;

		IF courseCOUNT>0 THEN
			RAISE diffrent_course_name;
		END IF;
	END IF;
	
	/*�̹� ������ ���� �ð���*/
	SELECT count(*)
	INTO periodCOUNT1
	FROM course
	WHERE p_id = professorID AND c_year = nYEAR AND c_semester = nSEMESTER
		AND c_day1 = courseDAY1 AND c_period1 = coursePERIOD1;
	
	SELECT count(*)
	INTO periodCOUNT2
	FROM course
	WHERE p_id = professorID AND c_year = nYEAR AND c_semester = nSEMESTER
		AND c_day2 = courseDAY2 AND c_period2 = coursePERIOD2;

	DBMS_OUTPUT.put_line(periodCOUNT1 || ' / ' || periodCOUNT2);

	IF periodCOUNT1 > 0 OR periodCOUNT2 > 0 THEN
		RAISE duplicate_period;
	END IF;
	
	INSERT INTO course(c_id, c_name, c_year, c_semester, p_id, c_credit, c_number,
			c_day1, c_day2, c_period1, c_period2, c_max, c_current)
   	VALUES (courseID, courseNAME, nYEAR, nSEMESTER, professorID, courseCREDIT, courseIDNO,
		courseDAY1, courseDAY2, coursePERIOD1, coursePERIOD2, courseMAX, 0);
	
	result := '���ǰ����� �Ϸ�Ǿ����ϴ�.';
	DBMS_OUTPUT.put_line(result);

	COMMIT;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line('no data found');
   WHEN same_days THEN
      result := 'ù��° ���� �ι�° ���� ���� �����Դϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN credit_limit_over THEN
      result := '������ �� �ִ� ���� ������ �ʰ��Ͽ����ϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_course_id THEN
      result :='�̹� �ִ� ����ID�� �й� ��ȣ �Դϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_course_name THEN
      result :='�̹� �ִ� �����̸� �Դϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN diffrent_course_name THEN
      result :='�ٸ� �йݰ� �̸��� �ٸ��ϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN too_many_students THEN
      result :='�ִ� ���� �ο��� �ʰ��Ͽ� ����� �� �����ϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_period THEN
      result :='���� �ð��� ������ ���ǰ� �ֽ��ϴ�.';
      DBMS_OUTPUT.put_line(result);
   WHEN OTHERS THEN
      ROLLBACK;
      result := SQLCODE;
      DBMS_OUTPUT.put_line(result);
END;
/
	