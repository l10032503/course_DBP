<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "java.sql.*" %>
<% 
	//login.jsp로부터 입력ID와 입력비밀번호를 받아온다
	String session_id = request.getParameter("userID");
	String userPassword = request.getParameter("userPassword");
	
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "sook";
	String passwd = "2019";
	Connection myConn = null;
	PreparedStatement pstmt = null;
	ResultSet myResultSet = null;
	String sql;
	//로그인 성공, 실패 여부를 판단하는 데에 사용되는 변수
	boolean result = false;
	
	try {
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl, user, passwd);
		//학생인 경우
		if (session_id.length() == 7) {
			sql = "select s_id, s_name from student where s_id = ? and s_pwd = ?"; 		
		}
		//교수인 경우
		else {
			sql = "select p_id, p_name from professor where p_id = ? and p_pwd= ?"; 
		}
		//PreparedStatement 사용 부분 - 유효한 회원인지 확인한다
		pstmt = myConn.prepareStatement(sql);
		pstmt.setString(1, session_id);
		pstmt.setString(2, userPassword);
		myResultSet = pstmt.executeQuery();
		result = myResultSet.next();
		//로그인 성공
		if (result) {
			session.setAttribute("user", session_id);
			response.sendRedirect("main.jsp");
		}
		else {
%>
<script>
	alert("로그인 실패.");
	location.href = "login.jsp";
</script>
<%
		}
		myResultSet.close();
		pstmt.close();
		myConn.close();
	}
	catch (ClassNotFoundException e) {
		e.printStackTrace();
		System.out.println("jdbc driver 로딩 실패");
	}
	catch (SQLException e) {
		e.printStackTrace();
		System.out.println("오라클 연결 실패");
	}
%>