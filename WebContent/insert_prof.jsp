<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "java.sql.*" %>
<% 
	request.setCharacterEncoding("UTF-8");
%>
<html>
<head>
<title>수강신청 입력</title>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="">
	<meta name="author" content="">
  	
	<link href = "vendor/fontawesome-free/css/all.min.css" rel = "stylesheet" type = "text/css">
	<link href = "https://fonts.googleapis.com/css?family=Nunito:200, 200i, 300, 300i, 400, 400i, 600, 600i, 700, 700i, 800, 800i, 900, 900i" rel = "stylesheet">
	<!-- Custom styles for this template-->
	<link href = "css/sb-admin-2.min.css" rel = "stylesheet">
</head>
<style type = "text/css">
	html {
		height : 100vh;
		overflow : hidden;
	}
	body {
		background : #f8f9fa;
	}
	#accordionSidebar {
		float : left;
	}
	.navbar-expand {
		width : 70%;
		float : left;
		text-align : right
	}
	#content-wrapper {
		width : 70%;
		height : 80vh;
		float : left;
		overflow : auto
	}
	#table-header {
		width : 100%;
		float : left;
		overflow : auto
	}	
	#year-dropdown {
		float : right;
	}
	#current-credit {
		float : left;
	}
	.form {
		margin : auto;
		width : 100%;
	}
	.table {
		background : white;
		margin : auto;
		width : 100%;
	}	
	th {
		text-align : center;
		word-break : keep-all;
	}
	td {
		text-align : center;
		margin : auto;
		word-break : keep-all;
		white-space : pre-line
	}
	#insert-button {
		margin : auto;
	}
	#input-box {
		margin-top : 5px;
		text-align : center;
		width : 100%;
		height : 38px;
	}
</style>
<body>
<%@ include file = "top.jsp" %>
	<!-- Content Wrapper -->
	<div id="content-wrapper" class="d-flex flex-column">
	<!-- Main Content -->
	<div id="content">
	<div class="container-fluid">
		<!-- Page Heading -->
		<div class="d-sm-flex align-items-center justify-content-between">  	
		<div id="table-header">
<%
	int year_semester = 0;
	int nYear, nSemester;
	
	if (request.getParameter("year_semester") == null) {
		year_semester = 201902;
	} 
	else {
		year_semester = Integer.parseInt(request.getParameter("year_semester"));
	}	
	nYear = year_semester / 100;
	nSemester = year_semester % 100;
	if (year_semester == 201902) {
%>
		<select id = "year-dropdown" name = "year_semester" onchange = "location = this.value;">
			<option value = 'insert_prof.jsp?year_semester=201902' selected = "selected">2019년 2학기</option>	
			<option value = 'insert_prof.jsp?year_semester=201901'>2019년 1학기</option>
			<option value = 'insert_prof.jsp?year_semester=201802'>2018년 2학기</option>
			<option value = 'insert_prof.jsp?year_semester=201801'>2018년 1학기</option>
		</select>
<%
	}
	else if (year_semester == 201901) {
%>
		<select id = "year-dropdown" name = "year_semester" onchange = "location = this.value;">
			<option value = 'insert_prof.jsp?year_semester=201902'>2019년 2학기</option>	
			<option value = 'insert_prof.jsp?year_semester=201901' selected = "selected">2019년 1학기</option>
			<option value = 'insert_prof.jsp?year_semester=201802'>2018년 2학기</option>
			<option value = 'insert_prof.jsp?year_semester=201801'>2018년 1학기</option>
		</select>
<%
	}
	else if (year_semester == 201802) {
%>
		<select id = "year-dropdown" name = "year_semester" onchange = "location = this.value;">
			<option value = 'insert_prof.jsp?year_semester=201902'>2019년 2학기</option>	
			<option value = 'insert_prof.jsp?year_semester=201901'>2019년 1학기</option>
			<option value = 'insert_prof.jsp?year_semester=201802' selected = "selected">2018년 2학기</option>
			<option value = 'insert_prof.jsp?year_semester=201801'>2018년 1학기</option>
		</select>
<%
	}
	else if (year_semester == 201801) {
%>
		<select id = "year-dropdown" name = "year_semester" onchange = "location = this.value;">
			<option value = 'insert_prof.jsp?year_semester=201902'>2019년 2학기</option>	
			<option value = 'insert_prof.jsp?year_semester=201901'>2019년 1학기</option>
			<option value = 'insert_prof.jsp?year_semester=201802'>2018년 2학기</option>
			<option value = 'insert_prof.jsp?year_semester=201801' selected = "selected">2018년 1학기</option>
		</select>
<%
	}
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "sook";
	String passwd = "2019";
	Connection myConn = null;
	PreparedStatement pstmt = null;
	CallableStatement cstmt = null;
	ResultSet myResultSet = null;
	String sql;
	
	int credit;
	
	try {				
		Class.forName(dbdriver);
		myConn =  DriverManager.getConnection (dburl, user, passwd);
		
		//PreparedStatement 사용 부분 - 특정 연도, 학기에 해당하는 과목만 필터링하여 보여준다
		sql = "select * from COURSE where c_year = ? and c_semester = ? order by c_id";
		pstmt = myConn.prepareStatement(sql);
		pstmt.setInt(1, nYear);
		pstmt.setInt(2, nSemester);
		myResultSet = pstmt.executeQuery();
	} 
	catch (SQLException ex) {
		System.err.println("SQLException: " + ex.getMessage());
	}
	
	//CallableStatement + Function 사용 부분 - 현재 교수가 개설한 과목의 총 학점을 가져와서 보여준다
	sql = "{? = call get_prof_credit(?)}";
	cstmt = myConn.prepareCall(sql);
	cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
	cstmt.setString(2, session_id);
	cstmt.execute();
	credit = cstmt.getInt(1);	
