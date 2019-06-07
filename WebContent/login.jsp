<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>수강신청 시스템 로그인</title>
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
	body{
		background-color: #2060aa;
	}
	
	img{
		margin:auto;
	}
	
	.login-box{
		margin:auto;
		width:400px;
		height:400px;
		top: 100px;
	}
	
	.card{
		top: 100px;
		text-align: center;
	}
	
	#input-text{
		height: 50px;
		margin-bottom:5px;
	}
	
</style>

<body>
	
	<div class="login-box">
		<div class="card border-left-primary shadow h-100 py-2">
		<img src="img/emb02_l.png" alt="logo" width="200px" height="200px">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                    	
                      <form method="post" action="login_verify.jsp">
        				<input class="col-12" id="input-text" type="text" name="userID" placeholder="아이디">
        				<input class="col-12" id="input-text" type="password" name="userPassword" placeholder="비밀번호">
        				<div id ="input-box">
        					<INPUT class="btn btn-primary" id="input-button" TYPE="SUBMIT" NAME="Submit" VALUE="로그인">
							<INPUT class="btn btn-primary" id="input-button" TYPE="RESET" VALUE="취소">
        				</div>
        			</form>
                    </div>
                  </div>
                </div>
        </div>
	</div>
	
</body>
</html>