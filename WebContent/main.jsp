<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<html>
<head>
<title>데이터베이스를 활용한 수강신청 시스템입니다.</title>
	<meta charset = "EUC-KR">
	<meta charset = "UTF-8">
	<meta http-equiv = "X-UA-Compatible" content = "IE=edge">
  	<meta name = "viewport" content = "width=device-width, initial-scale=1, shrink-to-fit=no">
  	<meta name = "description" content = "">
  	<meta name = "author" content = "">
  
	<link href = "vendor/fontawesome-free/css/all.min.css" rel = "stylesheet" type = "text/css">
  	<link href = "https://fonts.googleapis.com/css?family=Nunito:200, 200i, 300, 300i, 400, 400i, 600, 600i, 700, 700i, 800, 800i, 900, 900i" rel = "stylesheet">
  	<!-- Custom styles for this template-->
  	<link href = "css/sb-admin-2.min.css" rel = "stylesheet">
</head>
<style>
	html {
		height : 100vh;
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
		height : 85vh;
		float : left;
		overflow : auto
	}
	#update_post {
		margin : auto;
		width : 100%;
	}
	#update_table {
		background : white;
		margin : auto;
		width : 80%;
	}
	#profile {
		margin : 0 auto;
	}
</style>
<body>
<%@ include file = "top.jsp" %>
<%
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "sook";
	String passwd = "2019";
	Connection myConn = null;
	CallableStatement cstmt = null;
	String sql;
	
	//현재 로그인된 학생 혹은 교수의 정보를 받아오기 위한 변수
	String pwd = null; 
	String name = null; 
	String major = null; 
	String isLeaved = "";
	int grade = 0; 
	int credit = 0;
	int isLeavedNo = 0; 
%>
	<!-- Content Wrapper -->
	<div id = "content-wrapper" class = "d-flex flex-column">
	<!-- Main Content -->
	<div id = "content">  
	<!-- Begin Page Content -->
	<div class = "container-fluid">
		<!-- Page Heading -->
		<div class = "d-sm-flex align-items-center justify-content-between mb-4">
<% 
	if (session_id != null) {
		try {
			Class.forName(dbdriver);
			myConn = DriverManager.getConnection(dburl, user, passwd);
			//학생인 경우
			if (session_id.length() == 7) {
				//CallableStatement + Procedure 사용 부분 - 학번을 토대로 해당 학생의 정보를 가져온다
				sql = "{call show_stu_info(?,?,?,?,?,?)}";
				cstmt = myConn.prepareCall(sql);
				cstmt.setString(1, session_id);
				cstmt.registerOutParameter(2, java.sql.Types.VARCHAR);
				cstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
				cstmt.registerOutParameter(4, java.sql.Types.INTEGER);
				cstmt.registerOutParameter(5, java.sql.Types.VARCHAR);
				cstmt.registerOutParameter(6, java.sql.Types.INTEGER);
				cstmt.execute();
				pwd = cstmt.getString(2);
				name = cstmt.getString(3);
				grade = cstmt.getInt(4);
				major = cstmt.getString(5);
				isLeavedNo = cstmt.getInt(6);
				
				//CallableStatement + Function 사용 부분 - 학번을 토대로 해당 학생이 이번 학기에 신청한 현재 학점 정보를 가져온다
				sql = "{? = call get_stu_credit(?)}";
				cstmt = myConn.prepareCall(sql);
				cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
				cstmt.setString(2, session_id);
				cstmt.execute();
				credit = cstmt.getInt(1);            	       
				if (isLeavedNo == 1) {
					isLeaved = "휴학";
				}
				else {
					isLeaved = "재학";
				}           	       
%>        
		<table class = "table table-bordered" align = "center" id = "update_table">
			<tr>
				<th colspan = "3" style = "text-align:center">회원 정보</th>
				<tr>
					<tr>
						<td rowspan = "6" style = "text-align:center">
							<img src = "img/character_new03.gif" alt = "profile" id = "profile">
						</td>
						<td id = "update_td">학번</td>
						<td><%=session_id%></td>
					</tr>
					<tr>
						<td id = "student_name">이름</td>
						<td><%=name%></td>
					</tr>
					<tr>
						<td id = "student_grade">학년</td>
						<td><%=grade%></td>
					</tr>
					<tr>
						<td id = "student_major">전공</td>
						<td><%=major%></td>
					</tr>
					<tr>
						<td id = "student_credit">수강학점</td>
						<td><%=credit%> / 18</td>
					</tr>
					<tr>
						<td id = "student_isLeaved">학적상태</td>
						<td><%=isLeaved%></td>
					</tr>
				</tr>
			</tr>
		</table>
<%     	       
			}
			//교수인 경우
			else {
				//CallableStatement + Procedure 사용 부분 - 교번을 토대로 교수의 정보를 가져온다
				sql = "{call show_prof_info(?,?,?,?)}";
				cstmt = myConn.prepareCall(sql);
				cstmt.setString(1, session_id);
				cstmt.registerOutParameter(2, java.sql.Types.VARCHAR);
				cstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
				cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
				cstmt.execute();
				pwd = cstmt.getString(2);
				name = cstmt.getString(3);
				major = cstmt.getString(4);       
				
				//CallableStatement + Function 사용 부분 - 교번을 토대로 교수가 개설한 과목의 총 학점 정보를 가져온다
				sql = "{? = call get_prof_credit(?)}";
				cstmt = myConn.prepareCall(sql);
				cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
				cstmt.setString(2, session_id);
				cstmt.execute();
				credit = cstmt.getInt(1);
%>        
		<table class = "table table-bordered" align = "center" id = "update_table">
			<tr>
				<th colspan = "3" style = "text-align:center">회원 정보</th>
				<tr>
					<tr>
						<td rowspan = "4" style = "text-align:center">
							<img src = "img/character_new06.gif" alt = "profile" id = "profile">
						</td>
						<td id = "update_td">학번</td>
						<td><%=session_id%></td>
					</tr>
					<tr>
						<td id = "student_name">이름</td>
						<td><%=name%></td>
					</tr>
					<tr>
						<td id = "student_major">전공</td>
						<td><%=major%></td>
					</tr>
					<tr>
						<td id = "student_credit">강의학점</td>
						<td><%=credit%> / 10</td>
					</tr>
				</tr>
			</tr>
		</table>
<%
			}  
		}
		catch (SQLException e) {
			out.println(e);
			e.printStackTrace();
		}
		myConn.close(); 
	}
%>
		</div>
		<!-- /.container-fluid -->
	</div>
	<!-- End of Main Content -->
	</div>
	<!-- End of Content Wrapper -->
	</div>
	<!-- End of Page Wrapper -->
</body>
</html>