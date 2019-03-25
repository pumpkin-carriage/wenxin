<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/13
  Time: 14:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>网站公告</title>
    <link rel="stylesheet" href="../../../static/layui/css/layui.css"/>
    <script type="text/javascript" src="../../../static/js/jquery.min.js"></script>
    <script src="../../../static/layui/layui.js"></script>
    <script src="../../../static/js/vue.js"></script>
    <script src="../../../static/js/axios.min.js"></script>
    <script src="../../../static/js/dateformat.js"></script>
</head>
<body>
<div id="app" style="padding: 20px; background-color: #F2F2F2;">
    <h3 style="width: 100%;text-align: center;font-size: 35px">网站公告</h3>
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md16">
            <div class="layui-card">
                <div class="layui-card-header">
                    <div class="layui-btn-group">
                        <button id="add" @click="add" class="layui-btn">增加</button>
                        <button id="del" @click="del" class="layui-btn layui-bg-red">删除</button>
                    </div>
                </div>
                <div class="layui-card-body">
                    <table class="layui-table">
                        <tr class="layui-tab-title" @mouseover="yy">
                            <th style="width: 30px"><input type="checkbox" @change="all" id="all"/>全选</th>
                            <th style="text-align: center;width: 50px">序号</th>
                            <th style="text-align: center;">标题</th>
                            <th style="text-align: center;">内容</th>
                            <th style="text-align: center;">发布时间</th>
                        </tr>
                        <tr v-for="(bulletin,index) in bulletinList" style="text-align: center" @mouseover="xx">
                            <td style="text-align: left"><input type="checkbox" @change="one" class="one"/><input
                                    type="hidden" :value="bulletin.id"/></td>
                            <td>{{index+1}}</td>
                            <td>{{bulletin.title}}</td>
                            <td>{{bulletin.content}}</td>
                            <td class="date" style="width: 80px">{{bulletin.viewTime}}</td>
                        </tr>
                    </table>
                    <div id="page"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="modal" style="display: none;font-size: 15px">
        <div class="layui-form-item">
            <label class="layui-form-label">公告标题</label>
            <div class="layui-input-block">
                <input type="text" maxlength="15" id="title" style="width: 350px" lay-verify="required"
                       placeholder="请输入标题"
                       autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">公告内容</label>
            <div class="layui-input-block">
                <textarea maxlength="80" id="desc" style="width: 350px" placeholder="请输入内容"
                          class="layui-textarea"></textarea>
            </div>
        </div>
        <div>
            <button class="layui-btn layui-btn-fluid" @click="saveBulletin">添加公告</button>
        </div>
    </div>
</div>
</body>
<script>
    $(function () {
        $("tr").attr("bgColor", "cc0085").css("color", "white");
        $($("tr")[0]).attr("bgColor", "green").css("color", "white");
        var open;
        layui.use('layer', function () {
            var layer = layui.layer;
        });
        var vue = new Vue({
            el: "#app",
            data: {
                bulletinList: [],
                totalCount: 0,
                page: 1,
                limit: 6,
                ids: [],
            },
            methods: {
                yy: function (e) {
                    $(e.currentTarget).css("backgroundColor", "green");
                },
                xx: function (e) {
                    $(e.currentTarget).css("backgroundColor", "cc0085");
                },
                all(e) {
                    vue.ids = [];
                    if ($(e.target).prop("checked") == true) {
                        $(".one").prop("checked", true)
                        for (var i = 0; i < $(".one").length; i++) {
                            vue.ids.push($($(".one")[i]).next().val())
                        }
                    } else {
                        $(".one").prop("checked", false)
                    }
                },
                one(e) {
                    var v = $(e.target).next().val()
                    if ($(e.target).prop("checked") == true) {
                        vue.ids.push(v);
                    } else {
                        var index = vue.ids.indexOf(v);
                        vue.ids.splice(index, 1);
                    }
                    if (vue.ids.length == $(".one").length) {
                        $("#all").prop("checked", true)
                    } else {
                        $("#all").prop("checked", false)
                    }
                },
                saveBulletin() {
                    var t = $("#title").val();
                    var d = $("#desc").val();
                    var form = new FormData();
                    form.set("title", t);
                    form.set("content", d);
                    if (t == "" || d == "") {
                        layer.alert("标题和内容缺一不可");
                    } else {
                        axios({
                            url: "/admin/bulletin",
                            method: "post",
                            data: form
                        }).then(resp => {
                            layer.msg("添加成功");
                            a(vue.page, vue.limit);
                            layer.close(open);
                        })
                    }
                },
                add() {
                    open = layer.open({
                        type: 1,
                        anim: 2,
                        title: "添加公告",
                        area: ['500px', '250px'],
                        shade: 0,
                        shadeClose: false,
                        content: $('#modal')
                    });
                    $("#title").val("")
                    $("#desc").val("")
                },
                del() {
                    if (vue.ids.length == 0) {
                        layer.msg("请选择要删除的公告", {
                            icon: 2,
                            time: 1000,
                        })
                    } else {
                        axios({
                            url: "/admin/bulletin",
                            method: "delete",
                            data: vue.ids,
                        }).then(resp => {
                            $(".one").prop("checked", false)
                            $("#all").prop("checked", false)
                            a(vue.page, vue.limit);
                            vue.ids = [];
                        })
                    }
                },
            }
        })

        function a(page, limit) {
            $.ajax({
                url: "/admin/bulletin",
                async: false,
                type: "get",
                data: {
                    page: page,
                    limit: limit,
                },
                success: function (resp) {
                    vue.bulletinList = resp.data.data;
                    vue.totalCount = resp.data.totalCount;
                    vue.page = resp.data.pageNo;
                    layui.use('laypage', function () {
                        var laypage = layui.laypage;
                        laypage.render({
                            elem: 'page',
                            count: vue.totalCount,
                            limit: vue.limit,
                            curr: vue.page,
                            hash: true,
                            jump: function (obj, first) {
                                if (!first) {
                                    a(obj.curr, obj.limit);
                                }
                            }
                        });
                    });
                }
            });
        }

        a(vue.page, vue.limit);
    })
</script>
</html>
