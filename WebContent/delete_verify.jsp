<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<div id = "formDialogDiv" style = "display : none;">
   <%@ include file = "top.jsp" %>
</div>
<html><head><title> 수강신청 입력 </title></head>
<body>
<%

	String c_id=request.getParameter("c_id");
	int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
%>	
<%	
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "sook";
	String passwd = "2019";
	Connection myConn = null;
	String result = null;
	ResultSet rs = null;
	CallableStatement cstmt = null;

	
	try{
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl, user, passwd);
	}catch (ClassNotFoundException e){
		e.printStackTrace();
		System.out.println("jdbc driver 로딩 실패");
	}catch (SQLException e){
		e.printStackTrace();
		System.out.println("오라클 연결 실패");
	}
	
	
	if(session_id.length() == 7){
		
		cstmt = myConn.prepareCall("{call deleteEnroll(?,?,?)}",
	    	    ResultSet.TYPE_SCROLL_SENSITIVE,
	        	ResultSet.CONCUR_READ_ONLY);
	   	
		cstmt.setString(1, session_id);
	   	cstmt.setString(2, c_id);
	   	cstmt.setInt(3,c_id_no);
	   
	}else if(session_id.length() == 5){
		
		cstmt = myConn.prepareCall("{call deleteCourse(?,?,?)}",
		        ResultSet.TYPE_SCROLL_SENSITIVE,
		        ResultSet.CONCUR_READ_ONLY);
		
		cstmt.setString(1, session_id);
		cstmt.setString(2, c_id);
		cstmt.setInt(3,c_id_no);
	}
	
	
	  try {
			cstmt.execute();
			
			if(session_id.length() == 7)
		   	 	result = "수강 신청이 취소되었습니다.";
			
			if(session_id.length() == 5)
			   	 result = "강의 개설이 취소되었습니다.";
		    %>
		    <script>
		    alert("<%= result %>");
		    location.href="delete.jsp";
		    </script>
		    <%
		    } catch(SQLException ex) {
		    System.err.println("SQLException: " + ex.getMessage());
		    }
	  
		    finally {
		  	  if (cstmt != null)
		 	  	 try { 
		   			 myConn.commit(); cstmt.close(); myConn.close(); 
		   			 } catch(SQLException ex) { }
			   }
		
	%>
</body>
</html>