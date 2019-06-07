<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%
String dbdriver = "oracle.jdbc.driver.OracleDriver"; //JDBC 드라이버 로딩
String dburl = "jdbc:oracle:thin:@localhost:1521:orcl"; //url
String user = "SOOK"; //oracle login id
String passwd = "2019"; //pw

Class.forName(dbdriver);
Connection myConn = null;
CallableStatement cstmt = null;
String mySql;

   try { 
      myConn = DriverManager.getConnection(dburl, user, passwd);
      String enterId = request.getParameter("id");
      String enterPwd = request.getParameter("password");
      String enterPwdConfirm = request.getParameter("passwordConfirm");
      
      if (enterPwd.equals(enterPwdConfirm)) {
    	  if(enterId.length() == 7){
    		  mySql = "{call change_pwd(?,?)}";
    	    	 cstmt = myConn.prepareCall(mySql);
    	    	 cstmt.setString(1, enterId);
    	    	 cstmt.setString(2, enterPwd);
    	    	 cstmt.execute();
    			%>
    	         <script>
    	            alert("수정이 완료되었습니다");
    	            location.href = "main.jsp";
    	         </script>
    	         <%
    	  }else{
    	  	mySql = "{call change_pwd_prof(?,?)}";
    	    	 cstmt = myConn.prepareCall(mySql);
    	    	 cstmt.setString(1, enterId);
    	    	 cstmt.setString(2, enterPwd);
    	    	 cstmt.execute();
    			%>
    	         <script>
    	            alert("수정이 완료되었습니다");
    	            location.href = "main.jsp";
    	         </script>
    	         <% 
    	  }
    	       
      }
      else {
%>
         <script>
            alert("비밀번호가 일치하지 않습니다");
            location.href = "update.jsp";
         </script>
<%      
      }
   	}
   	catch(SQLException ex) {
      String sMessage;
      System.out.println(ex.getErrorCode());
      
      if (ex.getErrorCode() == 20002) {
         sMessage="암호는 4자리 이상이어야 합니다";
      }
      else if (ex.getErrorCode() == 20003) {
         sMessage="암호에 공란은 입력되지 않습니다.";
      }
      else {
         sMessage="잠시 후 다시 시도하십시오";
      }
   out.println("<script>");
   out.println("alert('"+sMessage+"');");
   out.println("location.href='update.jsp';");
   out.println("</script>");
   out.flush();
   }   
   myConn.close();
%>