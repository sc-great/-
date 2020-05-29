<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ include file="/common/common_taglib.jsp" %>
<%@ include file="/common/common_css.jsp" %>
<%@ include file="/common/common_js.jsp" %>
<!DOCTYPE html>
<html class="iframe-h">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no"/>
    <title></title>
    <link rel="stylesheet" type="text/css" href="${path }/css/list.css"/>
    <link rel="stylesheet" type="text/css" href="${path }/css/admin.css"/>
</head>
<body>
<div class="serch-bar">
    <div class="search-input">
        数据值名称：
        <div class="layui-inline layui-search-only-input">
            <input name="dvName" class="layui-input" id="dvName"
                   autocomplete="off">
        </div>
        <button class="layui-btn layui-btn-orange layui-btn-search" data-type="reload">搜索</button>
    </div>
    <span class="layui-toolbar">
			<button class="layui-btn layui-btn-primary layui-btn-tool-add" data-type="add"><div
                    class="layui-btn-toolbar-add"></div>添加</button>
			<button class="layui-btn layui-btn-primary layui-btn-tool-add" data-type="normal"><div
                    class="layui-btn-toolbar-up"></div>启用</button>
			<button class="layui-btn layui-btn-primary layui-btn-tool-add" data-type="unuse"><div
                    class="layui-btn-toolbar-stop"></div>停用</button>
        <!-- <button class="layui-btn layui-btn-primary layui-btn-tool-add" data-type="delALL"><div class="layui-btn-toolbar-del"></div>删除</button> -->
		</span>
</div>

<table id="dic" lay-filter="dicList"></table>
<script id="toolBar" type="text/html">
    <a class="layui-btn layui-btn-primary layui-btn-tool-check" lay-event="detail">查看</a>
    <a class="layui-btn layui-btn-primary layui-btn-tool-edit" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-primary layui-btn-tool-del" lay-event="del">删除</a>
</script>
<script type="text/html" id="status">
    {{ statusFormat(d.status) }}
