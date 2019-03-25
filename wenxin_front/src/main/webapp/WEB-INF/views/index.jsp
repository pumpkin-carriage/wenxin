<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>温馨首页</title>
    <link rel="shortcut icon" href="../../static/img/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="../../static/bootstrap/css/bootstrap.min.css">
    <script type="text/javascript" src="../../static/bootstrap/js/jquery.min.js"></script>
    <script type="text/javascript" src="../../static/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../../static/js/vue.js"></script>
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
    .content{
        width: 1200px;
        height:645px;
        margin: 0 auto;
        position: relative;
    }
    .carousel-control.left {
        background-image:none;
        background-repeat: repeat-x;
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#80000000', endColorstr='#00000000', GradientType=1);
    }
    .carousel-control.right {
        left: auto; right: 0;
        background-image:none;
        background-repeat: repeat-x;
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#00000000', endColorstr='#80000000', GradientType=1);
    }
    .search{
        margin-bottom: 20px;
    }
    .search-text{
        width: 300px;
        display: inline-block;
    }
    form{
        margin-left: 755px;
        font-size: 16px;
        color: blue;
        font-family: 黑体;
    }
    .btn-primary{
        margin-top: -5px;
    }
    .lunbo{
        position: absolute;
        width: 1200px;
        z-index: 0;
    }
    .lunboleft{
        margin-left: 202px;
    }

    .typeItem{
        position: absolute;
        width: 200px;
        height: 450px;
        top: 80px;
        background-color:#666666;
        opacity: 0.8;
        z-index: 1;
    }
   .typeItem ul li:hover{
        background-color: darkslategrey;
    }
    .typeItem ul li span{
        position: absolute;
        right: 6px;
        font-weight: bold;
    }
    #productType ul li{
        width: 200px;
        margin-left: -40px;
        font-family: "Leelawadee UI";
    }
    .typeItem a{
        display: block;
        height: 40px;
        color: white !important;
        font-size: 16px;
    }
    .second ul li:hover{
        background-color: transparent;
    }
    .typeItem ul li:hover .second{
        display: block !important;
        background-color: white;
        height: 450px;
        width: 520px;
        position: absolute;
        top: 0;
        left: 200px;
    }
    .second a{
        display: inline-block;
        color: black !important;
        margin-left: 50px;
        margin-top: 10px;
        margin-bottom: 10px;
    }
    .second a:hover{
        color: orangered !important;
    }
    .search li a:hover{
        border-bottom: 3px solid blue;
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
<div id="contents" class="content">
    <div id="productType" class="typeItem">
        <ul>
            <li  class="container-fluid" v-for="type in productTypeList">
                <a :href="'/product/pList/'+type.id"><img src="../../static/img/logo.png" width="30" height="30"/>{{type.name}}<span>&gt;</span></a>
                <div class="second" style="display: none">
                    <ul>
                        <li style="float: left !important;" v-for="child in type.children">
                            <a :href="'/product/pList/'+child.id"  :title="child.description"><img src="../../static/img/logo.png" width="30" height="30"/>{{child.name}}</a>
                        </li>
                    </ul>
                </div>
            </li>
        </ul>
    </div>
    <div class="search">
        <img src="../../static/img/logo.png" width="60px" height="60px"/>
        <div style="display: inline-block;position: absolute;left: 150px;">
            <ul>
                <li  class="container-fluid" v-for="type in productTypeList">
                    <a :href="'/product/pList/'+type.id">{{type.name}}</a>
                </li>
            </ul>
        </div>
        <form method="post" action="/product/pList" style="position: relative;margin-top: -34px">
            <input type="text" class="form-control search-text"  name="keyword"  placeholder="荣耀6x">
            <button type="submit"  class="btn btn-primary"><span class="glyphicon glyphicon-search"></span> 搜索</button>
        </form>
    </div>
    <div id="carousel-example-generic" class="lunbo carousel slide" data-ride="carousel">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
            <li data-target="#carousel-example-generic" data-slide-to="1"></li>
        </ol>
        <!-- Wrapper for slides -->
        <div class="carousel-inner" role="listbox">
            <div class="item active">
                <img src="../../static/img/xm1.jpg" alt="...">
            </div>
            <div class="item">
                <img src="../../static/img/xm2.jpg" alt="...">
            </div>
        </div>

        <!-- Controls -->
        <a class="lunboleft left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="lunboright right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>
    <div style="position: relative;margin-top: 480px">
        <button type="button" class="btn btn-danger up" style="width: 597px;height: 100px">查看我的商品</button>
        <button type="button" class="btn btn-danger re" style="width: 597px;height: 100px">待处理的订单</button>
    </div>
</div>
<script>
    $(function () {
        var vue=new Vue({
            el:"#contents",
            data:{
                productTypeList: [],
            },
            created:function () {
                $.ajax({
                    url:"/productType/list",
                    type:"get",
                    success:function (resp) {
                        vue.productTypeList=resp.data;
                    }
                })
            }
        })
        $(".up").click(function () {
            window.location.href="/product/myproduct";
        })
        $(".re").click(function () {
            window.location.href="/product/receiveOrder";
        })
    })
</script>
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>
</html>