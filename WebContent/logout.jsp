<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>
<html>
<head>
<title>수강신청 시스템 로그아웃</title>
	<meta charset = "UTF-8">
</head>
<body>
<% 
	session.invalidate();
%>
	<form action = "login.jsp?=session_id" method = "post"> 
	<script>
		alert("로그아웃 되었습니다.");
		location.href = "login.jsp";
	</script>
	</form>
</body>
</html>