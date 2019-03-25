<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  product: Spring
  Date: 2019/2/4
  Time: 9:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商品管理</title>
    <link rel="stylesheet" type="text/css" href="../../../static/layui/css/layui.css"/>
    <script type="text/javascript" src="../../../static/js/vue.js"></script>
    <script type="text/javascript" src="../../../static/js/axios.min.js"></script>
    <script type="text/javascript" src="../../../static/layui/layui.js"></script>
    <script type="text/javascript" src="../../../static/js/jquery.min.js"></script>
    <script type="text/javascript" src="../../../static/js/dateformat.js"></script>
    <script type="text/javascript" src="../../../static/zTree/js/jquery.ztree.core.js"></script>
    <script type="text/javascript" src="../../../static/zTree/js/jquery.ztree.excheck.js"></script>
    <script type="text/javascript" src="../../../static/zTree/js/jquery.ztree.exedit.js"></script>
    <script type="text/javascript" src="../../../static/js/wangEditor.min.js"></script>
    <link rel="stylesheet" href="../../../static/zTree/css/demo.css" type="text/css">
    <link rel="stylesheet" href="../../../static/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
</head>
<body>
<div id="app" style="padding: 20px; background-color: #F2F2F2;">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md16">
            <div class="layui-card">
                <div class="layui-card-header">
                    <div class="layui-btn-group">
                        <button id="add" class="layui-btn">增加</button>
                        <button id="edit" class="layui-btn layui-bg-blue">编辑</button>
                        <button id="del" class="layui-btn layui-bg-red">删除</button>
                        <button id="onsale" class="layui-btn layui-bg-blue">上架</button>
                        <button id="offsale" class="layui-btn layui-bg-red">下架</button>
                        <button id="user" class="layui-btn layui-bg-green">查看商品提供者</button>
                    </div>
                    <span style="color: red;font-size: 10px;"> 注：修改后的商品需重新上架才能更新es数据</span>
                </div>
                <div class="layui-card-body">
                    <table id="table" class=" layui-table">
                        <tr class="layui-tab-title">
                            <th><input type="checkbox" id="all"/></th>
                            <th style="text-align: center;">序号</th>
                            <th style="text-align: center;">商品名称</th>
                            <th style="text-align: center;width: 72px">上架时间</th>
                            <th style="text-align: center;">状态</th>
                            <th style="text-align: center;">销售价格</th>
                            <th style="text-align: center;">剩余数量</th>
                            <th style="text-align: center;">图片</th>
                        </tr>
                        <c:forEach items="${productPage.data}" var="product" varStatus="index">
                            <tr class="layui-tab-content" style="text-align: center">
                                <td style="text-align: left">
                                    <input type="hidden" value="${product.userId}"/>
                                    <input type="hidden" value="${index.count}"/>
                                    <input type="hidden" value="${product.state}"/>
                                    <input type="hidden" value="${product.id}"/>
                                    <input type="checkbox" class="one"/>
                                    <input type="hidden" value="${product.name}"/>
                                    <input type="hidden" value="${product.productTypeId}"/>
                                    <input type="hidden" value="${product.brandId}">
                                    <input type="hidden" value="${product.count}">
                                    <input type="hidden" value="${product.marketPrice}">
                                    <input type="hidden" value="${product.price}">
                                    <input type="hidden" value="${product.image}">
                                    <input type="hidden" value="${product.description}">
                                </td>
                                <td>${index.count}</td>
                                <td style="white-space: nowrap;overflow: hidden;text-overflow:ellipsis;max-width: 400px"
                                    title="${product.name}">${product.name}</td>
                                <td class="date">${product.onSaleTime}</td>
                                <td class="state">${product.state}</td>
                                <td>${product.price}</td>
                                <td>${product.count}</td>
                                <td style="text-align: center;vertical-align: middle"><img
                                        onclick="window.open(this.src)" style="cursor: pointer;width: 20px;height:auto"
                                        class="img" src="${product.image}"/></td>
                            </tr>
                        </c:forEach>
                    </table>
                    <div id="page"></div>
                </div>
                <input type="hidden" id="totalCount" value="${productPage.totalCount}"/>
                <input type="hidden" id="pageNo" value="${productPage.pageNo}"/>
            </div>
        </div>
    </div>
</div>

