<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/3/10
  Time: 20:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>待处理的订单</title>
    <link rel="shortcut icon" href="../../static/img/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="../../static/bootstrap/css/bootstrap.min.css">
    <script type="text/javascript" src="../../static/bootstrap/js/jquery.min.js"></script>
    <script type="text/javascript" src="../../static/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../../static/js/axios.min.js"></script>
    <script type="text/javascript" src="../../static/js/dateformat.js"></script>
    <script src="../../static/js/dateformat.js"></script>
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

        a:hover {
            color: blue;
        }
    </style>
</head>
<body>
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
                <li><a href="/cart/view" class="right1">购物车<span class="glyphicon glyphicon-shopping-cart"></span><span>(0)</span></a>
                </li>
            </ul>
        </div>
    </div>
    <script>
        $(function () {
            $.ajax({
                url: "/cart/list",
                type: "get",
                success: function (resp) {
                    $(".glyphicon-shopping-cart").next().html("(" + resp.data.totalCount + ")");
                }
            })
        })
    </script>
</nav>
<C:forEach items="${orders}" var="order" varStatus="index">
    <div class="panel panel-success" style="width: 800px;margin: 0 auto">
        <div class="panel-heading">
            订单编号：${order.no}
        </div>
        <div class="panel-body">
            <table class="table">
                <tr>
                    <td>商品名称</td>
                    <td>订单时间</td>
                    <td>订单状态</td>
                    <td>订单金额</td>
                    <td>操作</td>
                </tr>
                <tr>
                    <td style="text-align: left;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;max-width: 250px;">
                        <c:forEach items="${order.orderInfoList}" var="info">
                            ${info.productName}
                        </c:forEach>
                    </td>
                    <td class="date">${order.createTime}</td>
                    <td>${order.state==0?"待接受预约":""}</td>
                    <td>${order.totalMoney}</td>
                    <td>
                        <input type="hidden" value="${order.id}">
                        <input type="button" class="btn btn-danger re" value="接受"></td>
                </tr>
            </table>
        </div>
    </div>
</C:forEach>
<script>
    $(function () {
        for (var i=0;i<$(".date").length;i++){
            $($(".date")[i]).html(Todate1($($(".date")[i]).html()));
        }
        $(".re").click(function () {
            var x=$(this).prev().val();
            axios({
                url:"/order/receive/"+x
            }).then(resp=>{
                window.location.href="/product/receiveOrder";
            })
        })
    })
</script>
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>
</html>
