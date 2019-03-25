<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
	<head>
		<meta charset="UTF-8">
		<title>温馨商城后台管理</title>
		<link rel="stylesheet" href="../../../static/css/normalize.min.css">
		<link rel="stylesheet" href="../../../static/css/login.css" />
		<link rel="shortcut icon" href="../../../static/img/favicon.ico" type="image/x-icon" />
		<script src="../../../static/js/prefixfree.min.js"></script>
		<script type="text/javascript" src="../../../static/js/vue.js"></script>
		<script type="text/javascript" src="../../../static/js/jquery.min.js"></script>
		<script type="text/javascript" src="../../../static/js/jquery.backstretch.min.js"></script>
		<script type="text/javascript" src="../../../static/layer/layer.js"></script>
		<script type="text/javascript" src="../../../static/layui/css/layui.css"></script>
		<script src="../../../static/js/axios.min.js"></script>
	</head>
	<body>
		<div id="login" class="login">
			<h1>温馨商城后台管理</h1>
			<form method="post">
				<input type="text" placeholder="用户名" v-model="user.userName" required="required" />
				<input type="password" name="p" placeholder="密码" v-model="user.password" required="required" />
				<button type="button" @click="login" class="btn-block btn-large" style="background-color: #d1a145;color: whitesmoke;cursor: pointer">登录</button>
			</form>
		</div>
		<script type="text/javascript">
			$.backstretch([
				'../../../static/img/bg0.jpg',
				'../../../static/img/bg1.jpg',
				'../../../static/img/bg2.jpg',
			], {
				fade: 1000, // 动画时长
				duration: 5000 // 切换延时
			});
			var vue = new Vue({
				el: "#login",
				data: {
					user: {
						userName: "zhangsan",
						password: "123456",
					}
				},
				methods: {
					login() {
						 if (vue.user.password == "" || vue.user.userName == "") {
							//配置一个透明的询问框
							layer.msg('请输入用户名和密码', {
								time: 800,
							});
						} else {
                             var index = layer.load();
								axios({
									url: "/admin/login/login",
									method: "post",
									params:{
									    userName:vue.user.userName,
                                        password:vue.user.password
                                    }
								}).then(resp => {
									if (resp.data.code === 0) {
										layer.msg('登陆失败', {
											time: 1000,
										});
                                        layer.close(index);
                                    } else {
										window.location.href="/admin/main/index";
									}
								});
						}
					}
				},
			});
		</script>
	</body>
</html>
