<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/13
  Time: 12:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的所有订单</title>
    <link rel="shortcut icon" href="../../static/img/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="../../static/bootstrap/css/bootstrap.min.css">
    <script type="text/javascript" src="../../static/bootstrap/js/jquery.min.js"></script>
    <script type="text/javascript" src="../../static/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../../static/js/axios.min.js"></script>
    <script type="text/javascript" src="../../static/js/dateformat.js"></script>
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
<img src="../../static/img/logo.png" width="120" height="auto"/>
<div style="width: 800px;margin:0 auto;min-height: 150px">
    <c:if test="${empty orderList}">
        <div class="panel panel-success" id="no">
            <div class="panel-body">
                暂无订单
            </div>
        </div>
    </c:if>
    <c:forEach items="${orderList}" var="order" varStatus="index">
        <div class="panel panel-success">
            <div class="panel-heading">
                订单编号：${order.no}<span class="date" style="color: blue;margin-left: 100px">${order.payTime}</span>
            </div>
            <div class="panel-body">
                <table class="table">
                    <tr class="modal-title">
                        <td>图片</td>
                        <td>商品名称</td>
                        <td>商品数量</td>
                        <td>商品小计</td>
                    </tr>
                    <c:forEach items="${order.orderInfoList}" var="list">
                        <tr class="tab-content">
                            <td><img class="img" src="${list.image}" width="30px" height="30px"></td>
                            <td style="text-align: left;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;max-width: 300px;"
                                title="${list.productName}">${list.productName}</td>
                            <td>${list.count}</td>
                            <td>${list.price}</td>
                        </tr>
                    </c:forEach>
                    <tr>
                        <td colspan="4" style="text-align: center;color: darkblue">订单总金额：${order.totalMoney}</td>
                    </tr>
                </table>
            </div>
            <input type="hidden" value="${order.id}">
            <div class="panel-footer">
                <span class="state">订单状态：${order.state==0?"已预约":order.state==1?"预约成功":order.state==2?"已完成":order.state==3?"已取消":"待预约"}</span>
                <button class="btn btn-primary del" style="display: none">删除</button>
                <button class="btn btn-primary judge" style="display: none" >评价</button>
                <button class="btn btn-primary cancel" style="display: none">取消</button>
            </div>

            <input type="hidden" value="${order.state}">
        </div>
    </c:forEach>
</div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <form method="post" action="/order/comment">
                    <input type="hidden" name="orderId" id="orderId">
                    <div class="form-group">
                        <label>该商品与实际相符？</label>
                        <input type="radio" value="是" checked name="questionA">是&nbsp;&nbsp;<input type="radio" name="questionA" value="否">否
                    </div>
                    <div class="form-group">
                        <label>该商品价格怎样？</label>
                        <input type="radio" value="偏高" name="questionB">偏高&nbsp;&nbsp;<input type="radio" name="questionB" value="合适" checked>合适&nbsp;&nbsp;<input type="radio" name="questionB" value="偏低">偏低
                    </div>
                    <div class="form-group">
                        <label>总体感觉怎样怎样？</label>
                        <input type="radio" value="偏高" name="questionC">较好&nbsp;&nbsp;<input type="radio" name="questionC" value="合适" checked>一般&nbsp;&nbsp;<input type="radio" name="questionC" value="偏低">较差
                    </div>
                    <button type="submit" class="btn btn-primary">提交</button>
                </form>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>
<script>
    $(function () {
        $(".del").click(function () {
            var id = $(this).parent().prev().val();
            var x = $(this);
            if (confirm("确认删除")) {
                $.ajax({
                    url: "/order/del/" + id,
                    success: function (resp) {
                        alert("删除成功")
                        x.parent().parent().remove();
                        if ($(".panel-success").length == 0) {
                            window.location.href = "/order/myorder";
                        }
                    }
                })
            }
        });

        $(".cancel").click(function () {
            var id = $(this).parent().prev().val();
            var x = $(this);
            if (confirm("确认取消")) {
                $.ajax({
                    url: "/order/cancel/" + id,
                    success: function (resp) {
                        alert("取消成功")
                        x.prev().css("display", "none");
                        x.css("display", "none");
                        x.prev().prev().css("display", "inline-block")
                        x.prev().prev().prev().html("已取消");
                    }
                })
            }
        });
        $(".judge").click(function () {
            var id = $(this).parent().prev().val();
            var x = $(this);
            $("#orderId").val(id)
            $("#myModal").modal("show")

        });
        for (var i = 0; i < $(".state").length; i++) {
            if ($($(".state")[i]).parent().next().val() == 2 || $($(".state")[i]).parent().next().val() == 4) {
                $($(".state")[i]).next().css("display", "inline-block")
                $($(".state")[i]).next().next().css("display", "none")
                $($(".state")[i]).next().next().next().css("display", "none")
            }
            if ($($(".state")[i]).parent().next().val() == 1) {
                $($(".state")[i]).next().next().css("display", "inline-block")
                $($(".state")[i]).next().next().next().css("display", "inline-block")
                $($(".state")[i]).next().css("display", "none")
            }
            if ($($(".state")[i]).parent().next().val() == 3 || $($(".state")[i]).parent().next().val() == 5) {
                $($(".state")[i]).next().next().css("display", "none")
                $($(".state")[i]).next().next().next().css("display", "none")
                $($(".state")[i]).next().css("display", "inline-block")
            }
        }
        for (var i = 0; i < $(".date").length; i++) {
            $($(".date")[i]).html(Todate1($($(".date")[i]).html()));
        }
        $("td").css({
            "height": "45px",
            "fontFamily": "\"Lucida Sans Unicode\", \"Lucida Grande\", sans-serif"
        })
        var qiniu = "";
        if (qiniu == "") {
            $.ajax({
                url: "/static/conf/conf.json",
                type: "get",
                success: function (resp) {
                    qiniu = resp.qiniu;
                    for (var i = 0; i < $(".img").length; i++) {
                        $($(".img")[i]).attr("src", resp.qiniu + $($(".img")[i]).attr("src"));
                    }
                }
            })
        }
    })
</script>
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>
</html>
