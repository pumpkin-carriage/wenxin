<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	    <meta name="Author" content="Lee">
	    <meta name="Keywords" content="后台模板">
	    <title></title>
	    <link rel="stylesheet" href="../../../static/layui/css/layui.css">
	    <link rel="stylesheet" href="../../../static/css/public.css" />
	    <script src="../../../static/layui/layui.js"></script>
	    <script src="../../../static/js/jquery.min.js"></script>
	    <script src="../../../static/js/axios.min.js"></script>
	</head>
	<body>
		<div class="change_pass">
			<div class="layui-form-item">
				<input type="hidden" id="userName" value="${user.userName}"/>
			    <label class="layui-form-label">旧密码：</label>
			    <div class="layui-input-block">
			      	<input type="password" id="oldPassword" name="" placeholder="请输入" autocomplete="off" class="layui-input">
					<span style="float: right;color: red" id="oldpwd"></span></div>

		  	</div>
		  	<div class="layui-form-item">
			    <label class="layui-form-label">新密码：</label>
			    <div class="layui-input-block">
			      	<input type="password" id="newPassword" name="" placeholder="请输入" autocomplete="off" class="layui-input">
					<span style="float: right;color: red" id="newpwd"></span></div>
		  	</div>
		  	<div class="layui-form-item">
			    <label class="layui-form-label">确认密码：</label>
			    <div class="layui-input-block">
			      	<input type="password" id="confirm" name="" placeholder="请输入" autocomplete="off" class="layui-input">
					<span style="float: right;color: red" id="conpwd"></span></div>
		  	</div>
		  	<div class="layui-form-item">
		      	<button id="submit" class="layui-btn" lay-submit>立即提交</button>
		  	</div>
		</div>
	</body>
	<script>
		layui.use(['jquery','element'], function(){
		  	var element = layui.element;
		  	var $ = layui.jquery;
		});
        layui.use('layer', function(){
            var layer = layui.layer;
        });
        $("#oldPassword").blur(function () {
			axios({
				url:"/admin/user/checkPassword",
				params:{
				    userName:$("#userName").val(),
				    password:$(this).val()
				}
			}).then(resp=>{
			    if (resp.data.code===0) {
                    $("#oldpwd").html("密码错误");
				}
			});
        }).focus(function () {
			$("#oldpwd").html("");
        });
		$("#newPassword").blur(function () {
		    var v=$(this).val();
		    if (v.length<6||v.length>16){
                $("#newpwd").html("密码长度为6-16位");
			}
        }).focus(function () {
            $("#newpwd").html("");
        });
        $("#confirm").blur(function () {
            var v=$("#newPassword").val();
            var v1=$(this).val();
            if (v!=v1){
                $("#conpwd").html("两次密码不匹配");
            }
        }).focus(function () {
            $("#conpwd").html("");
        });
		$("#submit").click(function () {
            var v1=$("#oldPassword").val();
            var v2=$("#newPassword").val();
            var v3=$("#confirm").val();
            var v11=$("#oldpwd").html();
            var v22=$("#newpwd").html();
            var v33=$("#conpwd").html();
            if(v1!=""&&v2!=""&&v3!=""&&v11==""&&v22==""&&v33==""){
                $.ajax({
					url:"/admin/user/updatePassword",
					data:{
					    userName:$("#userName").val(),
					    password:v2
					},
					success:function (resp) {
						if (resp.code===1){
                            layer.msg('修改成功', {icon: 1});
						}else{
                            layer.msg('修改失败', {icon: 5});
						}
                        $("#oldPassword").val("");
                        $("#newPassword").val("");
                        $("#confirm").val("");
                    }
				});
			}
        });
	</script>
</html>