%>
		<div id = "current-credit">
			<p>현재 개설한 강의 : <%=credit%>학점</p>
		</div>
		<form method = "post" action = "insert_verify.jsp" >
		<table class = "table table-bordered" border>
			<tr>
				<td colspan = "4" >과목번호</td>
				<td colspan = "4">
					<input id = "c_id" type = "text" name = "c_id" size = "20" placeholder = "C0000">
				</td>
			</tr>
			<tr>
				<td colspan = "4">분반번호</td>
				<td colspan = "4">
					<input id = "c_id_no" type = "text" name = "c_id_no" size = "20" placeholder = "1이상의 숫자">
				</td>
			</tr>
			<tr>
				<td colspan = "4">과목이름</td>
				<td colspan = "4">
					<input id = "c_name" type = "text" name = "c_name" size = "20" placeholder = "25자 이하">
				</td>
			</tr>
			<tr>
				<td colspan = "4">전공</td>
				<td colspan = "4">
				<select id = "day-period" name = "c_major">
					<option value = "기초교양대학" selected = "selected">기초교양대학</option>
					<option value = "컴퓨터과학부" >컴퓨터과학부</option>
					<option value = "경영학부" >경영학부</option>
				</select>
				</td>
			</tr>
			<tr>
				<td colspan = "4">학점</td>
				<td colspan = "4">
					<input id = "c_credit" type = "text" name = "c_credit" size = "20" placeholder = "1~3 사이의 숫자">
				</td>
			</tr>
			<tr>
				<td colspan = "4">최대인원</td>
				<td colspan = "4">
					<input id = "c_max" type = "text" name = "c_max" size = "20" placeholder = "10이상 200이하의 숫자">
				</td>
			</tr>
			<tr>
				<td>첫번째 날</td>
				<td>
				<select id = "day-period" name = "c_day1">
					<option value = "1" selected = "selected">월</option>
					<option value = "2">화</option>
					<option value = "3">수</option>
					<option value = "4">목</option>
					<option value = "5">금</option>
				</select>
				</td>
				<td>교시</td>
				<td>
				<select id = "day-period" name = "c_period1">
					<option value = "1" selected = "selected">1</option>
					<option value = "2">2</option>
					<option value = "3">3</option>
					<option value = "4">4</option>
					<option value = "5">5</option>
					<option value = "6">6</option>
					<option value = "7">7</option>
				</select>
				</td>
				<td>두번째 날</td>
				<td>
				<select id = "day-period" name = "c_day2">
					<option value = "1">월</option>
					<option value = "2">화</option>
					<option value = "3" selected = "selected">수</option>
					<option value = "4">목</option>
					<option value = "5">금</option>
				</select>
				</td>
				<td>교시</td>
				<td>
				<select id = "day-period" name = "c_period2">
					<option value = "1" selected = "selected">1</option>
					<option value = "2">2</option>
					<option value = "3">3</option>
					<option value = "4">4</option>
					<option value = "5">5</option>
					<option value = "6">6</option>
					<option value = "7">7</option>
				</select>
				</td>
			</tr>
		</table>
		<div id = "input-box">
			<INPUT class = "btn btn-primary" id = "insert-button" TYPE = "SUBMIT" NAME = "Submit" VALUE = "작성완료">
			<INPUT class = "btn btn-primary" id = "insert-button" TYPE = "RESET" VALUE = "초기화">
		</div>
		</form>
		<p>개설된 강의</p>
		</div>          
		</div>
		<div class = "d-sm-flex align-items-center justify-content-between mb-4">
		<table class = "table table-bordered" align = "center" border>
			<tr>
				<th>과목번호</th>
				<th>분반</th>
				<th>과목명</th>
				<th>교수</th>
				<th>시간</th>
				<th>학점</th>
				<th>현재 수강인원</th>
				<th>최대 수강인원</th>
			</tr>
