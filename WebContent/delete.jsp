<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>

<%@ include file = "top.jsp" %>


<html>
<head>
<title>수강신청 입력</title>
<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  	<meta name="description" content="">
  	<meta name="author" content="">
  
	
	<link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  	<link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">
  	<!-- Custom styles for this template-->
  	<link href="css/sb-admin-2.min.css" rel="stylesheet">
</head>
<style type="text/css">
	html{
		height:100vh;
		overflow:hidden;
	}
	body{
		background:#f8f9fa;
	}
	#accordionSidebar{
		float:left;
	}

	.navbar-expand{
		width:70%;
		float:left;
		text-align:right
	}
	#content-wrapper{
		width:70%;
		height:80vh;
		float:left;
		overflow:auto
	}
	#table-header{
		width:70%;
		float:left;
		overflow:auto
	}
	
	
	select{
		float:right;
	}
	
	#current-credit{
		margin-left:20px;
		margin-right:5px;
		float:left;
	}
	
	.form{
		margin : auto;
		width:100%;
	}
	
	.table{
		background: white;
		margin : auto;
		width:100%;
	}
	th{
		text-align: center;
		word-break: keep-all;
	}
	td{
		text-align: center;
		margin: auto;
		word-break: keep-all;
		white-space:pre-line
	}
</style>

<body>


<div id="table-header">
<%   if (session_id==null){
	response.sendRedirect("login.jsp");
	return;
}%>
<%
	Connection myConn = null;     
	Statement stmt = null;
	ResultSet myResultSet = null;   String mySQL = "";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user="sook";     String passwd="2019";
    String dbdriver = "oracle.jdbc.driver.OracleDriver";    
    session_id=(String)session.getAttribute("user");
    String sql="";
 	 
    String id = request.getParameter("userID");
    String pwd = request.getParameter("userPassword");
	int cmax = 30;
	try {
		
		Class.forName(dbdriver);
	    myConn =  DriverManager.getConnection (dburl, user, passwd);
		stmt = myConn.createStatement();	

    } catch(SQLException ex) {
	     System.err.println("SQLException: " + ex.getMessage());
    }
	
	if(session_id.length() == 5){
		String creditSQL = "{? = call get_prof_credit(?)}";
	  	CallableStatement cstmt = myConn.prepareCall(creditSQL);
	  	cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
	  	cstmt.setString(2, session_id);
	  	cstmt.execute();
		int p_credit = cstmt.getInt(1);
		%>
	
		<div id="current-credit">
			<p>현재 개설한 강의 : <%= p_credit %> 학점</p>
		</div>
		<%
	}else if (session_id.length() == 7){
		String creditSQL = "{? = call get_stu_credit(?)}";
		CallableStatement cstmt = myConn.prepareCall(creditSQL);
		cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
		cstmt.setString(2, session_id);
		cstmt.execute();
		int s_credit = cstmt.getInt(1);
%>

<div id="current-credit">
	<p>현재 신청한 학점 : <%= s_credit %></p>
</div>
<%
	}
%>

</div>
	<!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

      <!-- Main Content -->
      <div id="content">

        <div class="container-fluid">

          <!-- Page Heading -->
          <div class="d-sm-flex align-items-center justify-content-between mb-4">
          
          

<table class="table table-bordered" width="75%" align="center" border>
<br>
<tr>
         <th>과목번호</th>
         <th>분반</th>
         <th>과목명</th>
         <th>교수</th>
         <th>시간</th>
         <th>학점</th>
         <th>수강취소</th>
      </tr>
<%

	mySQL="select * from course";
	
    if(session_id.length() == 7){
 	    sql = "select * from COURSE c, enroll e WHERE c.c_id = e.c_id AND c.c_number = e.c_number AND e.s_id ='" + session_id +
    		 "' AND e.c_year = 2019 AND e.c_semester = 2 AND c.c_year = 2019 AND c.c_semester = 2";
     }
         
    if(session_id.length() == 5){ 
    	 sql = "select distinct * from COURSE c, professor p WHERE c.p_id = p.p_id AND p.p_id = '" + session_id +
        		 "' AND c.c_year = 2019 AND c.c_semester = 2";         
    }
	
	myResultSet = stmt.executeQuery(sql);

	if (myResultSet != null) {
		
	while (myResultSet.next()) {
		
		String c_id = myResultSet.getString("c_id");//과목번호
		String c_name = myResultSet.getString("c_name");//과목명
	
		int c_credit= myResultSet.getInt("c_credit");//학점			
		int c_number = myResultSet.getInt("c_number");//분반
		int p_id = myResultSet.getInt("p_id");
		int c_day1 = myResultSet.getInt("c_day1");
		int c_day2 = myResultSet.getInt("c_day2");
		int c_period1 = myResultSet.getInt("c_period1");
		int c_period2 = myResultSet.getInt("c_period2");
		
		String c_time = "";
		
		switch(c_day1){
		case 1:
			c_time = "월";
			break;
		case 2:
			c_time = "화";
			break;
		case 3:
			c_time = "수";
			break;
		case 4:
			c_time = "목";
			break;
		case 5:
			c_time = "금";
			break;
		default:
			break;
		}
		
		c_time = c_time + " " + c_period1 + " 교시";
		
		switch(c_day2){
		case 1:
			c_time = c_time +"\n월";
			break;
		case 2:
			c_time = c_time +"\n화";
			break;
		case 3:
			c_time = c_time +"\n수";
			break;
		case 4:
			c_time = c_time +"\n목";
			break;
		case 5:
			c_time = c_time +"\n금";
			break;
		default:
			break;
		}
		
		c_time = c_time + " " + c_period2 + " 교시";
		
		String pSQL = "select p_name from professor where p_id = '" + p_id + "'";
		Statement prof_stmt = myConn.createStatement();
		ResultSet rs = prof_stmt.executeQuery(pSQL);
		rs.next();
		String p_name = rs.getString("p_name");
		
		
%>
<tr>
  <td align="center"><%= c_id %></td>
  <td align="center"><%= c_number %></td> 
  <td align="center"><%= c_name %></td>
  <td align="center"><%= p_name %></td>
  <td align="center"><%= c_time %></td>
  <td align="center"><%= c_credit %></td>
  <td align="center"><a href="delete_verify.jsp?c_id=<%= c_id %>&c_id_no=<%= c_number %>">삭제</a></td>
</tr>
<%
		}
	}

%>
</table>

          </div>
        </div>
        <!-- /.container-fluid -->

      </div>
      <!-- End of Main Content -->

    </div>
    <!-- End of Content Wrapper -->
 

</body>

</html>