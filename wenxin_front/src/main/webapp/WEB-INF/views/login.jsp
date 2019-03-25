<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
	<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>登录</title>
		<link rel="shortcut icon" href="../../static/img/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="../../static/login/css/bootstrap.min.css">
	<link rel="stylesheet" href="../../static/login/css/animate.css">
	<link rel="stylesheet" href="../../static/login/css/style.css">
	</head>
	<body class="style-3">
		<div class="container">
			<div class="row">
				<div class="col-md-4 col-md-push-8">
					<!-- Start Sign In Form -->
					<form action="#" class="fh5co-form animate-box" data-animate-effect="fadeInRight">
						<h2>登录</h2>
						<div class="form-group">
							<label for="username" class="sr-only">用户名</label>
							<input type="text" class="form-control" id="username" placeholder="用户名" autocomplete="off">
							<span class="error" style="color: red"></span>
						</div>
						<div class="form-group">
							<label for="password" class="sr-only">密码</label>
							<input type="password" class="form-control" id="password" placeholder="密码" autocomplete="off">
							<span class="error" style="color: red"></span>
						</div>
						<div class="form-group">
							<label for="remember"><input type="checkbox"  id="remember"> 记住用户名</label>
						</div>
						<div class="form-group">
							<p>没有账号? <a href="/main/regist">注册</a> | <a href="/main/forget">忘记密码?</a></p>
						</div>
						<div class="form-group">
							<input type="button" id="submit" value="登录" style="width: 100%" class="btn btn-primary">
						</div>
					</form>
					<!-- END Sign In Form -->
				</div>
			</div>
		</div>
	<!-- jQuery -->
	<script src="../../static/login/js/jquery.min.js"></script>
	<!-- Bootstrap -->
	<script src="../../static/login/js/bootstrap.min.js"></script>
	<!-- Placeholder -->
	<script src="../../static/login/js/jquery.placeholder.min.js"></script>
	<!-- Waypoints -->
	<script src="../../static/login/js/jquery.waypoints.min.js"></script>
	<!-- Main JS -->
	<script src="../../static/login/js/main.js"></script>
	<script src="../../static/js/axios.min.js"></script><script src="../../static/js/jquery.cookie.js"></script>
	<script type="text/javascript">
		$(function () {
            var cookie=$.cookie('wenxin-username');
            if (cookie!=""){
                $("#username").val(cookie);
			}
			$("#submit").click(function () {
			    if($("#username").val()==""){
			        $("#username").next().html("请输入用户名");
				}else if($("#password").val()==""){
                    $("#password").next().html("请输入密码");
				}else{
                    $("#username").next().html("");
                    $("#password").next().html("");
                    $(this).val("登录中...");
                    axios({
						url:"/user/login",
						method:"post",
						timeout:10000,
						params:{
						    userName:$("#username").val(),
						    password:$("#password").val(),
							remember:$("#remember").prop("checked"),
						}
					}).then(res=>{
					    if(res.data.code===0){
                            $(this).val("登录");
					        alert(res.data.msg)
						}
						else{
						    window.location.href="/main/index";
						}
					}).catch(resp=>{
                        $(this).val("登录");
                        alert("登录超时")
                    })
				}
            });
        })
	</script>
	</body>
</html>

