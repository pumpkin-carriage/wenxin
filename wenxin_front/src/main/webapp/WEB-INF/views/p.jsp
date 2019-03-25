<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/11
  Time: 23:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商品详情</title>
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
<div style="width: 1000px;margin: 20px auto;position: relative">
    <h1 style="color: white;width: 100%;background-color: #999999;font-family: 黑体">商品详情</h1>
    <div style="display: inline-block;border: 2px solid red;">
        <img class="img1" onclick="javascript:window.open(this.src)" style="cursor: pointer;width: 200px;height: 250px" src="${product.image}"/>
    </div>
    <div style="display: inline-block;width:775px;height: 250px;position:absolute;left: 225px;background-color:whitesmoke">
        <input type="hidden" id="proId" value="${product.id}"/>
        <p style="font-family: 微软雅黑;font-size: 19px;font-weight: bold">${product.name}<br><span style="color: red;font-size: 12px">${product.description}</span></p>
        <p style="text-decoration: line-through;color: red;font-size: 15px">市场价：￥${product.marketPrice}</p>
        <p style="color: red;font-size: 18px">售价：￥${product.price}</p>
        <div class="form-group" style="width: 100px">
            <div class="input-group">
                <div class="input-group-addon" id="sub" style="cursor:pointer;">-</div>
                <input type="text" class="form-control" readonly style="text-align: center;width: 50px" id="count"
                       value="1">
                <div class="input-group-addon" id="add" style="cursor: pointer;">+</div>
            </div>
        </div>
        <p><input id="submit" type="button" class="btn btn-danger" value="加入购物车"/></p>
    </div>
    <hr style="position: relative;margin-top: 50px">
    <h1 style="color: white;width: 100%;background-color: #999999;font-family: 黑体">浏览记录</h1>
    <div style="width: 1150px;height:350px;">
        <c:forEach items="${history}" var="p" varStatus="index">
            <c:if test="${index.count==1}">
                <div onclick="javascript:window.location.href='/product/p/'+${p.id}" style="cursor:pointer;display: inline-block;border: 2px double red;text-align: center;background-color: #2b542c;color: white">
                    <img class="img1" style="width: 200px;height: 250px" src="${p.image}"/><br>
                    <p style="white-space: nowrap;overflow: hidden;text-overflow:ellipsis;max-width: 200px" title="${p.name}">${p.name}</p>
                    <span style="color: red">￥${p.price}</span>
                </div>
            </c:if>
            <c:if test="${index.count!=1}">
                <div onclick="javascript:window.location.href='/product/p/'+${p.id}" style="cursor:pointer;display: inline-block;text-align: center;border: 2px dotted red;background-color: #2b542c;color: white">
                    <img class="img1" style="width: 200px;height: 250px" src="${p.image}"/><br>
                    <p style="white-space: nowrap;overflow: hidden;text-overflow:ellipsis;max-width: 200px" title="${p.name}">${p.name}</p>
                    <span style="color: red">￥${p.price}</span>
                </div>
            </c:if>
        </c:forEach>
    </div>
    <div>
        <hr>
        <h1 style="color: red">商品相关信息</h1>
        <h5>商品名称：${product.name}</h5>
        <h5>商品描述：${product.description}</h5>
        <h5>商品价格：${product.price}</h5>
    ${product.richContent}
    </div>
</div>
<script>
    $(function () {
        var qiniu="";
           if (qiniu==""){
               $.ajax({
                   url: "/static/conf/conf.json",
                   type: "get",
                   success: function (resp) {
                       qiniu=resp.qiniu;
                       for (var i = 0; i < $(".img1").length; i++) {
                           $($(".img1")[i]).attr("src", resp.qiniu + $($(".img1")[i]).attr("src"));
                       }
                   }
               })
           }
        $("#sub").click(function () {
            var v=$(this).next();
            if (v.val()>1){
                v.val(parseInt(v.val())-1)
            }
        });
        $("#add").click(function () {
            var v=$(this).prev();
            v.val(parseInt(v.val())+1)
        });
        $("#submit").click(function () {
            axios({
                url:"/cart/add",
                method:"post",
                params:{
                    proId:$("#proId").val(),
                    count:$("#count").val(),
                }
            }).then(resp=>{
                window.location.href="/cart/view";
            })
        });
    })
</script>
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>
</html>
