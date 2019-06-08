<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<div id = "formDialogDiv" style = "display : none;">
	<%@ include file = "top.jsp" %>
</div>
<%
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "SOOK";
	String passwd = "2019";
	Connection myConn = null;
	Statement stmt = null;
	
	//휴학 신청 여부를 확인하는 데에 사용되는 변수
	String isLeave; 
	String sql;
	
	try {
		//update.jsp로부터 휴학 신청 여부에 관한 데이터를 받아온다
		isLeave = request.getParameter("leaved");
		
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl, user, passwd);
		stmt = myConn.createStatement();
		//휴학 신청을 한 경우
		if (isLeave.equals("true")) {			
			sql = "update student set isLeaved = 1 where s_id = " + session_id;
			stmt.executeUpdate(sql);
			//이번 학기에 신청한 학점을 모두 취소시킨다.
			sql = "delete from enroll where s_id = " + session_id;		
			stmt.executeUpdate(sql);
%>		
<script>
	alert('휴학 신청이 완료되었습니다.')
	location.href = "main.jsp";
</script>
<%
		}
		//휴학 신청했던 것을 취소한 경우
		else {
			sql = "update student set isLeaved = 0 where s_id = " + session_id;		
			stmt.executeUpdate(sql);
%>
<script>
	alert('휴학 취소가 완료되었습니다.')
	location.href = "main.jsp";
</script>
<%
		myConn.commit();
		}
	}
	catch (SQLException ex) {
		System.out.println(ex.getErrorCode());
	}   
	myConn.close();
%>