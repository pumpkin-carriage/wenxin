<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/13
  Time: 12:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>预约成功</title>
    <link rel="shortcut icon" href="../../static/img/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="../../static/bootstrap/css/bootstrap.min.css">
    <script type="text/javascript" src="../../static/bootstrap/js/jquery.min.js"></script>
    <script type="text/javascript" src="../../static/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../../static/js/axios.min.js"></script>
    <script type="text/javascript" src="../../static/js/vue.js"></script>
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
</head>
<body>
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
</nav>
<!--导航栏 end-->
<div style="width:100%;margin: auto;text-align: center">
    <h3>亲爱的 <span style="color:red; font-size: 18px">${user.userName}</span> 你好，你的订单 <span style="color:red; font-size: 18px">${orderNo}</span> 已经预约成功，请等待卖家联系</h3>
    <h3><span id="t" style="background-color: blue;color: white;width: 50px;height: 50px;border-radius: 50%;display: inline-block;font-size: 45px;text-align: center;line-height: 50px">5</span>秒后跳转到主页</h3>
</div>
<script>
    $(function () {
        axios({
            url: "/cart/list",
            method: "get",
        }).then(resp => {
            $(".glyphicon-shopping-cart").next().html("("+resp.data.data.totalCount+")");
        })
        var ti=setInterval(function () {
            $("#t").html(parseInt( $("#t").html())-1)
            if ($("#t").html()=="1"){
                clearInterval(ti);
                setTimeout(function () {
                    window.location.href="/"
                },1000)
            }
        },1000)
    })
</script>
<!--底部-->
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>
</html>
