<%@ page language = "java" contentType = "text/html; charset=UTF-8"  pageEncoding = "UTF-8" %>
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
		overflow : hidden;
	}
	body {
		background : #f8f9fa;
	}
	#accordionSidebar {
		width : 20%;
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
	#isLeaved_table {
		background : white;
		margin : 10px auto;
		width : 80%;
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
	String sql = null;
	
	//학생의 정보를 프로시저로부터 받아와서 비밀번호변경 혹은 휴학 신청에 사용되는 변수
	String pwd = null; 
	int isLeavedNo = 0; 
	String isLeaved = "";
%>
	<!-- Content Wrapper -->
	<div id = "content-wrapper" class = "d-flex flex-column">
		<!-- Main Content -->
		<div id = "content">
<% 
	if (session_id != null) {
		try {
			Class.forName(dbdriver);
			myConn = DriverManager.getConnection(dburl, user, passwd);              
			//학생인 경우
			if (session_id.length() == 7) {
				//CallableStatement + Procedure 사용 부분 - 학번을 받아 해당하는 학생의 정보를 받아온다
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
				isLeavedNo = cstmt.getInt(6);
				//isLeavedNo에는 휴학 신청을 했으면 1이 반환되고, 신청을 하지 않았으면 0이 반환된다
				if (isLeavedNo == 1) {
					isLeaved = "휴학";
				}
				else {
					isLeaved = "재학";
				}
			}
			//교수인 경우
			else {	
				//CallableStatement + Procedure 사용 부분 - 교번을 받아 해당하는 교수의 정보를 받아온다
				sql = "{call show_prof_info(?,?,?,?)}";
				cstmt = myConn.prepareCall(sql);
				cstmt.setString(1, session_id);
				cstmt.registerOutParameter(2, java.sql.Types.VARCHAR);
				cstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
				cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
				cstmt.execute();
				pwd = cstmt.getString(2);                 
			}
		}
		catch (SQLException e) {
			out.println(e);
			e.printStackTrace();
		}  
%>
		<!-- Begin Page Content -->
		<div class = "container-fluid">
		<!-- Page Heading -->
		<div class = "d-sm-flex align-items-center justify-content-between mb-4">
			<div class = "col-12">
			<form action = "update_verify.jsp?id=<%=session_id%>" method = "post" id = "update_post">
			<table class = "table table-bordered" align = "center" id = "update_table">
				<tr>
					<th colspan = "2" style = "text-align:center">수정할 비밀번호</th>
				</tr>
				<tr>
					<td id = "update_td">비밀번호</td>
					<td>
						<input id = "update_pw_in" type = "password" name = "password" size = "10">
					</td>
				</tr>
				<tr>
					<td id = "update_td_confirm">비밀번호 확인</td>
					<td>
						<input id = "update_pw_in_confirm" type = "password" name = "passwordConfirm" size = "10" >
					</td>
				</tr>
				<tr>
					<td colspan = "2" align = "center">
						<input class = "btn btn-primary" id = "update_btn" type = "submit" value = "수정 완료">
						<input class = "btn btn-primary" id = "update_btn" type = "reset" value = "초기화">
					</td>
				</tr>
			</table>
			</form>
<%
		//학생인 경우
		if (session_id.length() == 7) {
%>
			<table class = "table table-bordered" align = "center" id = "isLeaved_table">
				<tr>
					<th colspan = "2" style = "text-align:center">휴학신청</th>
				</tr>
				<tr>
					<td colspan = "1" id = "student_isLeaved">학적상태</td>
					<td colspan = "1"><%=isLeaved%></td>
				</tr>
				<tr>
<%
			//휴학 상태이면
			if (isLeavedNo == 1) {
%>
					<td colspan = "2" align = "center">
						<input class = "btn btn-primary" id = "leave_btn" name = "leaved" type = "button" value = "휴학 취소" onclick = "leaveSemesterCancle()">
					</td>
<%
			}
			//재학 상태이면
			else {
%>
					<td colspan = "2" align = "center">
						<input class = "btn btn-primary" id = "leave_btn" name = "leaved" type = "button" value = "휴학  신청" onclick = "leaveSemester()">
					</td>
<%
			}
		}				
%>
				</tr>
			</table>
			</div>
		</div>
<%
		myConn.close(); 
	}
%>
		</div>
		<!-- /.container-fluid -->
		</div>
		<!-- End of Main Content -->
	</div>
	<!-- End of Content Wrapper -->
</body>
<script>
	//휴학 신청, 휴학 신청 취소에 사용되는 함수 - 팝업이 뜨면 휴학 여부를 선택할 수 있고, 선택한 값을 update_leaved.jsp로 보낸다
	function leaveSemester() {
		var message = confirm('휴학을 신청하시겠습니까?');
		
		if (message == true) {
			location.href = 'update_leaved.jsp?leaved=true';
			return true;
		}
	}
	function leaveSemesterCancle() {
		var message = confirm('휴학을 취소하시겠습니까?');
	      
		if(message == true) {
			location.href = 'update_leaved.jsp?leaved=false';
			return true;
		}
	}
</script>
</html>
