<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "java.sql.*" %>
<% 
	request.setCharacterEncoding("UTF-8");
%>
<html>
<head>
<title>수강신청 입력</title>
</head>
<body>
<%
	//학생모드에서는 수강신청한 학생의 학번을 login_verify.jsp로부터, 수강신청한 과목의 과목번호, 과목분반 데이터를 insert.jsp로부터 받아온다
	//교수모드에서는 개설신청한 교수의 교번을 login_verify.jsp로부터, 개설신청한 과목의 과목번호, 과목분반 데이터를 insert_prof.jsp로부터 받아온다
	String session_id = (String) session.getAttribute("user");
	String c_id = request.getParameter("c_id");
	int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
	
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "sook";
	String passwd = "2019";
	Connection myConn = null;
	CallableStatement cstmt = null;
	String result = null;
	
	try {
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl, user, passwd);
	}
	catch (ClassNotFoundException e) {
		e.printStackTrace();
		System.out.println("jdbc driver 로딩 실패");
	}
	catch (SQLException e) {
		e.printStackTrace();
		System.out.println("오라클 연결 실패");
	}
	//학생인 경우
	if (session_id.length() == 7) {
		//CallaleStatement + Procedure 사용 부분 - 선택한 과목을 수강신청 목록에 추가한다
		cstmt = myConn.prepareCall("{call InsertEnroll(?,?,?,?)}", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		cstmt.setString(1, session_id);
		cstmt.setString(2, c_id);
		cstmt.setInt(3, c_id_no);
		cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
		try {
			cstmt.execute();
			result = cstmt.getString(4);
%>
	<script>
		alert("<%=result%>");
		location.href="insert.jsp?year_semester=201902";
	</script>
<%
		} 
		catch (SQLException ex) {
			System.err.println("SQLException: " + ex.getMessage());
		}
		finally {
			if (cstmt != null) {
				try { 
					myConn.commit(); 
					cstmt.close(); 
					myConn.close(); 
				}
				catch (SQLException ex) { }
			}
		}
	}
	//교수인 경우
	else {
		//교수가 개설한 과목 정보를 insert_prof.jsp로부터 받아오는 데에 사용되는 변수
		String c_name = request.getParameter("c_name");
		int c_credit = Integer.parseInt(request.getParameter("c_credit"));
		String c_major = request.getParameter("c_major");
		int c_max = Integer.parseInt(request.getParameter("c_max"));
		int c_day1 = Integer.parseInt(request.getParameter("c_day1"));
		int c_period1 = Integer.parseInt(request.getParameter("c_period1"));	
		int c_day2 = Integer.parseInt(request.getParameter("c_day2"));
		int c_period2 = Integer.parseInt(request.getParameter("c_period2"));
		
		//CallaleStatement + Procedure 사용 부분 - 입력한 정보를 토대로 새로운 과목을 개설한다
		cstmt = myConn.prepareCall("{call InsertCourse(?,?,?,?,?,?,?,?,?,?,?,?)}", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);		
		cstmt.setString(1, session_id);		
		cstmt.setString(2, c_id);
		cstmt.setInt(3,c_id_no);
		cstmt.setString(4, c_name);		
		cstmt.setInt(5, c_credit);		
		cstmt.setString(6, c_major);		
		cstmt.setInt(7, c_max);		
		cstmt.setInt(8, c_day1);		
		cstmt.setInt(9, c_period1);	
		cstmt.setInt(10, c_day2);
		cstmt.setInt(11, c_period2);
		cstmt.registerOutParameter(12, java.sql.Types.VARCHAR);
		try {
			cstmt.execute();
			result = cstmt.getString(12);
%>
			<script>
				alert("<%= result %>");
				location.href="insert_prof.jsp?year_semester=201902";
			</script>
<%
		} 
		catch (SQLException ex) {
			ex.printStackTrace();
			System.err.println("SQLException: " + ex.getMessage());
		}
		finally {
			if (cstmt != null) {
				try { 
					myConn.commit(); 
					cstmt.close(); 
					myConn.close(); 
				}
				catch (SQLException ex) { }
			}
		}
	}
%>
</body>
</html>