CREATE OR REPLACE PROCEDURE InsertCourse(professorID IN VARCHAR2, courseID IN VARCHAR2,
			courseIDNO IN NUMBER, courseNAME IN VARCHAR2, courseCREDIT IN NUMBER,
			courseMAJOR IN VARCHAR2, courseMAX IN NUMBER,
			courseDAY1 IN NUMBER, coursePERIOD1 IN NUMBER,
			courseDAY2 IN NUMBER, coursePERIOD2 IN NUMBER,
			result OUT VARCHAR2)
IS
	minimum_credit EXCEPTION;
	maximum_credit EXCEPTION;
	credit_limit_over EXCEPTION;
	minimum_students EXCEPTION;	
	too_many_students EXCEPTION;
	same_days EXCEPTION;
	duplicate_period EXCEPTION;
	duplicate_course_id EXCEPTION;
	course_number_error EXCEPTION;
	duplicate_course_name EXCEPTION;
	diffrent_course_name EXCEPTION;

	courseSUM NUMBER;
	courseCOUNT NUMBER;
	courseORIGINNAME VARCHAR2(50);
	courseNUMBER NUMBER;
	periodCOUNT1 NUMBER;
	periodCOUNT2 NUMBER;
	nYEAR NUMBER;
	nSEMESTER NUMBER;
	tempDAY1 NUMBER;
	tempPERIOD1 NUMBER;	
	tempDAY2 NUMBER;
	tempPERIOD2 NUMBER;

BEGIN
	result := ' ';
	nYEAR := Date2EnrollYear(SYSDATE);
	nSEMESTER := Date2EnrollSemester(SYSDATE);

	DBMS_OUTPUT.put_line(professorID || ' / ' || courseID ||
   	' / ' || courseIDNO );
	
	/*첫번째 날과 두번째 날이 같은날*/
	IF courseDAY1 = courseDAY2 THEN
		RAISE same_days;
	END IF;
	
	/*최소 최대 학점*/
	IF courseCREDIT < 1 THEN
		RAISE minimum_credit;
	END IF;

	IF courseCREDIT >3 THEN
		RAISE maximum_credit;
	END IF;

	/* 최소 학생 수*/

	IF courseMAX <10 THEN
		RAISE minimum_students;
	END IF;

	/*최대 개설 강의 초과*/
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

	/*최대 수업 인원 초과*/
	IF courseMAX > 200 THEN
		RAISE too_many_students;
	END IF;

	/*이미 있는 강의 번호와 분반*/
	SELECT count(*)
	INTO courseCOUNT
	FROM course
	WHERE c_id = courseID AND c_number = courseIDNO AND c_year = nYEAR AND c_semester = nSEMESTER;

	DBMS_OUTPUT.put_line(courseCOUNT);

	IF courseCOUNT > 0 THEN
		RAISE duplicate_course_id;
	END IF;

	/*잘못된 분반 번호*/
	SELECT NVL(MAX(c_number),0)
	INTO courseNUMBER
	FROM course
	WHERE c_id = courseID AND c_year = nYEAR AND c_semester = nSEMESTER;

	DBMS_OUTPUT.put_line(courseNUMBER);	

	IF (courseNUMBER+1) != courseIDNO OR courseIDNO < 1 THEN
		RAISE course_number_error;
	END IF;
	
	/*이미 있는 강의 이름*/
	SELECT count(*)
	INTO courseCOUNT
	FROM course
	WHERE c_name = courseNAME AND c_year = nYEAR AND c_semester = nSEMESTER AND c_id != courseID;

	DBMS_OUTPUT.put_line(courseCOUNT);

	IF courseCOUNT > 0 THEN
		RAISE duplicate_course_name;
	END IF;

	/*분반 이름 다름*/
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

	IF courseDAY1 < courseDAY2 THEN
		tempDAY1 := courseDAY1;
		tempPERIOD1 := coursePERIOD1;
		tempDAY2 := courseDAY2;
		tempPERIOD2 := coursePERIOD2;
	ELSE
		tempDAY1 := courseDAY2;
		tempPERIOD1 := coursePERIOD2;
		tempDAY2 := courseDAY1;
		tempPERIOD2 := coursePERIOD1;
	END IF;
	
	/*이미 개설한 강의 시간대*/
	SELECT count(*)
	INTO periodCOUNT1
	FROM course
	WHERE p_id = professorID AND c_year = nYEAR AND c_semester = nSEMESTER
		AND c_day1 = tempDAY1 AND c_period1 = tempPERIOD1;
	
	SELECT count(*)
	INTO periodCOUNT2
	FROM course
	WHERE p_id = professorID AND c_year = nYEAR AND c_semester = nSEMESTER
		AND c_day2 = tempDAY2 AND c_period2 = tempPERIOD2;

	DBMS_OUTPUT.put_line(periodCOUNT1 || ' / ' || periodCOUNT2);

	IF periodCOUNT1 > 0 OR periodCOUNT2 > 0 THEN
		RAISE duplicate_period;
	END IF;

	INSERT INTO course(c_id, c_name, c_year, c_semester, p_id, c_credit, c_number,c_major,
			c_day1, c_day2, c_period1, c_period2, c_max, c_current)
   	VALUES (courseID, courseNAME, nYEAR, nSEMESTER, professorID, courseCREDIT, courseIDNO, courseMAJOR,
			tempDAY1, tempDAY2, tempPERIOD1, tempPERIOD2, courseMAX, 0);


	
	result := '강의개설이 완료되었습니다.';
	DBMS_OUTPUT.put_line(result);

	COMMIT;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line('no data found');
   WHEN minimum_credit THEN
      result := '최소 학점은 1학점입니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN maximum_credit THEN
      result := '최대 학점은 3학점입니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN minimum_students THEN
      result := '최소 학생 수는 10명입니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN same_days THEN
      result := '첫번째 날과 두번째 날이 같은 요일입니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN credit_limit_over THEN
      result := '개설할 수 있는 강의 학점을 초과하였습니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_course_id THEN
      result :='이미 있는 과목ID와 분반 번호 입니다.';
      DBMS_OUTPUT.put_line(result);
  WHEN course_number_error THEN
      result :='잘못된 분반 번호 입니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_course_name THEN
      result :='이미 있는 과목이름 입니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN diffrent_course_name THEN
      result :='다른 분반과 이름이 다릅니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN too_many_students THEN
      result :='최대 수업 인원을 초과하여 등록할 수 없습니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN duplicate_period THEN
      result :='같은 시간에 개설한 강의가 있습니다.';
      DBMS_OUTPUT.put_line(result);
   WHEN OTHERS THEN
      ROLLBACK;
      result := SQLCODE;
      DBMS_OUTPUT.put_line(result);
END;
/
	