</script>
<script src="${path}/plugin/layui/layui.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    var initId;
    var dicId;
    layui.use(['table', 'laydate', 'form', 'jquery'], function () {
        var table = layui.table;
        var form = layui.form;
        var $ = layui.jquery;
        var currpage = $('.layui-laypage-skip').children('.layui-input').val();
        //表格数据初始化
        initId = window.parent.initId;
        dicId = window.parent.initId;
        table.render({
            elem: '#dic',
            height: 'full-120',
            url: '${path}/dic/getDicValuePage.do',
            where: {dicId: initId},
            cellMinWidth: 80,
            cols: [[ //标题栏
                {
                    type: 'checkbox',
                    LAY_CHECKED: false
                }, {
                    field: 'dvOrder',
                    title: '排序编号'
                }, {
                    field: 'dvName',
                    title: '数据值名称'

                }, {
                    field: 'dvValue',
                    title: '数据项编码',
                    width: 400
                }, {
                    field: 'status',
                    title: '状态',
                    templet: "#status"
                }, {
                    fixed: 'right',
                    title: '操作',
                    toolbar: '#toolBar',
                    width: 270
                }]],
            skin: 'line', //line row表格风格
            even: true, //,size: 'lg' //尺寸
            page: true, //是否显示分页,
            limits: [10, 15],
            limit: 10
        });
        //监听工具条
        table.on('tool(dicList)', function (obj) {
            var data = obj.data;
            if (obj.event === 'detail') {
                top.layer.open({
                    type: 2,
                    title: '数据值信息查看',
                    area: ['700px', '500px'],
                    fixed: false, //不固定
                    maxmin: false,
                    shade: [0.3],
                    anim: 5,
                    isOutAnim: true,
                    resize: false,
                    content: '${path}/jsp/dictionary/dicValue_display.jsp?dvId=' + data.dvId,
                    end: function () {
// 							active.reload();
                    }
                });
            } else if (obj.event === 'edit') {
                top.layer.open({
                    type: 2,
                    title: '数据值信息修改',
                    area: ['700px', '500px'],
                    fixed: false, //不固定
                    maxmin: false,
                    shade: [0.3],
                    anim: 5,
                    isOutAnim: true,
                    resize: false,
                    content: '${path}/jsp/dictionary/dicValue_update.jsp?dvId=' + data.dvId,
                    end: function () {
                        table.reload('dic', {page: {curr: currpage}});
                    }
                });
            } else if (obj.event === 'del') {
                let id = [data.dvId];
                //console.log(id);
                top.layer.confirm('确定要删除选中的数据吗？', {
                    btn: ['确定', '取消']
                }, function () {
                    var actionUrl = "${path}/dic/delDicValue.do";
                    var params = {
                        ids: id
                    };
                    $.post(actionUrl, params, function (data) {
                        if (data.success) {
                            top.layer.alert('删除成功！！');
                            active.reload();
                        } else {
                            top.layer.alert('删除失败！！' + data.msg);
                            return;
                        }
                    });
                });

            }
        });
        var $ = layui.jquery,
            active = {
                add: function () {
                    top.layer.open({
                        type: 2,
                        title: '数据项添加',
                        area: ['700px', '500px'],
                        fixed: false, //不固定
                        maxmin: false,
                        shade: [0.3],
                        anim: 5,
                        isOutAnim: true,
                        resize: false,
                        content: '${path}/jsp/dictionary/dicValue_add.jsp?dicId=' + dicId,
                        success: function () {
                            $(':focus').blur();
                        },
                        end: function () {
                            active.reload();
                        }
                    });
                },
                delALL: function () {
                    var ids = active.getCheckData();
                    if (ids.length == 0) {
                        top.layer.alert('请选择需要删除的数据！！');
                    } else {
                        top.layer.confirm('确定要删除选中的所有数据吗？', {
                            btn: ['确定', '取消']
                        }, function () {
                            var actionUrl = "${path}/dic/delDicValue.do";
                            var params = {
                                ids: ids
                            };
                            $.post(actionUrl, params, function (data) {
                                if (data.success) {
                                    top.layer.alert('删除成功！！');
                                    active.reload();
                                } else {
                                    top.layer.alert('删除失败！' + data.msg);
                                    return;
                                }
                            });
                        });
                    }
                },
                //刷新表格数据重新请求
                reload: function () {
                    //执行重载
                    table.reload('dic', {
                        page: {
                            curr: 1
                        },
                        //查询条件参数
                        where: {
                            dvName: $("#dvName").val()
                        }
                    });
                },
                normal: function () {
                    var ids = active.getCheckData();
                    if (ids.length == 0) {
                        top.layer.alert('请选择需要启用的数据项！！');
                    } else {
                        top.layer.confirm('确定要启用选中的数据项吗？', {
                            btn: ['确定', '取消']
                        }, function () {
                            var actionUrl = "${path}/dic/changeDicValueStatus.do";
                            var params = {
                                ids: ids,
                                status: 0
                            };
                            $.post(actionUrl, params, function (data) {
                                if (data.success) {
                                    top.layer.alert('启用成功！！');
                                    active.reload();
                                } else {
                                    top.layer.alert('启用失败！！');
                                    return;
                                }
                            });
                        });
                    }
                },
                //设置用户状态停用
                unuse: function () {
                    var ids = active.getCheckData();
                    if (ids.length == 0) {
                        top.layer.alert('请选择需要停用的数据项！！');
                    } else {
                        top.layer.confirm('确定要停用选中的数据项吗？', {
                            btn: ['确定', '取消']
                        }, function () {
                            var actionUrl = "${path}/dic/changeDicValueStatus.do";
                            var params = {
                                ids: ids,
                                status: 1
                            };
                            $.post(actionUrl, params, function (data) {
                                if (data.success) {
                                    top.layer.alert('停用成功！！');
                                    active.reload();
                                } else {
                                    top.layer.alert('停用失败！！');
                                    return;
                                }
                            });
                        });
                    }
                },
                //获取被选中的表格数据ID集合
                getCheckData: function () {
                    var data = table.checkStatus('dic').data;
                    var ids = [];
                    for (var i = 0; i < data.length; i++) {
                        ids.push(data[i].dvId);
                    }
                    return ids;
                }
            };
        $('i').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
// 			$('#dvName').on('click', function() {
// 				active.reload();
// 			});
        $('.layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        window.reload = function (id) {
            $("#dvName").val("");
            table.reload('dic', {
                page: {
                    curr: 1
                },
                where: {
                    dvName: $("#dvName").val(),
                    dicId: id
                }
            });
            dicId = id;
        }
    });

    //状态格式化方法
    function statusFormat(value) {
        return value == "0" ? "启用" : "停用";
    }


</script>
</body>
</html>