<%
	Statement stmt;
	ResultSet rs;
	String sql2;

	//Prepared Statement에서 가져온 과목 정보들을 보여주기 위한 변수들
	String c_id, c_name, p_name;
	String c_time = "";
	int c_number, p_id, c_day1, c_day2, c_period1, c_period2, c_max, c_current, c_credit;
	
	if (myResultSet != null) {
		while (myResultSet.next()) {	
			c_id = myResultSet.getString("c_id");
			c_number = myResultSet.getInt("c_number");
			c_name = myResultSet.getString("c_name");
			p_id = myResultSet.getInt("p_id");
			c_day1 = myResultSet.getInt("c_day1");
			c_day2 = myResultSet.getInt("c_day2");
			c_period1 = myResultSet.getInt("c_period1");
			c_period2 = myResultSet.getInt("c_period2");
			c_max = myResultSet.getInt("c_max");
			c_current = myResultSet.getInt("c_current");
			switch (c_day1) {
				case 1 :
					c_time = "월";
					break;
				case 2 :
					c_time = "화";
					break;
				case 3 :
					c_time = "수";
					break;
				case 4 :
					c_time = "목";
					break;
				case 5 :
					c_time = "금";
					break;
				default :
					break;
			}
			c_time = c_time + " " + c_period1 + "교시";
			switch (c_day2) {
				case 1 :
					c_time = c_time +"\n월";
					break;
				case 2 :
					c_time = c_time +"\n화";
					break;
				case 3 :
					c_time = c_time +"\n수";
					break;
				case 4 :
					c_time = c_time +"\n목";
					break;
				case 5 :
					c_time = c_time +"\n금";
					break;
				default :
					break;
			}
			c_time = c_time + " " + c_period2 + "교시";
			c_credit= myResultSet.getInt("c_credit");
			
			sql2 = "select p_name from professor where p_id = '" + p_id + "'";
			stmt = myConn.createStatement();
			rs = stmt.executeQuery(sql2);
			rs.next();
			p_name = rs.getString("P_NAME");	
%>
			<tr>
				<td align = "center"><%=c_id%></td>
				<td align = "center"><%=c_number%></td> 
				<td align = "center"><%=c_name%></td>
				<td align = "center"><%=p_name%></td>
				<td align = "center"><%=c_time%></td>
				<td align = "center"><%=c_credit%></td>
				<td align = "center"><%=c_current%></td>
				<td align = "center"><%=c_max%></td>
			</tr>
<%
		}
	}
%>
		</table>	
		</div>
	</div>
	<!-- /.container-fluid -->
	</div>
	<!-- End of Main Content -->
	</div>
	<!-- End of Content Wrapper -->
</body>
</html>