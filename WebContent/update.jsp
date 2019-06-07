<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head> <meta charset="EUC-KR">
	<title>데이터베이스를 활용한 수강신청 시스템입니다.</title>
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
<style>
	html{
		height:100vh;
		overflow:hidden;
	}
	body{
		background:#f8f9fa;
	}
	#accordionSidebar{
		width:20%;
		float:left;
	}

	.navbar-expand{
		width:70%;
		float:left;
		text-align:right
	}
	#content-wrapper{
		width:70%;
		height:85vh;
		float:left;
		overflow:auto
	}
	#update_post{
		margin : auto;
		width:100%;
	}
	
	#update_table{
		background: white;
		margin : auto;
		width:80%;
	}
	
	#isLeaved_table{
		background: white;
		margin : 10px auto;
		width:80%;
	}

</style>
<body>
<%@include file="top.jsp"%>
<%
String dbdriver = "oracle.jdbc.driver.OracleDriver"; //JDBC 드라이버 로딩
String dburl = "jdbc:oracle:thin:@localhost:1521:orcl"; //url
String user = "sook"; //oracle login id
String passwd = "2019"; //pw

Class.forName(dbdriver); // DriverManager.registerDriver(dbdriver);
Connection myConn = null;
CallableStatement cstmt = null;
String sql = null;

// show_stu_info 변수
String pwd = null; 
int isLeavedNo = 0; String isLeaved = "";
%>
	<!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

      <!-- Main Content -->
      <div id="content">

            <% if (session_id != null) {
            	try{
                    // oracle 연결
                     myConn = DriverManager.getConnection(dburl, user, passwd);
                    
                     if(session_id.length() == 7){
                         /* show_stu_info 호출*/
    	                   sql = "{call show_stu_info(?,?,?,?,?,?)}";
        	               cstmt = myConn.prepareCall(sql);
            	           cstmt.setString(1, session_id); // s_id
           		            cstmt.registerOutParameter(2, java.sql.Types.VARCHAR); // s_pwd
           	    	        cstmt.registerOutParameter(3, java.sql.Types.VARCHAR); //s_name
        	               cstmt.registerOutParameter(4, java.sql.Types.INTEGER); // s_grade
            	           cstmt.registerOutParameter(5, java.sql.Types.VARCHAR); // s_major
                	       cstmt.registerOutParameter(6, java.sql.Types.INTEGER); // isLeaved
    	                   cstmt.execute(); // 프로시저 실행
    	
        	               pwd = cstmt.getString(2);
            	           isLeavedNo = cstmt.getInt(6);
                	       
    	                   if(isLeavedNo == 1){
        	            	   isLeaved = "휴학";
            	           }else{
        	            	   isLeaved = "재학";
            	           }
                	       System.out.println(session_id + pwd + isLeavedNo + isLeaved);
                     }else{
                    	 
                    	 sql = "{call show_prof_info(?,?,?,?)}";
      	               cstmt = myConn.prepareCall(sql);
          	           cstmt.setString(1, session_id); // p_id
         		            cstmt.registerOutParameter(2, java.sql.Types.VARCHAR); // p_pwd
         	    	        cstmt.registerOutParameter(3, java.sql.Types.VARCHAR); //p_name
      	               cstmt.registerOutParameter(4, java.sql.Types.VARCHAR); // p_major
              	       cstmt.execute(); // 프로시저 실행
  	
      	               pwd = cstmt.getString(2);
          	           
              	       System.out.println(session_id + pwd);
      
                     }
                          }catch(SQLException e){
                      out.println(e);
                      e.printStackTrace();
                  }
            
            
            %>
                    
        <!-- Begin Page Content -->
        <div class="container-fluid">

          <!-- Page Heading -->
          <div class="d-sm-flex align-items-center justify-content-between mb-4">
          <div class="col-12">
          <form action="update_verify.jsp?id=<%=session_id%>" method="post" id="update_post">
          		<table class="table table-bordered" align="center" id="update_table">
          		<tr>
          			<th colspan="2" style="text-align:center">수정할 비밀번호</th>
          		</tr>
   				<tr>
     				<td id="update_td">비밀번호</td>
     				<td ><input id="update_pw_in" type="password" name="password" size="10"></td>
   				</tr>
   				<tr>
     				<td id="update_td_confirm">비밀번호 확인</td>
     				<td ><input id="update_pw_in_confirm" type="password" name="passwordConfirm" size="10" ></td>
   				</tr>
   				<tr>
       				<td colspan="2" align="center">
        			<input class="btn btn-primary" id="update_btn" type="submit" value="수정 완료">
        			<input class="btn btn-primary" id="update_btn" type="reset" value="초기화">
        			</td>
    			</tr>
    			</table>
          	</form>
          	<%
          	if(session_id.length() == 7){
          	%>
          	<table class="table table-bordered" align="center" id="isLeaved_table">
          		<tr>
          			<th colspan="2" style="text-align:center">휴학신청</th>
          		</tr>
          		<tr>
     				<td colspan="1" id = "student_isLeaved">학적상태</td>
     				<td colspan="1" ><%=isLeaved%></td>
   				</tr>
   				<tr>
   				<%
        	if (isLeavedNo == 1) {
        		%>
        		<td colspan="2"align="center">
        		<input class="btn btn-primary" id="leave_btn" name = "leaved" type="button" value = "휴학 취소" onclick = "leaveSemesterCancle()">
        		</td>
        		<%
        		}
        	else {
        		%>
           		<td colspan="2"align="center">
           		<input class="btn btn-primary" id="leave_btn" name = "leaved" type="button" value = "휴학  신청" onclick = "leaveSemester()">
           		</td>
           	<%
        		}
          	}		
   				
        %>
        		</tr>

    			</table>
          </div>
          	
		  </div>
		  
		  
		<% myConn.close(); }%>

        </div>
        <!-- /.container-fluid -->

      </div>
      <!-- End of Main Content -->

    </div>
    <!-- End of Content Wrapper -->

</body>
<script>
   function leaveSemester() {
      var message = confirm('휴학을 신청하시겠습니까?');
      if(message == true) {
         location.href = 'update_leaved.jsp?leaved=true';
         return true;
      }
   }
   function leaveSemesterCancle() {
	      var message = confirm('휴학을 취소하시겠습니까?');
	      if(message == true) {
	         location.href = 'update_leaved.jsp?leaved=false';
	         return true;
	      }
	   }
</script>
</html>
