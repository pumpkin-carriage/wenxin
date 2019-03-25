<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/3/10
  Time: 14:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的商品</title>
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
<button type="button" class="btn btn-danger center-block" id="up" style="width: 800px;height: 60px">上传</button>
<C:forEach items="${products}" var="p" varStatus="index">
    <div class="panel panel-success" style="width: 800px;margin: 0 auto">
        <div class="panel-heading">
            名称：${p.name}
        </div>
        <div class="panel-body">
            <table class="table">
                <tr>
                    <td>状态</td>
                    <td>余量</td>
                    <td>售价</td>
                    <td>销量</td>
                    <td>图片</td>
                    <td>操作</td>
                </tr>
                <tr>
                    <td class="state1">${p.state==0||p.state==0?"待审核":p.state==1?"上架":"过期"}</td>
                    <td>${p.count}</td>
                    <td>${p.price}</td>
                    <td>${p.saleCount}</td>
                    <td><img class="img" src="${p.image}" width="30" height="30"></td>
                    <td style="width: 100px">
                        <input type="hidden" class="state" value="${p.state}">
                        <button type="button" class="btn btn-danger de" style="display: none">删除</button>
                        <button type="button" class="btn btn-danger ca" style="display: none">取消上架</button>
                        <input type="hidden" value="${p.id}">
                    </td>
                </tr>
            </table>
        </div>
    </div>
</C:forEach>
<div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <form method="post" action="/product/myproduct/add" >
                    <div class="form-group">
                        <label>商品名称</label>
                        <input type="text" name="name">
                    </div>
                    <div class="form-group">
                        <label>商品数量</label>
                        <input type="number" name="count">
                    </div>
                    <div class="form-group">
                        <label>市场价</label>
                        <input type="number" name="marketPrice">
                    </div>
                    <div class="form-group">
                        <label>售价</label>
                        <input type="number" name="price">
                    </div>
                    <div class="form-group">
                        <label>简单描述</label>
                        <select name="description">
                            <option value="3成新">3成新</option>
                            <option value="5成新">5成新</option>
                            <option value="7成新">7成新</option>
                            <option value="9成新">9成新</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>商品图片</label>
                        <input type="file" id="file1"  style="margin-bottom: 10px"><input type="button" class="btn btn-success fileinput-button" value="上传图片">
                        <input type="hidden" id="file" name="image">
                    </div>
                    <button type="submit" id="sub" class="btn btn-primary" style="display: none">上传</button>
                </form>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>
<script>
    $(function () {
        $(".fileinput-button").click(function (e) {
            var formData = new FormData();
            formData.append("file", document.getElementById("file1").files[0]);
            axios({
                url:"/product/upload",
                method:"post",

                data:formData
            }).then(resp=>{
                $("#file").val(resp.data.data);
                $("#sub").css("display","inline-block")
            })
        })
        $("#up").click(function () {
            $("#modal").modal("show")
        })
        $.ajax({
            url: "/static/conf/conf.json",
            type: "get",
            success: function (resp) {
                for (var i = 0; i < $(".img").length; i++) {
                    $($(".img")[i]).attr("src", resp.qiniu + $($(".img")[i]).attr("src"));
                }
            }
        })
        for (var i = 0; i < $(".state").length; i++) {
            var x = $($(".state")[i]);
            if (x.val() == 1) {
                x.next().css("display", "none");
                x.next().next().css("display", "inline-block");
            } else {
                x.next().css("display", "inline-block");
                x.next().next().css("display", "none");
            }
        }
        $(".de").click(function () {
            var x = $(this);
            var productId = $(this).next().next().val();
            if (confirm("确认删除")) {
            $.ajax({
                url:"/product/myproduct/del/"+productId,
                success:function (resp) {
                    window.location.href="/product/myproduct"
                }
            })}
        })
        $(".ca").click(function () {
            var x = $(this);
            var productId = $(this).next().val();
            if (confirm("确认取消上架")) {
                x.html("取消中")
                $.ajax({
                    url: "/product/myproduct/cancel/" + productId,
                    success: function (resp) {
                        x.parent().prev().prev().prev().prev().prev().html("已过期");
                        x.prev().css("display", "inline-block");
                        x.css("display", "none");
                    }
                })
            }
        })
    })
</script>
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>
</html>
