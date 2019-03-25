<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/4
  Time: 13:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<HEAD>
    <TITLE> ZTREE DEMO - beforeEditName / beforeRemove / onRemove / beforeRename / onRename</TITLE>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="../../../static/zTree/css/demo.css" type="text/css">
    <link rel="stylesheet" href="../../../static/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <link rel="stylesheet" href="../../../static/layui/css/layui.css" type="text/css">
    <script type="text/javascript" src="../../../static/zTree/js/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="../../../static/zTree/js/jquery.ztree.core.js"></script>
    <script type="text/javascript" src="../../../static/zTree/js/jquery.ztree.excheck.js"></script>
    <script type="text/javascript" src="../../../static/zTree/js/jquery.ztree.exedit.js"></script>
    <script type="text/javascript" src="../../../static/layui/layui.js"></script>
    <script type="text/javascript" src="../../../static/js/axios.min.js"></script>
    <SCRIPT type="text/javascript">
        layui.use('layer', function(){
            var layer = layui.layer;
        });
        var productTypeList=[];
        $.ajax({
            url:"/admin/productType/getZtreeList",
            async:false,
            type:"get",
            success:function (resp) {
                productTypeList=resp.data;
            }
        })
        var setting = {
            view: {
                dblClickExpand: false
            },
            callback: {
                onRightClick: OnRightClick,
            }
        };
        var zNodes =productTypeList;
        function OnRightClick(event, treeId, treeNode) {
            if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) {
                zTree.cancelSelectedNode();
                showRMenu("root", event.clientX, event.clientY);
            } else if (treeNode && !treeNode.noR) {
                zTree.selectNode(treeNode);
                showRMenu("node", event.clientX, event.clientY);
            }
        }
        function showRMenu(type, x, y) {
            $("#rMenu ul").show();
            y += document.body.scrollTop;
            x += document.body.scrollLeft;
            rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});
            $("body").bind("mousedown", onBodyMouseDown);
        }
        function hideRMenu() {
            if (rMenu) rMenu.css({"visibility": "hidden"});
            $("body").unbind("mousedown", onBodyMouseDown);
        }
        function onBodyMouseDown(event){
            if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
                rMenu.css({"visibility" : "hidden"});
            }
        }
        var addCount = 1;
        function addTreeNode() {
            hideRMenu();
            var result=zTree.getSelectedNodes()[0]
            $("#content").css("display","block");
            $("#id").val("");
            $("#pid").val(result.id);
            $("#name").val("")
        }
        function  updateTreeNode() {
            hideRMenu();
            var result=zTree.getSelectedNodes()[0]
            $("#content").css("display","block");
            $("#id").val(result.id);
            $("#pid").val(result.pId);
            $("#name").val(result.name)
        }
        function removeTreeNode() {
            hideRMenu();
            var nodes = zTree.getSelectedNodes();
            if (nodes && nodes.length>0) {
                if (nodes[0].children && nodes[0].children.length > 0) {
                    var msg = "选择的是父节点，不能删除";
                    layer.tips(msg, '#treeDemo');
                } else {
                    layer.confirm('确认删除?', {icon: 5, title:'提示'}, function(index){
                      $.ajax({
                          url:"/admin/productType/deleteById",
                          data:{
                              id:nodes[0].id,
                          },
                          success:function (resp) {
                              zTree.removeNode(nodes[0]);
                          }
                      })
                        layer.close(index);
                    });
                }
            }
        }
        var zTree, rMenu;
        $(document).ready(function(){
            $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            zTree = $.fn.zTree.getZTreeObj("treeDemo");
            rMenu = $("#rMenu");
            $("#submit").click(function () {
                var id =$("#id").val();
                var pid =$("#pid").val();
                var name=$("#name").val();
                var description=$("#description").val();
                if (name==""){
                    layer.alert("请填写类型名称",{icon:2})
                } else{
                    axios({
                        url:"/admin/productType/checkName",
                        method:"put",
                        data:name,
                    }).then(resp=>{
                        if(resp.data.code===0){
                            layer.alert("换个类型名吧");
                        }
                        else{
                            axios({
                                url:"/admin/productType/addOrupdate",
                                method:"post",
                                data:{
                                    id:$("#id").val(),
                                    pid:$("#pid").val(),
                                    name:$("#name").val(),
                                    description:$("#description").val(),
                                },
                            }).then(resp=>{
                                zNodes=resp.data.data;
                                $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                                layer.msg("成功",{
                                    icon:1,
                                    time:1000,
                                });
                                $("#name").val("");
                                $("#description").val("");
                            });
                        }
                    })
                }
            });
        });
    </SCRIPT>
    <style type="text/css">
        div#rMenu {position:absolute; visibility:hidden; top:0; background-color:blue;text-align: left;padding: 2px;}
        div#rMenu ul li{
            margin: 1px 0;
            padding: 0 5px;
            cursor: pointer;
            list-style: none outside none;
            background-color:whitesmoke;
        }
    </style>
</HEAD>

<BODY style="background: whitesmoke">

<div class="content_wrap">
    <h4 style="color: red;">注：若要添加根节点，请先刷新页面</h4>
        <ul id="treeDemo" class="ztree"></ul>
</div>
<div id="rMenu">
    <ul>
        <li id="m_add" onclick="addTreeNode();">增加节点</li>
        <li id="m_mod" onclick="updateTreeNode();">编辑节点</li>
        <li id="m_del" onclick="removeTreeNode();">删除节点</li>
    </ul>
</div>
<div id="content" class="layui-card" style="text-align:center;display: none;width:400px;height: 370px;position: absolute;top: 30px;left: 250px">
    <div class="layui-card-body">
        <input type="hidden" id="id"/><br>
        <input type="hidden" id="pid"/><br>
        <label class="layui-form-label">类型名称</label>
        <div class="layui-input-block">
            <input type="text" id="name" required  lay-verify="required" placeholder="请输入类型名称" autocomplete="off" class="layui-input">
        </div><br>
        <label class="layui-form-label">描述信息</label>
        <div class="layui-input-block">
            <input type="text" id="description"  placeholder="请输入描述信息" autocomplete="off" class="layui-input">
        </div><br>
        <button id="submit" class="layui-btn layui-btn-normal">提交</button>
    </div>
</div>
</BODY>
</HTML>