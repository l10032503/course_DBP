<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<div id="formDialogDiv" style="display: none;">
    <%@ include file="top.jsp" %>
</div>
<%
String dbdriver = "oracle.jdbc.driver.OracleDriver"; //JDBC 드라이버 로딩
String dburl = "jdbc:oracle:thin:@localhost:1521:orcl"; //url
String user = "SOOK"; //oracle login id
String passwd = "2019"; //pw

Class.forName(dbdriver);
Connection myConn = null;
Statement stmt = null;

   try { 
      myConn = DriverManager.getConnection(dburl, user, passwd);
      stmt = myConn.createStatement();
      //휴학신청
      String isLeave = request.getParameter("leaved");
      
      if (isLeave.equals("true")) {			
		String sql = "update student set isLeaved = 1 where s_id = "+session_id;		
		//stmt.executeUpdate(sql);
		String sql2 = "delete from enroll where s_id = "+session_id;		
		//stmt.executeUpdate(sql);
		//String sql3 = "update student set s_credit = 0 where s_id = "+session_id;		
		stmt.executeUpdate(sql);
		stmt.executeUpdate(sql2);
		//stmt.executeUpdate(sql3);
%>		
		<script>
		alert('휴학 신청이 완료되었습니다.')
		location.href = "main.jsp";
		</script>
<%
      }else{
    	  String sql = "update student set isLeaved = 0 where s_id = "+session_id;		
  		stmt.executeUpdate(sql);
  %>
  		<script>
  		alert('휴학 취소가 완료되었습니다.')
  		location.href = "main.jsp";
  		</script>
      <%
      myConn.commit();}
   }
   catch(SQLException ex) {
      String sMessage;
      System.out.println(ex.getErrorCode());
   }
   
   myConn.close();
%>