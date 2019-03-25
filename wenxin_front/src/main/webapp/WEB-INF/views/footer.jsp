<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>底部</title>
    <link rel="stylesheet" href="../../static/bootstrap/css/bootstrap.css">
    <script src="../../static/bootstrap/js/jquery.min.js"></script>
    <script src="../../static/bootstrap/js/bootstrap.min.js"></script>
    <style>
        div{
            display: inline-block;
        }
        div div{
            margin: 30px 100px 0 100px;
        }
        .title{
            font-size: 17px !important;
            margin-bottom: 20px;
        }
        span{
            display: block;
            margin-bottom: 10px;
            font-size: 14px;
        }
        .phone{
            float: right;
            margin-top: 30px;
            border-left: 2px solid gray;
            padding-left: 30px;
        }
        .phone1{
            color: orange;
            font-size: 30px;
        }
        .glyphicon-phone-alt{
            font-size: 10px;
        }
        .btn{
            height: 35px;
        }
        a{
            text-decoration: none !important;
        }
        a:hover,a:link,a:visited{
            color: gray;
        }
        a:hover{
            color: blue;
        }
    </style>
</head>
<body style="margin: 0">
<div class="" style="width: 100%;min-width: 1200px">
    <hr>
    <div>
        <span class="title">帮助中心</span>
        <span class="content"><a href="#">账户管理</a></span>
        <span class="content"><a href="#">购物指南</a></span>
        <span class="content"><a href="#">订单操作</a></span>
    </div>
    <div>
        <span class="title">服务支持</span>
        <span class="content"><a href="#">售后政策</a></span>
        <span class="content"><a href="#">自助服务</a></span>
        <span class="content"><a href="#">相关下载</a></span>
    </div>
    <div>
        <span class="title">关注我们</span>
        <span class="content"><a href="#">新浪微博</a></span>
        <span class="content"><a href="#">官方微信</a></span>
        <span class="content"><a href="#">联系我们</a></span>
    </div>
    <div class="phone">
        <span class="phone1">400-100-100</span>
        <span>周一至周五8:00-18:00</span>
        <span><button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-phone-alt" aria-hidden="true"></span>联系客服</button></span>
    </div>
</div>
</body>
</html>