<div id="modal" style="display: none;overflow: hidden;">
    <form class="layui-form" action="/admin/product/addOrupdate" method="post">
        <div class="layui-form-item">
            <input type="hidden" id="id" name="id"/>
            <input type="hidden" id="productTypeId" name="productTypeId"/>
            <label class="layui-form-label">商品名称</label>
            <input type="text" required id="name" name="name" class="layui-input-inline" autocomplete="off"
                   style="width: 200px;height: 36px;border:1px solid whitesmoke;">
            <label class="layui-form-label">商品类型</label>
            <input id="ptype" type="text" readonly class="layui-input-inline"
                   style="width: 200px;height: 36px;border:1px solid whitesmoke;"/>
            &nbsp;<a id="menuBtn" href="#" onclick="showMenu(); return false;"
                     style="text-decoration:none;line-height: 35px">选择</a>
            <div id="menuContent" class="menuContent" style="position:fixed;display:none;z-index: 2">
                <ul id="treeDemo" class="ztree"
                    style="z-index:-1;margin-top:0; height: 300px;width:190px;"></ul>
            </div>
            <br>
            <br>
            <div class="layui-form-item" style="position: relative;">

                <div><label class="layui-form-label">品牌名称</label>
                    <select id="brandId" name="brandId" lay-verify="required"
                            class="layui-input" style="display: inline-block;width: 200px">
                        <option value=""></option>
                        <c:forEach items="${brandList}" var="brand">
                            <option value="${brand.id}">${brand.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div id="row2" style="position: relative;left: 320px;top: -55px;z-index:1">
                <label class="layui-form-label">剩余库存</label>
                <input type="number" required id="count" name="count" class="layui-input-inline" autocomplete="off"
                       style="width: 200px;height: 36px;border:1px solid whitesmoke;">
            </div>
            <div id="row3" class="layui-form-item" style="position: relative;top: -40px;z-index: 1;">
                <label class="layui-form-label">市场价格</label>
                <input type="number" required id="marketPrice" name="marketPrice" class="layui-input-inline"
                       autocomplete="off"
                       style="width: 200px;height: 36px;border:1px solid whitesmoke;">
                <label class="layui-form-label">销售价格</label>
                <input type="number" required id="price" name="price" class="layui-input-inline" autocomplete="off"
                       style="width: 200px;height: 36px;border:1px solid whitesmoke;">
            </div>
            <div id="desc" class="layui-form-item" style="position: relative;top: -50px">
                <div>
                    <label class="layui-form-label"></span>所属用户</label>
                    <select id="userId" required name="userId" lay-verify="required"
                            class="layui-input" style="display: inline-block;width: 100px">
                        <option value=""></option>
                        <c:forEach items="${userList}" var="user">
                                <option value="${user.id}">${user.userName}</option>
                        </c:forEach>
                    </select>
                    <input type="hidden" id="image" name="image"/>
                    <button type="button" class="layui-btn" id="upload"
                            style="margin-left:2px;width: 90px;height: 36px;border:1px solid whitesmoke;text-align: left">
                        <i class="layui-icon">&#xe67c;</i>图片
                    </button>
                    <img id="img" style="position:absolute;width: 50px;height: auto" src=""/>
                </div>
                <div style="position: absolute;left: 320px;top: 0">
                    <label class="layui-form-label">简单描述</label>
                    <select required name="description" id="description" class="layui-input"
                            style="display: inline-block;width: 200px;height: 36px;margin-top:-38px;margin-left:108px">
                        <option value="3成新" style="font-family: 微软雅黑">3成新</option>
                        <option value="5成新" style="font-family: 微软雅黑">5成新</option>
                        <option value="7成新" style="font-family: 微软雅黑">7成新</option>
                        <option value="9成新" style="font-family: 微软雅黑">9成新</option>
                    </select>
                    <%--<input type="text" required id="description" name="description" class="layui-input-inline"
                           autocomplete="off"
                           style="width: 200px;height: 36px;margin-top:-38px;margin-left:108px;border:1px solid whitesmoke;">--%>
                </div>
            </div>
        </div>
        <div id="editor" style="position: absolute;top: 200px;z-index: 1"></div>
        <textarea style="display: none;" id="rich_content" name="richContent"></textarea>
        <button id="submit" type="submit" class="layui-btn layui-btn-fluid"
                style="display:none;position: absolute;bottom: 0;">提交
        </button>
    </form>
</div>
<style>
    .w-e-text-container {
        height: 180px !important;
    }
</style>
</body>
<script type="text/javascript">
    layui.use('layer', function () {
        var layer = layui.layer;
    });
    layui.use('element', function () {
        var element = layui.element;
    });
    var qiniu = "";
    layui.use('upload', function () {
        var upload = layui.upload;
        var index;
        //执行实例
        var uploadInst = upload.render({
            elem: '#upload'
            , url: '/upload/'
            , before: function (obj) {
                index = layer.load();
            }
            , done: function (res) {
                if (res.code === 1) {
                    layer.close(index);
                    $("#image").val(res.data);
                    $("#submit").css("display", "inline-block");
                    $("#img").css("display", "inline-block");
                    $('#img').attr('src', qiniu + res.data); //图片链接（base64）
                    return layer.msg('上传成功');
                }
            }
            , error: function () {
                layer.close(index);
                return layer.msg('上传失败');
            }
        });
    });
    var E = window.wangEditor
    var editor = new E('#editor')
    var rich_content = $('#rich_content')
    editor.customConfig.onchange = function (html) {
        // 监控变化，同步更新到 textarea
        rich_content.val(html)
    }
    editor.create()
    // 初始化 textarea 的值
    rich_content.val(editor.txt.html())
    var setting = {
        view: {
            dblClickExpand: false
        },
        data: {
            simpleData: {
                enable: true
            }
        },
        callback: {
            beforeClick: beforeClick,
            onClick: onClick
        }
    };

    var zNodes = [];
    $.ajax({
        url: "/admin/productType/getSimpleZtreeList",
        type: "get",
        async: false,
        success: function (resp) {
            zNodes = resp.data;
        }
    })

    function beforeClick(treeId, treeNode) {
        var check = (treeNode && !treeNode.isParent);
        if (!check) layer.alert("不能选择根类型...");
        return check;
    }

    function onClick(e, treeId, treeNode) {
        var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
            nodes = zTree.getSelectedNodes(),
            v = "";
        nodes.sort(function compare(a, b) {
            return a.id - b.id;
        });
        for (var i = 0, l = nodes.length; i < l; i++) {
            v += nodes[i].name + ",";
        }
        if (v.length > 0) v = v.substring(0, v.length - 1);
        $("#ptype").attr("value", v);
        $("#productTypeId").val(treeNode.id);
        $("#treeDemo").hide()
        $("#row2").css("z-index", "1");
        $("#row3").css("z-index", "1");
        $("#desc").css("z-index", "1");
        $("#editor").css("z-index", "1");
    }

    function showMenu() {
        var cityObj = $("#ptype");
        var cityOffset = $("#ptype").offset();
        $("#menuContent").css({
            left: cityOffset.left + "px",
            top: cityOffset.top + cityObj.outerHeight() + "px"
        }).slideDown("fast");
        $("body").bind("mousedown", onBodyDown);
        $("#treeDemo").show()
        $("#row2").css("z-index", "-1");
        $("#row3").css("z-index", "-1");
        $("#desc").css("z-index", "-1");
        $("#editor").css("z-index", "-1");
    }

    function hideMenu() {
        $("#menuContent").fadeOut("fast");
        $("body").unbind("mousedown", onBodyDown);
        $("#row2").css("z-index", "1");
        $("#row3").css("z-index", "1");
        $("#desc").css("z-index", "1");
        $("#editor").css("z-index", "1");
    }

    function onBodyDown(event) {
        if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length > 0)) {
            hideMenu();
        }
    }

    layui.use('layer', function () {
        var layer = layui.layer;
    });
    $(function () {
        $("tr").attr("bgColor", "cc0085").css("color", "white").mouseover(function () {
            $(this).css("backgroundColor", "cc0085")
        });
        $($("tr")[0]).attr("bgColor", "green").css("color", "white").mouseover(function () {
            $(this).css("backgroundColor", "green")
        });
        $.ajax({
            url: "/static/conf/qiniu.json",
            async: false,
            success: function (res) {
                qiniu = res.qiniu;
                console.log(qiniu)
            }
        })
        $.fn.zTree.init($("#treeDemo"), setting, zNodes);
        var ids = [];
        var indexs = [];
        for (var i = 0; i < $(".date").length; i++) {
            if ($($(".date")[i]).html() != "") {
                var d = Todate($($(".date")[i]).html());
                $($(".date")[i]).html(d)
            }
        }
        for (var i = 0; i < $(".state").length; i++) {
            var td = $($(".state")[i]);
            // alert(td.html())
            if (td.html() == "0") {
                td.html("下架").css({"color": "white", "font-family": "SimHei"});
            } else if(td.html() == "1"){
                td.html("上架").css({"color": "orange", "font-family": "SimHei"});
            }else if(td.html() == "2"){
                td.html("过期").css({"color": "gray", "font-family": "SimHei"});
            }else{
                td.html("已被用户删除").css({"color": "gray", "font-family": "SimHei"});
            }
        }
        $("#all").change(function () {
            if ($(this).prop("checked") == true) {
                ids = [];
                indexs = []
                for (var i = 0; i < $(".one").length; i++) {
                    $($(".one")[i]).prop("checked", true)
                    ids.push($($(".one")[i]).prev().val())
                    indexs.push($($(".one")[i]).prev().prev().prev().val())
                }
            } else {
                ids = [];
                indexs = [];
                for (var i = 0; i < $(".one").length; i++) {
                    $($(".one")[i]).prop("checked", false)
                }
            }
        })
        $(".one").change(function () {
            if ($(this).prop("checked") == true) {
                ids.push($(this).prev().val())
                indexs.push($(this).prev().prev().prev().val())
            } else {
                var v = $(this).prev().val();
                var index = ids.indexOf(v);
                ids.splice(index, 1);

                v = $(this).prev().prev().prev().val();
                index = indexs.indexOf(v);
                indexs.splice(index, 1);
            }
            if (ids.length == $(".one").length) {
                $("#all").prop("checked", true)
            } else {
                $("#all").prop("checked", false)
            }
        });
        $("#del").click(function () {
            if (ids.length == 0) {
                layer.msg('请选择要删除的商品', {
                    time: 1000
                });
            } else {
                var flag = 0;
                for (var i = 0; i < indexs.length; i++) {
                    if ($($(".one")[indexs[i] - 1]).prev().prev().val() == "1") {
                        flag = 1;
                        layer.msg("不能删除已上架的商品",)
                        return;
                    }
                }
                if (flag == 0) {
                    axios({
                        url: "/admin/product/delete",
                        method: "delete",
                        data: ids,
                    }).then(resp => {
                        if (resp.data.code === 1) {
                            window.location.href = "/admin/product/productPage?page=" + $("#pageNo").val() + "&limit=6";
                        }
                    })
                }
            }
        })
        $("#add").click(function () {
            layer.open({
                type: 1,//类型
                area: ['711px', '497px'],//定义宽和高
                title: '添加商品',//题目
                shadeClose: true,//点击遮罩层关闭
                move: false,
                fixed: false,
                closeBtn: 0,
                anim: 1,
                shade: 0.6,
                content: $("#modal")//打开的内容
            });
            $("#id").val("");
            $("#name").val("");
            $("#productTypeId").val("");
            $("#brandId").val("");
            $("#count").val("");
            $("#marketPrice").val("");
            $("#price").val("");
            $("#image").val("");
            $("#description").val("");
            $("#img").attr("src", "");
            $("#submit").css("display", "none");
            $("#img").css("display", "none");
        });
        $("#edit").click(function () {
            if (ids.length == 0) {
                layer.msg('请选择要修改的商品', {
                    time: 1000
                });
            } else if (ids.length > 1) {
                layer.msg('选择的商品过多', {
                    time: 1000
                });
            } else {
                for (var i = 0; i < $(".one").length; i++) {
                    if ($($(".one")[i]).prev().val() == ids[0]) {
                        layer.open({
                            type: 1,//类型
                            area: ['711px', '497px'],//定义宽和高
                            title: '编辑商品',//题目
                            shadeClose: true,//点击遮罩层关闭
                            move: false,
                            fixed: false,
                            closeBtn: 0,
                            anim: 4,
                            shade: 0.6,
                            content: $("#modal")//打开的内容
                        });
                        $("#id").val(ids[0]);
                        $("#name").val($($(".one")[i]).next().val());
                        $("#productTypeId").val($($(".one")[i]).next().next().val());
                        $("#brandId").val($($(".one")[i]).next().next().next().val());
                        $("#count").val($($(".one")[i]).next().next().next().next().val());
                        $("#marketPrice").val($($(".one")[i]).next().next().next().next().next().val());
                        $("#price").val($($(".one")[i]).next().next().next().next().next().next().val());
                        $("#image").val($($(".one")[i]).next().next().next().next().next().next().next().val());
                        $("#description").val($($(".one")[i]).next().next().next().next().next().next().next().next().val());
                        $("#userId").val($($(".one")[i]).prev().prev().prev().prev().val())
                        $("#img").attr("src", qiniu + $("#image").val());
                        $("#submit").css("display", "inline-block");
                        $("#img").css("display", "inline-block");
                    }
                }
            }
        })
        for (var i = 0; i < $(".img").length; i++) {
            var re = $($(".img")[i])
            re.attr("src", qiniu + re.attr("src") + "?_=" + Math.random());

        }
        $("#user").click(function () {
            if (ids.length != 1) {
                layer.msg("请选择一件商品", {
                    time: 1200
                })
            } else {
                axios({
                    url: "/admin/product/user",
                    method: "post",
                    data: ids,
                }).then(resp => {
                    layer.open({
                        type: 1,//类型
                        area: ['300px', '302px'],//定义宽和高
                        title: '<span style="font-family:黑体">货物提供者</span> <span class="layui-icon layui-icon-about">',//题目
                        shadeClose: true,//点击遮罩层关闭
                        move: false,
                        fixed: false,
                        closeBtn: 0,
                        anim: 1,
                        shade: 0.6,
                        content: "<div class='layui-collapse'>" +
                            "<div class='layui-colla-item'>" +
                            "<h2 class='layui-colla-title'>用户名</h2>" +
                            "<div class='layui-colla-content layui-show'>" + resp.data.data.userName + "</div>" +
                            "</div>" +
                            "<div class='layui-colla-item'>" +
                            "<h2 class='layui-colla-title'>联系电话</h2>" +
                            "<div class='layui-colla-content layui-show'>" + (resp.data.data.phone==''?'无':resp.data.data.phone) + "</div>" +
                            "</div>" +
                            "<div class='layui-colla-item'>" +
                            "<h2 class='layui-colla-title'>联系邮箱</h2>" +
                            "<div class='layui-colla-content layui-show'>" + resp.data.data.email + "</div>" +
                            "</div>" +
                            "</div>"
                    });
                })
            }
        })
        $("#onsale").click(function () {
            if (ids.length == 0) {
                layer.msg("请选择要上架的商品", {
                    time: 1200
                })
            } else {
                for (var i = 0; i < indexs.length; i++) {
                    var x = indexs[i];
                    if ($($(".one")[x - 1]).prev().prev().val() != "0") {
                        layer.msg("不能上架已上架或已失效的商品", {
                            time: 1200
                        })
                        return;
                    }
                }
                var index = layer.load();
                axios({
                    url: "/admin/product/onsale",
                    method: "put",
                    data: ids,
                    timeout: 30000,
                }).then(resp => {
                    if (resp.data.code === 1) {
                        var pageNo = $('#pageNo').val();
                        window.location.href = "/admin/main/product?page=" + pageNo + "&limit=6";
                    } else {
                        layer.msg("上架失败:"+resp.data.msg);
                        layer.close(index);
                    }
                }).catch(resp => {
                    layer.msg("上架失败")
                    layer.close(index);
                })
            }
        })
        $("#offsale").click(function () {
            if (ids.length == 0) {
                layer.msg("请选择要下架的商品", {
                    time: 1200
                })
            } else {
                for (var i = 0; i < indexs.length; i++) {
                    var x = indexs[i];
                    if ($($(".one")[x - 1]).prev().prev().val()!= "1") {
                        layer.msg("不能下架已下架或失效的商品", {
                            time: 1200
                        })
                        return;
                    }
                }
                var index = layer.load();
                axios({
                    url: "/admin/product/offsale",
                    method: "put",
                    data: ids,
                    timeout: 15000,
                }).then(resp => {
                    if (resp.data.code === 1) {
                        var pageNo = $('#pageNo').val();
                        window.location.href = "/admin/main/product?page=" + pageNo + "&limit=6";
                    } else {
                        layer.msg("下架失败")
                        layer.close(index);
                    }
                }).catch(resp => {
                    layer.msg("下架失败")
                    layer.close(index);
                })
            }
        })
    });
    layui.use('laypage', function () {
        var laypage = layui.laypage;
        laypage.render({
            elem: 'page',
            count: $("#totalCount").val(),
            limit: 6,
            curr: $("#pageNo").val(),
            jump: function (obj, first) {
                if (!first) {
                    window.location.href = "/admin/product/productPage?page=" + obj.curr + "&limit=" + obj.limit;
                }
            }
        });
    });
</script>
</html>