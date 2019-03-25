<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/10
  Time: 13:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的购物车</title>
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
                <li><a href="/cart/view" class="right1">购物车<span class="glyphicon glyphicon-shopping-cart"></span><span>(0)</span></a></li>
            </ul>
        </div>
    </div>
</nav>
<!--导航栏 end-->
<!--内容-->
<div class="content" id="app" style="width: 1200px;margin:0 auto;">
    <h1 style="color: red;font-family: 'DejaVu Serif', Georgia, 'Times New Roman', Times, serif">我的购物车</h1>
    <table class="table" style="font-size: 13px;">
        <tr style="background-color: whitesmoke;text-align: center">
            <td style="width: 165px;text-align: left"><input type="checkbox" id="all" @change="chgall"/>全选</td>
            <td>图片</td>
            <td>名称</td>
            <td>单价</td>
            <td>数量</td>
            <td>小计</td>
        </tr>
        <tr v-for="cart in cartList" style="background-color: white;">
            <td>
                <input type="hidden" v-model="cart.count"/>
                <input type="hidden" v-model="cart.amount"/>
                <input type="checkbox" @change="chg" class="one"/>
                <input type="hidden" v-model="cart.id"/>
            </td>
            <td><img class="img1" style="width: 35px;height:40px;padding-top: 5px" onclick="javascript:window.open(this.src)" :src="cart.pic"></td>
            <td style="text-align: center;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;max-width: 200px;padding-top: 23px"
                :title="cart.productName">{{cart.productName}}
            </td>
            <td style="text-align: center;padding-top: 22px">￥<span class="price" style="color: red">{{cart.price}}</span>元</td>
            <td style="width: 100px;padding-top: 10px">
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" v-model="cart.id"/>
                        <div class="input-group-addon sub" style="cursor:pointer;" @click="sub">-</div>
                        <input type="text" class="form-control count" readonly style="text-align: center;width: 50px;background-color: #5cb85c;color: white"
                               v-model="cart.count">
                        <div class="input-group-addon add" style="cursor: pointer;" @click="add">+</div>
                        <input type="hidden" v-model="cart.id"/>
                    </div>
                </div>
            </td>
            <td style="width: 100px;font-family: 黑体;text-align: center;padding-top: 22px">￥{{cart.amount}}元</td>
        </tr>
        <tr style="background-color: whitesmoke">
            <td colspan="6">
                <a style="color:blue !important;background-color: transparent !important;" href="javascript:void(0)" @click="del">删除选中的商品</a>
                <span style="position:absolute;right: 330px;color: black">已选择<span id="totalCount" style="color: red">0</span>件商品</span>
                <span style="position:absolute;right: 280px;color: black">总价：</span><br>
                <span style="color: red;position: absolute;right: 240px">￥<span id="totalAmount" style="color: red;font-size: 20px">0</span>元</span>
                <input type="button" style="float: right" class=" btn btn-danger" value="确认" @click="order"/>
            </td>
        </tr>
    </table>
