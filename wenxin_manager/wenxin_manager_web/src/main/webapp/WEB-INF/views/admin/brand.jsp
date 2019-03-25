<%--
  Created by IntelliJ IDEA.
  brand: Spring
  Date: 2019/2/4
  Time: 9:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>品牌管理</title>
    <link rel="stylesheet" type="text/css" href="../../../static/layui/css/layui.css"/>
    <script type="text/javascript" src="../../../static/js/vue.js"></script>
    <script type="text/javascript" src="../../../static/js/axios.min.js"></script>
    <script type="text/javascript" src="../../../static/layui/layui.js"></script>
    <script type="text/javascript" src="../../../static/js/jquery.min.js"></script>
    <script type="text/javascript" src="../../../static/js/dateformat.js"></script>
    <script type="text/javascript" src="../../../static/zTree/js/jquery.ztree.core.js"></script>
    <script type="text/javascript" src="../../../static/zTree/js/jquery.ztree.excheck.js"></script>
    <script type="text/javascript" src="../../../static/zTree/js/jquery.ztree.exedit.js"></script>
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
                    </div>
                </div>
                <div class="layui-card-body">
                    <table class="layui-table">
                        <tr class="layui-tab-title">
                            <th><input type="checkbox" id="all"/></th>
                            <th style="text-align: center;">序号</th>
                            <th style="text-align: center;">品牌名称</th>
                            <th style="text-align: center;">所属类型</th>
                            <th style="text-align: center;">创建时间</th>
                        </tr>
                        <tr class="layui-tab-content" v-for="(brand,index) in brandList" style="text-align: center">
                            <td style="text-align: left">
                                <input type="checkbox" class="one"/>
                                <input type="hidden" :value="brand.id"/>
                            </td>
                            <td>{{index+1}}</td>
                            <td>{{brand.name}}</td>
                            <td>
                                <span v-for="type in productTypeList">
                                     <span v-if="type.id==brand.productTypeId">
                                         {{type.name}}
                                     </span>
                                </span>

                            </td>
                            <td class="date">{{brand.createTime}}</td>
                        </tr>
                    </table>
                    <div id="page"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="editModal" style="display: none;overflow: hidden;">
        <form class="layui-form" action="/admin/brand/updateBrandForm" method="post">
            <div class="layui-form-item">
                <label class="layui-form-label">品牌名称</label>
                <div class="layui-input-block">
                    <input type="text" required id="name_e" name="name" autocomplete="off" class="layui-input"
                           style="width: 200px">
                </div>
                <br>
                <div class="content_wrap">
                    <label class="layui-form-label">所属类型</label>
                    <input type="hidden" id="modId" name="id"/>
                    <input type="hidden" id="productTypeId" name="productTypeId"/>
                    <input id="brandType" type="text" readonly class="layui-input"
                           style="width:200px;display: inline-block"/>
                    &nbsp;<a id="menuBtn" href="#" onclick="showMenu(); return false;">选择</a></li>
                    <div id="menuContent" class="menuContent" style="display:none;">
                        <ul id="treeDemo" class="ztree"
                            style="margin-top:0; margin-left: 110px;height: 300px;width:190px;"></ul>
                    </div>
                </div>
            </div>
            <button type="submit" class="layui-btn layui-btn-fluid" style="position: absolute;bottom: 0;">提交</button>
        </form>
    </div>
