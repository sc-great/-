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
</head>
<body>
<form class="layui-form  layui-from-header" lay-filter="dicForm">
    <input type="hidden" value="${param.dicId}" name="dicId"/>
    <div class="layui-form-item">
        <label class="layui-form-label">数据项名称</label>
        <div class="layui-input-block">
            <input name="dicName" class="layui-input" type="text"
                   autocomplete="off" lay-verify="required" disabled="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">数据项编码</label>
        <div class="layui-input-block">
            <input name="dicCode" class="layui-input"
                   autocomplete="off" lay-verify="required" disabled="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">排序编号</label>
        <div class="layui-input-block">
            <input name="dicOrder" class="layui-input" type="text"
                   autocomplete="off" lay-verify="required" disabled="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">数据项说明</label>
        <div class="layui-input-block">
					<textarea class="layui-textarea" name="dicRemark" maxlength="1000"
                              placeholder=""></textarea>
        </div>
    </div>
</form>
<script src="${path }/plugin/layui/layui.js" type="text/javascript"
        charset="utf-8"></script>
<script type="text/javascript">
    layui.use(['layer', 'form', 'jquery'], function () {
        var form = layui.form;
        var $ = layui.jquery;

        $.post("${path}/dic/getDicById.do", {id: "${param.dicId}"}, function (data) {
            if (data.success) {
                form.val('dicForm', {
                    "dicName": data.job.dicName,
                    "dicCode": data.job.dicCode,
                    "dicOrder": data.job.dicOrder,
                    "dicRemark": data.job.dicRemark
                });
            } else {
                top.layer.alert('获取数据失败！！');
                return;
            }
        });
    });
</script>
</body>
</html>