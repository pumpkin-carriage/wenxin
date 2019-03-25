<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
	<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>注册账号</title>
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
					<form  id="form" class="fh5co-form animate-box" data-animate-effect="fadeInRight">
						<h2>注册账号</h2>
						<div class="form-group">
							<label for="email" class="sr-only">邮箱</label>
							<input type="email" autofocus class="form-control" name="email" id="email" placeholder="邮箱" autocomplete="off" value="">
							<span class="error" style="color: red"></span>
						</div>
						<div class="form-group">
							<label for="password" class="sr-only">密码</label>
							<input type="password" class="form-control" name="password" id="password" placeholder="密码" autocomplete="off">
							<span class="error" style="color: red"></span>
						</div>
						<div class="form-group" >
							<label for="checkCode" class="sr-only">验证码</label>
							<input type="text" style="width: 40%" class="form-control-static" id="checkCode" placeholder="验证码" autocomplete="off">
							<input id="send"  style="width: 55%" type="button" value="获取验证码" class="btn btn-primary">
						</div>
						<div class="form-group">
							<p>已经有账号? <a href="/main/login">登录</a></p>
						</div>
						<div class="form-group">
							<input id="submit" type="button" style="width: 100%" value="提交" class="btn btn-primary">
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
	<script src="../../static/js/axios.min.js"></script>
	<script type="text/javascript">
		$(function () {
		    setInterval(function () {
				if($("#email").next().html()!=""){
				    $("#email").focus();
				}
            },100)
		    var count=60;
		    var reg=/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
		    $("#email").blur(function () {
				if($(this).val()==""){
				    $(this).next().html("请输入邮箱");
				}else if(!reg.test($(this).val())){
                    $(this).next().html("邮箱格式不正确")
                }else{
                    $(this).next().html("")
				    axios({
                        url:"/user/checkExist",
                        method:"post",
                        params:{
                            email:$(this).val()
                        }
                    }).then(resp=>{
                        if(resp.data.code===1){
                            $(this).next().html("该邮箱已存在");
                            $(this).focus();
                        }
                    })
                }
            });
            $("#password").blur(function () {
                if($(this).val()==""){
                    $(this).next().html("请输入密码");
                }else if($(this).val().length<6||$(this).val().length>16){
                    $(this).next().html("密码长度在6-16位")
                }
                else{
                    $(this).next().html("")
                }
            });
			$("#send").click(function () {
				if($("#email").val()==""){
				    $("#email").next().html("请输入邮箱")
				} else if(!reg.test($("#email").val())){
                    $("#email").next().html("邮箱格式不正确")
				}else{
				    if($("#email").next().html()==""){
				        $(this).val("发送中...");
                        axios({
                            url:"/user/email",
                            method:"post",
                            params:{
                                email:$("#email").val()
                            }
                        }).then(resp=>{
                            if(resp.data.code===1){
                                var timeout=setInterval(function () {
                                    $("#send").attr("disabled",true)
                                    $("#send").val(count+"秒后再次发送");
                                    count--;
                                    if(count<0){
                                        count=60;
                                        clearInterval(timeout);
                                        $("#send").attr("disabled",false)
                                        $("#send").val("获取验证码");
                                    }
                                },1000)

                            }
                            else{
                                alert("验证码获取失败")
                                $("#send").val("获取验证码");
                            }
                        })
                    }
				}
            });
			$("#submit").click(function () {
                if($("#email").val()==""){
                    $("#email").next().html("请输入邮箱")
                }else if(!reg.test($("#email").val())){
                    $("#email").next().html("邮箱格式不正确")
                } else if($("#password").val()==""){
                    $("#password").next().html("请输入密码")
                }else if($("#password").val().length<6||$("#password").val().length>16){
                    $("#password").next().html("密码长度在6-16位")
                } else if($("#checkCode").val()==""){
                    alert("请输入验证码");
                }else{
                    $(this).val("提交中...")
                    axios({
                        url:"/user/regist",
						timeout:1000,
                        params:{
                            email:$("#email").val(),
                            password:$("#password").val(),
                            code:$("#checkCode").val(),
                        }
                    }).then(resp=>{
                        if(resp.data.code===1){
                            window.location.href="/main/login"
                        }else{
                            $(this).val("提交")
                            alert(resp.data.msg);
                        }
                    }).catch(resp=>{
                        $(this).val("提交")
                        alert("服务器故障")
					})
                }
            });
        })
	</script>
	</body>
</html>