</div>
</body>
<script type="text/javascript">
    var vue = new Vue({
        el: "#app",
        data: {
            brandList: [],
            productTypeList: [],
            pageNo: '',
        },
    });
    layui.use('layer', function () {
        var layer = layui.layer;
    });
    layui.use('laypage', function () {
        var laypage = layui.laypage;
        //执行一个laypage实例
        laypage.render({
            elem: 'page',//注意，这里的 test1 是 ID，不用加 # 号
            count: totalCount, //数据总数，从服务端得到,
            limit: 6,
            jump: function (obj, first) {
                if (!first) {
                    pagnation(obj.curr, obj.limit);
                }
            }
        });
    });
    var page = 1;
    var limit = 6;
    var totalCount = 0;
    pagnation(page, limit);

    function pagnation(page, limit) {
        $.ajax({
            url: "/admin/brand/brandPage",
            type: "get",
            async: false,
            data: {
                page: page,
                limit: limit,
            },
            success: function (resp) {
                vue.brandList = resp.data;
                totalCount = resp.totalCount;
                vue.pageNo = resp.pageNo;
            }
        });
    }

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
        $("#brandType").attr("value", v);
        $("#productTypeId").val(treeNode.id);
        $("#treeDemo").hide()
    }

    function showMenu() {
        var cityObj = $("#brandType");
        var cityOffset = $("#brandType").offset();
        $("#menuContent").css({
            left: cityOffset.left + "px",
            top: cityOffset.top + cityObj.outerHeight() + "px"
        }).slideDown("fast");
        $("body").bind("mousedown", onBodyDown);
        $("#treeDemo").show()
    }

    function hideMenu() {
        $("#menuContent").fadeOut("fast");
        $("body").unbind("mousedown", onBodyDown);
    }

    function onBodyDown(event) {
        if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length > 0)) {
            hideMenu();
        }
    }

    $(function () {
        $("tr").attr("bgColor","cc0085").css("color","white").mouseover(function () {
            $(this).css("backgroundColor","cc0085")
        });
        $($("tr")[0]).attr("bgColor","green").css("color","white").mouseover(function () {
            $(this).css("backgroundColor","green")
        });
    $.fn.zTree.init($("#treeDemo"), setting, zNodes);
    $.ajax({
        url: "/admin/productType/getProductTypeList",
        type: "get",
        success: function (resp) {
            vue.productTypeList = resp.data;
        }
    })
    for (var i = 0; i < $(".date").length; i++) {
        $($(".date")[i]).html(Todate1(parseInt($($(".date")[i]).html())));
    }
    var ids = [];
    $("#all").change(function () {
        if ($(this).prop("checked") == true) {
            ids = [];
            for (var i = 0; i < $(".one").length; i++) {
                $($(".one")[i]).prop("checked", true)
                ids.push($($(".one")[i]).next().val())
            }
        } else {
            ids = [];
            for (var i = 0; i < $(".one").length; i++) {
                $($(".one")[i]).prop("checked", false)
            }
        }
    })
    $(".one").change(function () {
        if ($(this).prop("checked") == true) {
            ids.push($(this).next().val())
        } else {
            var v = $(this).next().val();
            var index = ids.indexOf(v);
            ids.splice(index, 1);
        }
        if (ids.length == $(".one").length) {
            $("#all").prop("checked", true)
        } else {
            $("#all").prop("checked", false)
        }
    })
    $("#add").click(function () {
        layer.open({
            type: 1,//类型
            area: ['400px', '497px'],//定义宽和高
            title: '添加品牌',//题目
            shadeClose: false,//点击遮罩层关闭
            content: $("#editModal")//打开的内容
        });
    });
    $("#del").click(function () {
        if (ids.length == 0) {
            layer.msg('请选择要删除的品牌', {
                time: 1000
            });
        } else {
            axios({
                url: "/admin/brand/delete",
                method: "delete",
                data: ids,
            }).then(resp => {
                if (resp.data.code === 1) {
                    window.location.href = "/admin/main/brand";
                }
            })
        }
    })
    $("#edit").click(function () {
        if (ids.length == 0) {
            layer.msg('请选择要编辑的品牌', {
                time: 1000
            });
        } else if (ids.length > 1) {
            layer.msg('选择的品牌过多', {
                time: 1000
            });
        } else {
            for (var i = 0; i < $(".one").length; i++) {
                if ($($(".one")[i]).next().val() == ids[0]) {
                    $("#name_e").val($($(".one")[i]).parent().next().next().html());
                }
            }
            layer.open({
                type: 1,//类型
                area: ['400px', '497px'],//定义宽和高
                title: '修改用户',//题目
                shadeClose: false,//点击遮罩层关闭
                content: $("#editModal")//打开的内容
            });
            $("#modId").val(ids[0]);
        }
    })
    })
</script>
</html>