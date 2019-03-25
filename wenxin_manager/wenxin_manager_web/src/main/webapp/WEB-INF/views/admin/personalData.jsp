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
	    <script src="../../../static/js/axios.min.js"></script>
	    <script src="../../../static/js/jquery.min.js"></script>
	</head>
	<body>
	<div>
			<div class="layui-form-item">
				<input type="hidden" id="id" value="${user.id}"/>
			    <label class="layui-form-label">用户名：</label>
			    <div class="layui-input-block">
			      	<input type="text" readonly id="userName" placeholder="请输入" value="${user.userName}" autocomplete="off" class="layui-input">
			    </div>
		  	</div>
			<div class="layui-form-item">
			    <label class="layui-form-label">真实姓名：</label>
			    <div class="layui-input-block">
			      	<input type="text" id="name" placeholder="请输入" value="${user.name}" autocomplete="off" class="layui-input">
			    </div>
		  	</div>
		  	<div class="layui-form-item">
			    <label class="layui-form-label">用户手机：</label>
			    <div class="layui-input-block">
			      	<input type="text" id="phone" lay-verify="required|phone" value="${user.phone}" placeholder="请输入" autocomplete="off" class="layui-input">
			    </div>
		  	</div>
		  	<div class="layui-form-item">
			    <label class="layui-form-label">用户邮箱：</label>
			    <div class="layui-input-block">
			      	<input type="email" id="email" required lay-verify="email" value="${user.email}" placeholder="请输入" autocomplete="off" class="layui-input">
			    </div>
		  	</div>
		  	<div class="layui-form-item text_algin">
		      	<button id="submit" class="layui-btn">立即提交</button>
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
		$(function () {
			$("#submit").click(function () {
				axios({
					url:"/admin/user/updateUser",
					method:"put",
					data:{
					    id:$("#id").val(),
						userName:$("#userName").val(),
						name:$("#name").val(),
						phone:$("#phone").val(),
						email:$("#email").val()
					}
				}).then(resp=>{
                    if (resp.data.code===1){
                        layer.msg('修改成功', {icon: 1});
                    }else{
                        layer.msg('修改失败', {icon: 5});
                    }
				})
            })
        })
	</script>
</html>
