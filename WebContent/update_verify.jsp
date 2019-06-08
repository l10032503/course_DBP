<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%
	//update.jsp로부터 학번 혹은 교번, 변경할 비밀번호 정보를 받아온다
	String enterId = request.getParameter("id");
	String enterPwd = request.getParameter("password");
	String enterPwdConfirm = request.getParameter("passwordConfirm");
	
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "SOOK";
	String passwd = "2019";
	Connection myConn = null;
	CallableStatement cstmt = null;
	String sql;

	try { 
		Class.forName(dbdriver);
		myConn = DriverManager.getConnection(dburl, user, passwd);
		//변경할 비밀번호를 두 번 적는 부분에서 올바르게 적은 경우
		if (enterPwd.equals(enterPwdConfirm)) {
			//학생 모드
			if (enterId.length() == 7) {
				//CallableStatement + Procedure 사용 부분 - 학생의 비밀번호를 입력한 비밀번호로 변경한다
				sql = "{call change_pwd(?,?)}";
				cstmt = myConn.prepareCall(sql);
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
			//교수 모드
			else {
				//CallableStatement + Procedure 사용 부분 - 교수의 비밀번호를 입력한 비밀번호로 변경한다
				sql = "{call change_pwd_prof(?,?)}";
				cstmt = myConn.prepareCall(sql);
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
		//입력한 두 비밀번호가 일치하지 않는 경우
		else {
%>
<script>
	alert("비밀번호가 일치하지 않습니다");
	location.href = "update.jsp";
</script>
<%      
		}
	}
	catch (SQLException ex) {
		String sMessage;
		//트리거 사용 부분 - 비밀번호가 조건들을 만족하는지 확인한다
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
		out.println("alert('" + sMessage + "');");
		out.println("location.href = 'update.jsp';");
		out.println("</script>");
		out.flush();
	}   
	myConn.close();
%>