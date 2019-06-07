<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
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
<%@ include file="top.jsp" %>
<div id="table-header">
<%
	int year_semester = 0;
	if( request.getParameter("year_semester") == null){
		year_semester = 201902;
	}else{
		year_semester = Integer.parseInt(request.getParameter("year_semester"));
	}
	System.out.println(session_id);
	System.out.println(session_id == null);
	if (session_id == null){
		System.out.println(session_id);
		response.sendRedirect("login.jsp");
		return;
	}else{
		System.out.println(session_id);
	}
	
	int year = year_semester / 100;
	int semester = year_semester % 100;
	
	if(year_semester == 201902){
		%>
		<select name="year_semester" onchange="location = this.value;">
			<option value='insert.jsp?year_semester=201902' selected="selected">2019년 2학기</option>	
			<option value='insert.jsp?year_semester=201901' >2019년 1학기</option>
    		<option value='insert.jsp?year_semester=201802'>2018년 2학기</option>
    		<option value='insert.jsp?year_semester=201801'>2018년 1학기</option>
		</select>
		<%
	}else if(year_semester == 201901){
		%>
		<select name="year_semester" onchange="location = this.value;">
			<option value='insert.jsp?year_semester=201902'>2019년 2학기</option>	
			<option value='insert.jsp?year_semester=201901' selected="selected" >2019년 1학기</option>
    		<option value='insert.jsp?year_semester=201802'>2018년 2학기</option>
    		<option value='insert.jsp?year_semester=201801'>2018년 1학기</option>
		</select>
		<%
	}else if(year_semester == 201802){
		%>
		<select name="year_semester" onchange="location = this.value;">
			<option value='insert.jsp?year_semester=201902'>2019년 2학기</option>	
			<option value='insert.jsp?year_semester=201901' >2019년 1학기</option>
    		<option value='insert.jsp?year_semester=201802' selected="selected">2018년 2학기</option>
    		<option value='insert.jsp?year_semester=201801'>2018년 1학기</option>
		</select>
		<%
	}else if(year_semester == 201801){
		%>
		<select name="year_semester" onchange="location = this.value;">
			<option value='insert.jsp?year_semester=201902'>2019년 2학기</option>	
			<option value='insert.jsp?year_semester=201901' >2019년 1학기</option>
    		<option value='insert.jsp?year_semester=201802'>2018년 2학기</option>
    		<option value='insert.jsp?year_semester=201801' selected="selected">2018년 1학기</option>
		</select>
		<%
	}

	Connection myConn = null;     
	PreparedStatement pstmt = null;
	ResultSet myResultSet = null;
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user="sook";     String passwd="2019";
	String dbdriver = "oracle.jdbc.driver.OracleDriver"; 
	int isLeaved = 0;
	
	try {
					
			Class.forName(dbdriver);
		    myConn =  DriverManager.getConnection (dburl, user, passwd);
		    String sql = "select * from COURSE where c_year = ? and c_semester = ?";
			pstmt = myConn.prepareStatement(sql);
			pstmt.setInt(1, year);
			pstmt.setInt(2,semester);
	
	    } catch(SQLException ex) {
		     System.err.println("SQLException: " + ex.getMessage());
	    }

%>
<% 
	if(session_id.length() == 7){
		String creditSQL = "{? = call get_stu_credit(?)}";
		CallableStatement cstmt = myConn.prepareCall(creditSQL);
		cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
		cstmt.setString(2, session_id);
		cstmt.execute();
		int s_credit = cstmt.getInt(1);
		
		String std_SQL = "select isLeaved from student where s_id = '" + session_id + "'";
		Statement std_stmt = myConn.createStatement();
		ResultSet std_rs = std_stmt.executeQuery(std_SQL);
		std_rs.next();

		isLeaved = std_rs.getInt("isLeaved");
		if (isLeaved == 0){
	%>
	<div id="current-credit">
		<p>현재 신청한 학점 : <%= s_credit %></p>
	</div>

	<%}else{
		%>
	<div id="current-credit">
		<p>현재 휴학 중입니다.</p>
	</div>
	<%
	}
	
}%>
</div>
	<!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

      <!-- Main Content -->
      <div id="content">

        <div class="container-fluid">

          <!-- Page Heading -->
          <div class="d-sm-flex align-items-center justify-content-between mb-4">

<table class="table table-bordered" align="center" border>
<tr>
         <th>과목번호</th>
         <th>분반</th>
         <th>과목명</th>
         <th>교수</th>
         <th>시간</th>
         <th>학점</th>
         <th>현재 수강인원</th>
         <th>최대 수강인원</th>
         <th>수강신청</th>
      </tr>
<%


	//mySQL = "select c_id,c_id_no,c_name,c_unit from course where c_id not in (select c_id from enroll where s_id='" + session_id + "')";
	myResultSet = pstmt.executeQuery();
	System.out.println("myresultset"+myResultSet);

	if (myResultSet != null) {
	while (myResultSet.next()) {
		
		
		String c_id = myResultSet.getString("c_id");//과목번호
		int c_number = myResultSet.getInt("c_number");//분반
		String c_name = myResultSet.getString("c_name");//과목명
		int p_id = myResultSet.getInt("p_id");
		int c_day1 = myResultSet.getInt("c_day1");
		int c_day2 = myResultSet.getInt("c_day2");
		int c_period1 = myResultSet.getInt("c_period1");
		int c_period2 = myResultSet.getInt("c_period2");
		int c_max = myResultSet.getInt("c_max");
		int c_current = myResultSet.getInt("c_current");
		
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
		
		c_time = c_time + " " + c_period1 + "교시";
		
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
		
		c_time = c_time + " " + c_period2 + "교시";
		
		int c_credit= myResultSet.getInt("c_credit");//학점
		
		String mySQL = "select p_name from professor where p_id = '" + p_id + "'";
		Statement prof_stmt = myConn.createStatement();
		ResultSet rs = prof_stmt.executeQuery(mySQL);
		rs.next();
		String p_name = rs.getString("P_NAME");
		
%>
<tr>
  <td align="center"><%= c_id %></td>
  <td align="center"><%= c_number %></td> 
  <td align="center"><%= c_name %></td>
  <td align="center"><%= p_name %></td>
  <td align="center"><%= c_time %></td>
  <td align="center"><%= c_credit %></td>
  <td align="center"><%= c_current %></td>
  <td align="center"><%= c_max %></td>
  <%
  	if(year_semester == 201902 && isLeaved == 0 && session_id.length() == 7){
  		%>
  		<td align="center"><a href="insert_verify.jsp?c_id=<%= c_id %>&c_id_no=<%= c_number %>">신청</a></td>
  		<%
  	}else{
	  %>
	  <td align="center">신청불가</td>
  		<%
  }
%>
</tr>
<%
		}
	}
	//stmt.close(); 
	//pstmt.close();
	//myConn.close();
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