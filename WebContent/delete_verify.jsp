<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.sql.*" %>
<html><head><title> ������û �Է� </title></head>
<body>
<%

	String s_id = (String)session.getAttribute("user");
	String c_id=request.getParameter("c_id");
	int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
	System.out.println(c_id);
	System.out.println(s_id);
%>	
<%	
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "sook";
	String passwd = "2019";
	Connection myConn = null;
	String result = null;
	ResultSet rs = null;
	PreparedStatement pstmt = null;

	
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
	
    String sql = "delete from enroll where c_id = ? and c_number = ?";
    System.out.println("c_id :"+c_id + " / c_number: " + c_id_no);
	pstmt = myConn.prepareStatement(sql);
	pstmt.setString(1,c_id);
	pstmt.setInt(2,c_id_no);
//	rs= pstmt.executeUpdate();
	pstmt.executeUpdate();

	
	
	/*
	boolean besult = rs.next();
	System.out.println(besult);
	if(besult) {
		System.out.print(rs.getInt("s_credit"));
	}*/
	/*
	CallableStatement cstmt = myConn.prepareCall("{call DeleteEnroll()}",
			ResultSet.TYPE_SCROLL_SENSITIVE,
	        ResultSet.CONCUR_READ_ONLY);
	
	
	cstmt.execute();
		*/
		%>
		<script>
		alert("������û�� ��ҵǾ����ϴ�.");
		location.href="delete.jsp";
		</script>
		<%
		
		
		
		 myConn.commit(); pstmt.close(); myConn.close(); 
		
	//pstmt.close();
	//myConn.close();
	%>
</body>
</html>