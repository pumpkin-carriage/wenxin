<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/11
  Time: 22:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商品列表</title>
    <link rel="shortcut icon" href="../../static/img/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="../../static/bootstrap/css/bootstrap.min.css">
    <script type="text/javascript" src="../../static/bootstrap/js/jquery.min.js"></script>
    <script type="text/javascript" src="../../static/bootstrap/js/bootstrap.min.js"></script>
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
    .search{
        margin-bottom: 20px;
    }
    .search-text{
        width: 300px;
        display: inline-block;
        margin-left: 406px;
        height: 50px;
        font-size: 16px;
        color: blue;
        font-family: 黑体;
    }
    a:hover{
        color: blue;
    }
</style>
<body style="background-color: whitesmoke">
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
<div class="search" style="min-width: 1000px">
    <img src="../../static/img/logo.png" width="60px" height="60px"/>
    <form method="post" action="/product/pList" style="position: relative;margin-left: 130px">
        <input type="text" class="form-control search-text"  name="keyword"  placeholder="荣耀6x">
        <button type="submit"  class="btn btn-primary" style="position: relative;margin-top: -3px"><span class="glyphicon glyphicon-search" style="width: 50px;display: block;height: 33px;line-height: 33px;">搜索</span> </button>
    </form>
</div>
<div style="width: 1200px;margin: 0 auto;">
    <ul>
        <c:if test="${not empty productList}">
            <c:forEach items="${productList}" var="product">
                <li style="list-style: none;float: left;">
                    <div class="modal-content" style="text-align: center;width: 204px;display: inline-block;cursor: pointer;margin-bottom: 5px;background-color: white !important;">
                        <a style="text-decoration: none;background-color: transparent !important;" href="/product/p/${product.id}">
                            <img width="200px" height="250px" class="img" src="${product.image}" style="margin-top: 1px">
                            <p style="white-space: nowrap;overflow: hidden;text-overflow:ellipsis;max-width: 200px;color: black !important;" title="${product.name}">名称：${product.name}</p>
                            <p style="color: orangered;font-size: 16px">零售价：￥${product.price}元</p>
                            <span style="color: orangered;font-size: 16px">剩余数量：${product.count}</span>
                        </a>
                    </div>
                </li>
            </c:forEach>
        </c:if>
        <c:if test="${empty productList}">
        <h4>~~空空如也~~</h4>
        </c:if>
    </ul>
</div>
<script>
    $(function () {
        $.ajax({
            url: "/static/conf/conf.json",
            type: "get",
            success: function (resp) {
                for (var i = 0; i < $(".img").length; i++) {
                    $($(".img")[i]).attr("src", resp.qiniu + $($(".img")[i]).attr("src"));
                }
            }
        })
    })
</script>
<!--底部-->
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>
</html>
