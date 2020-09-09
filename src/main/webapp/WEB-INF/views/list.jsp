<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>雇员列表</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());//返回以/开始，不以/结束
%>
<link href="${APP_PATH}/static/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">
<!-- 引入bootsrapTable -->
<link href="${APP_PATH}/static/bootstrap-table/bootstrap-table.min.css"
	rel="stylesheet">
</head>
<body>
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>雇员信息</h1>
			</div>
		</div>
		<!-- 操作工具栏 -->
		<div class="row">
			<div class="col-md-2 col-md-offset-10" >
				<button type="button" class="btn btn-success">新增</button>
				<button type="button" class="btn btn-danger">删除选中</button>
			</div>
		</div>
		<!-- 数据表格 -->
		<div class="row" style="margin-top: 20px;">
			<div class="col-md-12">
				<table data-toggle="table" class="table table-striped">
					<thead>
						<tr>
							<th>#</th>
							<th>姓名</th>
							<th>性别</th>
							<th>邮箱</th>
							<th>所属部门</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${pageInfo.list}" var="emp">
							<tr>
								<td>${emp.empId}</td>
								<td>${emp.empName}</td>
								<td>${emp.gender=="M"?"男":"女"}</td>
								<td>${emp.email}</td>
								<td>${emp.department.deptName}</td>
								<td>
									<button type="button" class="btn btn-default btn-sm"
										aria-label="Left Align">
										<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑
									</button>
									<button type="button" class="btn btn-default btn-sm"
										aria-label="Left Align">
										<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
									</button>
								</td>
							</tr>
						</c:forEach>


					</tbody>
				</table>
			</div>
		</div>
		<!--  分页工具栏-->
		<div class="row">
			<!-- 文字信息 -->
			<div class="col-md-6">
				当前${pageInfo.pageNum }页，总${pageInfo.pages }页，总${pageInfo.total }条记录；
			</div>
			<!-- 分页条 -->
			<div class="col-md-5 col-md-offset-1" >
				<nav aria-label="Page navigation" style="float: right;">
					<ul class="pagination">
						<li><a href="${APP_PATH}/emps?pn=1">头页</a></li>
						
						<c:if test="${pageInfo.hasPreviousPage }">
							<li><a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1 }" aria-label="Previous"> <span
									aria-hidden="true">&laquo;</span>
							</a></li>
						</c:if>
						<c:forEach items="${pageInfo.navigatepageNums }" var="page_Num">
							<c:if test="${page_Num == pageInfo.pageNum }">
								<li class="active"><a href="#">${page_Num }</a></li>
							</c:if>
							<c:if test="${page_Num != pageInfo.pageNum }">
								<li><a href="${APP_PATH}/emps?pn=${page_Num }">${page_Num }</a></li>
							</c:if>
						</c:forEach>
						<c:if test="${pageInfo.hasNextPage }">
							<li><a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1 }" aria-label="Next"> <span
								aria-hidden="true">&raquo;</span>
							</a></li>
						</c:if>
						
						<li><a href="${APP_PATH}/emps?pn=${pageInfo.pages } ">尾页</a></li>
					</ul>
				</nav>
			</div>
			
		</div>
	</div>
	<!--  引入jQuery -->
	<script src="${APP_PATH}/static/js/jquery-3.5.1.min.js"></script>
	<script src="${APP_PATH}/static/bootstrap/js/bootstrap.min.js"></script>
	<script src="${APP_PATH}/static/bootstrap-table/bootstrap-table.min.js"></script>
</body>
</html>