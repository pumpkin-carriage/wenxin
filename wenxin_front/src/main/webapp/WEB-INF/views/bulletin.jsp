<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/13
  Time: 17:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>网站公告</title>
    <link rel="shortcut icon" href="../../static/img/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="../../static/bootstrap/css/bootstrap.min.css">
    <script type="text/javascript" src="../../static/bootstrap/js/jquery.min.js"></script>
    <script type="text/javascript" src="../../static/bootstrap/js/bootstrap.min.js"></script>
    <script src="../../static/js/dateformat.js"></script>
</head>
<style>
    nav {
        min-width: 1300px;
    }

    .right0 {
        margin-left: 800px;
    }

    .right1 {
        margin-left: 16px;
    }
    ul li {
        float: left;
        list-style-type: none;
        font-size: 16px;
        margin-left: 20px;
        padding-top: 15px;
    }

    a {
        text-decoration: none !important;
    }

    a:hover, a:link, a:visited {
        color: gray;
    }
    a:hover{
        color: blue;
    }
</style>
<body style="background-color: whitesmoke">
<!--导航栏 start-->
<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <ul>
                <li><a href="/">温馨首页</a></li>
                <li><a href="/bulletin">网站公告</a></li>
                <li role="presentation" class="dropdown right0">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true"
                       aria-expanded="false">
                        ${user.userName} <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu navbar-default" style="width: 100px;">
                        <li><a href="/order/myorder"><span class="glyphicon glyphicon-th"></span> 我的订单</a></li>
                     <li><a href="/user/logout"><span class="glyphicon glyphicon-remove-circle"></span>退出登录</a></li>
                    </ul>
                </li>
                <li><a href="/cart/view" class="right1">购物车<span class="glyphicon glyphicon-shopping-cart"></span><span>(0)</span></a></li>
            </ul>
        </div>
    </div>
    <script>
        $(function () {
            $.ajax({
                url:"/cart/list",
                type:"get",
                success:function (resp) {
                    $(".glyphicon-shopping-cart").next().html("("+resp.data.totalCount+")");
                }
            })
        })
    </script>
</nav>
<!--导航栏 end-->
<div style="width: 1200px;margin: 0 auto">
    <C:forEach items="${bulletinList}" var="bulletin" varStatus="index">
        <div class="panel panel-success">
            <div class="panel-heading">
                标题：${bulletin.title}
            </div>
            <div class="panel-body">
                内容：${bulletin.content}
            </div>
            <div class="panel-footer">发布日期：<span class="date">${bulletin.createTime}</span></div>
        </div>
    </C:forEach>
    <script>
    $(function () {
        for (var i=0;i<$(".date").length;i++){
            $($(".date")[i]).html(Todate1($($(".date")[i]).html()));
        }
    })
</script>
</div>
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>

</html>
