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
			<div class="col-md-2 col-md-offset-10">
				<button type="button" class="btn btn-success" id="addBtn">新增</button>
				<button type="button" class="btn btn-danger" id="emp_delete_all">删除选中</button>
			</div>
		</div>
		
		
		<!-- 新增/修改 雇员 -->
		<div class="modal fade" id="empModal" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel"></h4>
					</div>
					<div class="modal-body">
						<form class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label">雇员姓名</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" id="inputEmpName"
										name="empName" placeholder="empName">
									<span  class="help-block"></span>	
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">性别</label>
								<div class="col-sm-10">
									<label class="radio-inline"> <input type="radio"
										name="gender" id="gender1_radio" value="M"> 男
									</label> <label class="radio-inline"> <input type="radio"
										name="gender" id="gender2_radio" value="F"> 女
									</label>

								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">邮箱</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" id="inputEmail" name=""
										placeholder="example@bbo.com">
									<span  class="help-block"></span>	
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">所属部门</label>
								<div class="col-sm-4">
								<!-- 提交部门id -->
									<select class="form-control" name="deptId" id="dept_select">
									
									</select>
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 数据表格 -->
		<div class="row" style="margin-top: 20px;">
			<div class="col-md-12">
				<table class="table table-striped" id="emps_Table">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all"  >
							</th>
							<th>#</th>
							<th>姓名</th>
							<th>性别</th>
							<th>邮箱</th>
							<th>所属部门</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>

					</tbody>

				</table>
			</div>
		</div>
		<!--  分页工具栏-->
		<div class="row">
			<!-- 文字信息 -->
			<div class="col-md-6" id="page_info_area"></div>
			<!-- 分页条 -->
			<div class="col-md-5 col-md-offset-1" id="page_nav_area"></div>

		</div>
	</div>
	<!--  引入jQuery -->
	<script src="${APP_PATH}/static/js/jquery-3.5.1.min.js"></script>
	<script src="${APP_PATH}/static/bootstrap/js/bootstrap.min.js"></script>
	<script src="${APP_PATH}/static/bootstrap-table/bootstrap-table.min.js"></script>

	<script type="text/javascript">
		
		var totalRecord ;//总记录数
		var currentPage ;//当前页码
		//页面加载完成以后，直接发送以个ajax请求并获取分页数据
		$(function() {
			to_page(1);
		});
		//解析表格数据
		function build_emps_table(result) {
			//清空表格数据
			$("#emps_Table tbody").empty();

			var emps = result.extend.pageInfo.list;
			//遍历
			$.each(emps, function(index, item) {
				var checkBoxTd = $("<td><input type='checkBox' class='check_item'  /></td>");
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(
						item.gender == 'M' ? "男" : "女");
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>")
						.append(item.department.deptName);
				var editBtn = $("<button ></button>").addClass(
						"btn btn-default btn-sm editBtn").append(
						$("<span></span>").addClass(
								"glyphicon glyphicon-pencil")).append("编辑");
				//为编辑按钮添加自定义属性标识按钮选中列雇员记录id
				editBtn.attr("edit-id",item.empId);
				
				var delBtn = $("<button></button>").addClass(
						"btn btn-default btn-sm delBtn").append(
						$("<span></span>")
								.addClass("glyphicon glyphicon-trash")).append(
						"删除");
				//为删除按钮添加自定义属性，标识当前选中记录的雇员id
				delBtn.attr("del-id",item.empId);
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(
						delBtn);
				$("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd).append(
						genderTd).append(emailTd).append(deptNameTd).append(
						btnTd).appendTo("#emps_Table tbody");
			});
		}
		//分页信息
		function build_page_info(result) {
			$("#page_info_area").empty();
			$("#page_info_area").append(
					"当前" + result.extend.pageInfo.pageNum + "页，总"
							+ result.extend.pageInfo.pages + "页，总"
							+ result.extend.pageInfo.total + "条记录；");
			totalRecord = result.extend.pageInfo.total;//由全局变量保存总记录数
		}
		//分页条
		function build_page_nav(result) {
			$("#page_nav_area").empty();

			var ul = $("<ul></ul").addClass("pagination");
			//构建上(下)一页、首(末)页元素
			var firstPageLi = $("<li></li>").append(
					$("<a></a>").append("首页").attr("href", "#"));
			var prePageLi = $("<li></li>").append(
					$("<a></a>").append("&laquo;"));
			if (result.extend.pageInfo.hasPreviousPage == false) {
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			} else {
				//绑定点击事件
				firstPageLi.click(function() {
					to_page(1);
				});
				prePageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum - 1);
				});
			}

			var nextPageLi = $("<li></li>").append(
					$("<a></a>").append("&raquo;"));
			var lastPageLi = $("<li></li>").append(
					$("<a></a>").append("末页").attr("href", "#"));
			if (result.extend.pageInfo.hasNextPage == false) {
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			} else {
				lastPageLi.click(function() {
					to_page(result.extend.pageInfo.pages);
				});
				nextPageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum + 1);
				});
			}

			ul.append(firstPageLi).append(prePageLi);

			$.each(result.extend.pageInfo.navigatepageNums, function(index,
					item) {
				var numLi = $("<li></li>").append($("<a onselectstart='return false;' ></a>").append(item));
				//为当前页码添加激活状态
				if (result.extend.pageInfo.pageNum == item) {
					numLi.addClass("active");
				}
				numLi.click(function() {//绑定页码跳转事件
					to_page(item);
				});
				ul.append(numLi);
			});
			ul.append(nextPageLi).append(lastPageLi);

			var navElem = $("<nav></nav>").append(ul);
			navElem.appendTo($("#page_nav_area"));
		}
		//页面跳转
		function to_page(pn) {
			currentPage = pn;//保存当前页码
			$.ajax({
				url : "${APP_PATH}/emps",
				data : "pn=" + pn,
				type : "get",
				success : function(result) {
					//console.log("调试信息："+result);
					//解析并显示雇员数据
					build_emps_table(result);
					//解析并显示分页数据
					build_page_info(result);
					//解析分页条信息
					build_page_nav(result);
				}
			});
		}
		/******************/
		//重置表单
		function reset_form(ele) {
			$(ele)[0].reset();
			//重置表单样式
			$(ele).find("*").removeClass("has-error has-success");
			//重置提示文本
			$(ele).find(".help-block").text("");
		}
		
		//查询所有的部门信息并显示在下拉列表中
		function getDepts() {
			//重置部门下拉选项
			$("#dept_select").empty();
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result){
					$.each(result.extend.depts,function(){
						var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
						optionEle.appendTo($("#dept_select"));
					});
				}
			});
		}
		
		//表单数据校验方法
		function validate_form() {
			//获取表单数据：正则表达式
			//校验雇员姓名
			var empName = $("#inputEmpName").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]+$)/;//允许中文、大小写字母、下划线和短横、6~16位
			if(!regName.test(empName)){
				//alert("6~16位，数字和字母，下划线、短横组合或中文字符");
				//不正确
				show_validate_msg("#inputEmpName","error","6~16位，数字和字母，下划线、短横组合或中文字符");
				return false;
			}else{
				show_validate_msg("#inputEmpName","success","用户名可用");
			}
			//校验邮箱
			var email = $("#inputEmail").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				//alert("邮箱格式不正确");
				show_validate_msg("#inputEmail","error","邮箱格式不正确");
				return false;
			}else{
				show_validate_msg("#inputEmail","success","");
			}
			return true;
		}
		//校验结果文本显示
		function show_validate_msg(ele,status,msg) {
			//清除元素当前状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			
			if("success" == status){
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if("error" == status){
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		//雇员姓名输入框文本改变事件
		$("#inputEmpName").change(function() {
			var empName = this.value;
			//ajax发送输入框文本进行可用性校验
			$.ajax({
				url:"${APP_PATH}/checkUser",
				type:"POST",
				data:"empName="+empName,
				success:function(result){
					if(result.code==100){//成功
						show_validate_msg("#inputEmpName","success","用户名可用");
						//保存按钮增加自定义属性标识雇员姓名唯一性的验证结果
						$("#saveBtn").attr("ajax-va","success");
					}else{//不可用
						show_validate_msg("#inputEmpName","error",result.extend.va_msg);
						//失败标识
						$("#saveBtn").attr("ajax-va","error");
					}
				}
			});
		});
		//新增按钮事件
		$("#addBtn").click(function() {
			//重置表单
			reset_form("#empModal form");
			//发送ajax请求，查询部门信息并在下拉列表中显示
			getDepts();
			//修改模态框标题
			$(".modal-title").text("新增雇员");
			//移除编辑id属性
			$("#saveBtn").removeAttr("edit-id");
			//移除禁用属性
			$("#inputEmpName").removeAttr("disabled");
			//弹出模态框
			$("#empModal").modal({
				backdrop : "static"
			});
			
			
		});
		/*************/
		//保存按钮点击事件
		//saveBtn
		$("#saveBtn").click(function(id){
			var empId = $(this).attr("edit-id");//从保存按钮获取编辑标识
			//console.log(empId);
			
			
			if(empId == undefined ){//保存新增
				//校验表单数据(表单完整性)
				if(!validate_form()) return ;
				//验证雇员姓名输入框change事件的验证结果
				if($(this).attr("ajax-va") == "error") return ;
				//使用ajax发送模态框中表单数据(新增雇员)
				$.ajax({
					url:"${APP_PATH}/emp",
					type:"POST",
					data:$("#empModal form").serialize(),
					success:function(result){//雇员保存成功
						//alert(result.msg);
						//判断结果
						if(result.code == 100){
							//关闭模态框
							$("#empModal").modal("hide");
							//定位到最后一页
							to_page(totalRecord);
						}else{
							//显示错误信息
							//email错误
							if(result.extend.errorFields.email != undefined ){
								show_validate_msg("#inputEmail","error",result.extend.errorFields.email);
							}
							//empName错误
							if(result.extend.errorFields.empName != undefined){
								
								show_validate_msg("#inputEmpName","error",result.extend.errorFields.empName);
							}
						}
					}
				});
			}else{//保存编辑
				//校验邮箱
				var email = $("#inputEmail").val();
				var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
				if(!regEmail.test(email)){
					//alert("邮箱格式不正确");
					show_validate_msg("#inputEmail","error","邮箱格式不正确");
					return ;
				}else{
					show_validate_msg("#inputEmail","success","");
				}
				
				
				//雇员更新请求
				$.ajax({
					url:"${APP_PATH}/emp/"+empId,
					type:"PUT",
					data:$("#empModal form").serialize(),
					success:function(result){
						alert(result.msg);
						//关闭模态框
						$("#empModal").modal("hide");
						//跳转页面
						to_page(currentPage);
					}
				});
			}
		});
		
		/*********/
		/*修改业务*/
		//通过id查询雇员并回显
		function getEmp(id) {
			$.ajax({
				url:"${APP_PATH}/emp/"+id,
				type:"GET",
				success:function(result){
					//console.log(result);
					var empData = result.extend.emp;
					//console.log($("#inputEmpName"));
					//console.log($("#inputEmail"));
					$("#inputEmpName").val(empData.empName);
					$("input[name=gender]").val([empData.gender]);
					$("#inputEmail").val(empData.email);
					$("#dept_select").val([empData.deptId]);
				}
				
			});
		}
		//编辑按钮事件绑定
		$(document).on("click",".editBtn",function(){
			//重置表单
			reset_form("#empModal form");
			//修改模态框标题
			$(".modal-title").text("编辑雇员信息");
			getDepts();
			$("#empModal").find("#inputEmpName").attr("disabled","dsiabled");
			$("#empModal").modal({
				backdrop:"static"
			}).modal("show");
			
			//查询员工id
			getEmp($(this).attr("edit-id"));
			//给保存按钮传递所选记录的雇员id
			$("#saveBtn").attr("edit-id",$(this).attr("edit-id"));
		});
		/**********/
		/*删除业务*/
		//全选(全选复选框点击事件)
		$("#check_all").click(function(){
			//attr方法常用于获取自定义属性
			//使用prop获取(修改)标签原生属性
			$(".check_item").prop("checked",$(this).prop("checked"));
			
		});
		//实现页面记录复选框单个全选后自动勾选全选复选框
		$(document).on("click",".check_item",function(){
			//判断当前选中元素是否为5个
			let checkFlag = $(".check_item:checked").length == $(".check_item").length
			$("#check_all").prop("checked",checkFlag);
		});
		//(单个)删除雇员
		$(document).on("click",".delBtn",function(){
			//获取选中行雇员id
			let empId = $(this).attr("del-id");
			//弹出确认框
			let empName = $(this).parents("tr").find("td:eq(2)").text();
			if(confirm("您确认要删除【"+empName+"】吗？")){//确认
				//发送ajax请求
				$.ajax({
					url:"${APP_PATH}/emp/"+empId,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}else{//取消
				return ;
			}
		});
		//批量删除
		$("#emp_delete_all").click(function() {
			let empNames="";
			let del_idstr = "";
			$.each($(".check_item:checked"),function(){
				empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
				//组装员工id字串
				del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
			});
			empNames = empNames.substring(0,empNames.length-1);
			del_idstr = del_idstr.substring(0,del_idstr.length-1);
			if($(".check_item:checked").length <= 0){
				alert("无记录被选中");
				return ;
			}
			if(confirm("确认删除【"+empNames+"】这些雇员吗？")){
				//发送ajax请求
				$.ajax({
					url:"${APP_PATH}/emp/"+del_idstr,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
		});
		/*********/
	</script>
</body>
</html>