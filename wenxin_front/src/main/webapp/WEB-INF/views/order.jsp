<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/13
  Time: 10:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的订单</title>
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
                <li><a href="/cart/view" class="right1">购物车<span class="glyphicon glyphicon-shopping-cart"></span><span>(0)</span></a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<!--导航栏 end-->
<div style="border-radius: 10px;width: 1000px;margin: auto;background-color: #dbdbdb;text-align: center">
    <h2>订单详情</h2>
    <h5>订单号：${order.no}</h5>
    <form method="post" action="/order/pay">
        <table class="table" style="margin: auto">
            <tr class="">
                <th>商品名称</th>
                <th>商品单价</th>
                <th>商品数量</th>
                <th>商品总价</th>
            </tr>
            <c:forEach items="${order.orderInfoList}" var="info">
                <tr class="tab-content">
                    <td style="text-align: left;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;max-width: 200px;padding-top:6px"
                        title="${info.productName}">${info.productName}</td>
                    <td>${info.price}</td>
                    <td>${info.count}</td>
                    <td>${info.amount}</td>
                </tr>
            </c:forEach>
            <tr>
                <td colspan="4">订单总金额：<span style="color: red;font-size: 18px">￥${order.totalMoney}元</span></td>
            </tr>
            <tr>
                <input type="hidden" name="orderId" value="${order.id}"/>
                <input type="hidden" name="orderNo" value="${order.no}"/>
                <td colspan="4" style="padding: 5px">
                    <table class="table text-center" style="width: 520px;margin: 0 auto;background-color: darkslategrey;color: whitesmoke">
                        <tr>
                            <td>买家</td>
                            <td>联系电话</td>
                            <td>预约见面地址</td>
                        </tr>
                        <tr id="addr">
                            <td style="width: 120px"><input type="text"  name="receiver" class="form-control"/>
                            </td>
                            <td style="width: 250px"><input type="text"  name="phone" maxlength="11" class="form-control"/></td>
                            <td>
                                <select name="address" class="form-control">
                                    <option v-for="addre in addr" :value="addre">{{addre}}</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="4"><input type="submit" class="btn btn-danger btn-block" value="确认"/></td>
            </tr>
        </table>
    </form>
</div>
<script>
    $(function () {
        $("form").submit(function () {
            var receiver=$("[name='receiver']").val()
            var phone=$("[name='phone']").val();
            var address=$("[name='address']").val();
            if(receiver==""||phone==""){
                alert("请输入买家以及买家联系电话")
                return false;
            }
            var pattern = /^1[34578]\d{9}$/;
            var x=pattern.test(phone);
            if (x==false){
                alert("电话号码格式错误")
            }else{
                var re=confirm("买家："+receiver+"\n联系电话："+phone+"\n预约见面地址："+address);
                if (re==true){
                    return true;
                }
            }
            return false;
        });
        var v = new Vue({
            el: "#addr",
            data: {
                addr: [],
            },
            mounted: function () {
                $.ajax({
                    url: "/static/conf/address.json",
                    success: function (resp) {
                        v.addr = resp.address;
                    }
                })
            }
        });
        axios({
            url: "/cart/list",
            method: "get",
        }).then(resp => {
            $(".glyphicon-shopping-cart").next().html("("+resp.data.data.totalCount+")");
        })
    });
</script>
<!--底部-->
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>
</html>
