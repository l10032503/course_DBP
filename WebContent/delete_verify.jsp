<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.sql.*" %>
<html><head><title> ������û �Է� </title></head>
<body>
<%

	String session_id = (String)session.getAttribute("user");
	String c_id=request.getParameter("c_id");
	int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
	System.out.println(c_id);
	System.out.println(session_id);
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
		System.out.println("jdbc driver �ε� ����");
	}catch (SQLException e){
		e.printStackTrace();
		System.out.println("����Ŭ ���� ����");
	}
	
	try{
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl, user, passwd);
	}catch (ClassNotFoundException e){
		e.printStackTrace();
		System.out.println("jdbc driver �ε� ����");
	}catch (SQLException e){
		e.printStackTrace();
		System.out.println("����Ŭ ���� ����");
	}
	if(session_id.length()==7){
	cstmt = myConn.prepareCall("{call deleteEnroll(?,?,?)}",
	         ResultSet.TYPE_SCROLL_SENSITIVE,
	           ResultSet.CONCUR_READ_ONLY);
	   cstmt.setString(1, session_id);
	   cstmt.setString(2, c_id);
	   cstmt.setInt(3,c_id_no);
	}else if(session_id.length()==5){
		cstmt = myConn.prepareCall("{call deleteCourse(?,?,?)}",
		         ResultSet.TYPE_SCROLL_SENSITIVE,
		           ResultSet.CONCUR_READ_ONLY);
		   cstmt.setString(1, session_id);
		   cstmt.setString(2, c_id);
		   cstmt.setInt(3,c_id_no);
	}
	
	   try {
		   
		      cstmt.execute();
		      System.out.println("executed");
		      if (session_id.length() == 7) {
		    	  result = "���� ��û�� ��ҵǾ����ϴ�.";
		      }
		      else {
			      result = "���� ������ ��ҵǾ����ϴ�.";
		      }
		      //result = cstmt.getString(6);
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
		      try { myConn.commit(); cstmt.close(); myConn.close(); }
		      catch(SQLException ex) { }
		      }
		
	%>
</body>
</html>