</div>
<script>
    $(function () {
        var vue = new Vue({
            el: "#app",
            data: {
                cartList: null,
                cartListLength: 0,
                totalAmount: 0,
                ids: [],
                qiniu:'',
            },
            created: function () {
                this.init();
            },
            methods: {
                init:function(){
                    axios({
                        url: "/cart/list",
                        method: "get",
                    }).then(resp => {
                        vue.cartList = resp.data.data.list;
                        vue.cartListLength = resp.data.data.totalCount;
                        $(".glyphicon-shopping-cart").next().html("("+vue.cartListLength+")");
                        vue.totalAmount = resp.data.data.totalAmount;
                        if(vue.qiniu==''){
                            $.ajax({
                                url:"/static/conf/conf.json",
                                type:"get",
                                success:function (resp) {
                                    vue.qiniu=resp.qiniu;
                                    for (var i=0;i<$(".img1").length;i++){
                                        $($(".img1")[i]).attr("src",resp.qiniu+$($(".img1")[i]).attr("src"));
                                    }
                                }
                            })
                        }
                    })
                },
                order:function(e){
                    if (vue.ids.length!=1){
                        alert("请选择一项进行确认")
                    } else{
                        $(e.target).val("确认中");
                        axios({
                            url:"/order/add",
                            method:"post",
                            data:vue.ids,
                        }).then(resp=>{
                            window.location.href="/order/"+resp.data.data;
                        })
                    }
                },
                sub: function (e) {
                    if ($(e.target).next().val() > 1) {
                        axios({
                            url: "/cart/sub/" + $(e.target).prev().val(),
                            method: "put",
                        }).then(resp => {
                            vue.init();
                            $(e.target).next().val(parseInt($(e.target).next().val()) - 1)
                            var p = $(e.target).parent().parent().parent();
                            p.next().html("￥" + resp.data.data + "元")
                            p.prev().prev().prev().prev().children().first().val($(e.target).next().val());
                            p.prev().prev().prev().prev().children().first().next().val(resp.data.data);
                            var c=parseInt(p.prev().prev().prev().prev().children().val());
                            var m=parseInt( p.prev().prev().prev().prev().children().next().val());
                            if(p.prev().prev().prev().prev().children().first().next().next().prop("checked")==true){
                                $("#totalCount").html(parseInt($("#totalCount").html())-1);
                                $("#totalAmount").html(parseInt($("#totalAmount").html())-m/c);
                            }
                        })
                    }
                },
                add: function (e) {
                    axios({
                        url: "/cart/add/" + $(e.target).next().val(),
                        method: "put",
                    }).then(resp => {
                        vue.init();
                        $(e.target).prev().val(parseInt($(e.target).prev().val()) + 1)
                        var p = $(e.target).parent().parent().parent();
                        p.next().html("￥" + resp.data.data + "元")
                        p.prev().prev().prev().prev().children().first().val($(e.target).prev().val());
                        p.prev().prev().prev().prev().children().first().next().val(resp.data.data);
                        var c=parseInt(p.prev().prev().prev().prev().children().first().val());
                        var m=parseInt( p.prev().prev().prev().prev().children().first().next().val());
                        var c=parseInt(p.prev().prev().prev().prev().children().first().val());
                        var m=parseInt( p.prev().prev().prev().prev().children().first().next().val());
                        if(p.prev().prev().prev().prev().children().first().next().next().prop("checked")==true){
                            $("#totalCount").html(parseInt($("#totalCount").html())+1);
                            $("#totalAmount").html(parseInt($("#totalAmount").html())+m/c);
                        }
                    })
                },
                chg: function (e) {
                    if ($(e.target).prop("checked") == true) {
                        vue.ids.push($(e.target).next().val())
                        $("#totalCount").html(parseInt($("#totalCount").html())+parseInt($(e.target).prev().prev().val()));
                        $("#totalAmount").html(parseInt($("#totalAmount").html())+parseInt($(e.target).prev().val()));
                    }
                    else {
                        var v = $(e.target).next().val()
                        var i = vue.ids.indexOf(v);
                        vue.ids.splice(i, 1);
                        $("#totalCount").html(parseInt($("#totalCount").html())-parseInt($(e.target).prev().prev().val()));
                        $("#totalAmount").html(parseInt($("#totalAmount").html())-parseInt($(e.target).prev().val()));
                    }
                    if ($(".one").length == vue.ids.length) {
                        $("#all").prop("checked", true)
                    } else {
                        $("#all").prop("checked", false)
                    }
                },
                chgall: function (e) {
                    vue.ids = []
                    if ($(e.target).prop("checked") == true) {
                        $("#totalCount").html(0);
                        $("#totalAmount").html(0);
                        for (var i = 0; i < $(".one").length; i++) {
                            $($(".one")[i]).prop("checked", true)
                            vue.ids.push($($(".one")[i]).next().val())
                            $("#totalCount").html(parseInt($("#totalCount").html())+parseInt($($(".one")[i]).prev().prev().val()));
                            $("#totalAmount").html(parseInt($("#totalAmount").html())+parseInt($($(".one")[i]).prev().val()));
                        }
                    }
                    else {
                        for (var i = 0; i < $(".one").length; i++) {
                            $($(".one")[i]).prop("checked", false)
                        }
                        $("#totalCount").html(0);
                        $("#totalAmount").html(0);
                    }
                },
                del:function () {
                    if (vue.ids.length==0){
                        alert("请选择要删除的项")
                    }
                    else{
                        axios({
                            url:"/cart/del",
                            method:"delete",
                            data:vue.ids,
                        }).then(resp=>{
                            window.location.reload();
                            alert("删除成功")
                        })
                    }
                }
            }
        })
    })
</script>
<iframe width="100%" style="min-width: 1300px" height="250px" frameborder="0" src="/main/footer"/>
</body>
</html>
