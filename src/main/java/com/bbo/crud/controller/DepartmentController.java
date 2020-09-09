package com.bbo.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bbo.crud.bean.Department;
import com.bbo.crud.bean.Msg;
import com.bbo.crud.service.DepartmentService;



/**
 *  处理部门相关的请求
 * @author vincent
 *
 */
@Controller
public class DepartmentController {
	@Autowired
	private DepartmentService departmentService;
	/**
	 * 返回所有部门信息
	 */
	@RequestMapping("/depts")
	@ResponseBody
	public Msg getDepts() {
		//查询所有部门信息
		List<Department> list =  departmentService.getDepts();
		return Msg.success().add("depts", list);
	}
	

}
