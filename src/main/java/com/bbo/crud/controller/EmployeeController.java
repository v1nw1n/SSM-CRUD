package com.bbo.crud.controller;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bbo.crud.bean.Employee;
import com.bbo.crud.bean.Msg;
import com.bbo.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * 处理员工CRUD请求
 * 
 * @author vincent
 *
 */
@Controller
public class EmployeeController {
	@Autowired
	EmployeeService employeeService;
	
	@ResponseBody
	@RequestMapping("/fst/{allinfo}")
	public Msg fileSaverTest(@PathVariable("allinfo")String allinfo) {
		if(allinfo==null) 
			allinfo = "获取失败";
		else {
			allinfo = allinfo.replace("；", "\r\n");
		}
		File dir = new File("D://");
		File file = new File(dir,"info.txt");
		
		try {
			FileWriter fw = new FileWriter(file,true);
			BufferedWriter bw = new BufferedWriter(fw);
			bw.write(allinfo);
			bw.close();
			fw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return Msg.success();
	}
	
	/**
	 * 删除雇员(批量/单个)
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{empIds}",method=RequestMethod.DELETE)
	public Msg deleteEmpById(@PathVariable("empIds")String ids) {
		if(ids.contains("-")) {
			String[] str_ids = ids.split("-");
			List<Integer> del_ids = new ArrayList<>();
			for(String str :str_ids) {
				del_ids.add(Integer.parseInt(str));
			}
			employeeService.deleteBatch(del_ids);
		}else {
			Integer id =  Integer.parseInt(ids);
			employeeService.deleteEmp(id);
			
		}
		return Msg.success();
	}
	
	/**
	 * 更新雇员信息方法
	 * @param value
	 * @return
	 */
	@RequestMapping(value="emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg updateEmp(Employee employee) {
		/**
		 * 问题：
		 * 前台(更新雇员操作)通过PUT方法传递的数据中后端接口无法拿到对应的值，
		 * 导致封装失败，从而导致数据库异常
		 * 原因：
		 * tomcat将请求体中的数据封装到map对象中，
		 * request.getParamater("empName")方法从map对象中取值
		 * SpringMVC封装POJO(简单java对象)对象时，通过调用request.paramater()获取POJO中每个属性的值
 		 * 
		 * 对于PUT请求，request.getParamater()无法获取到请求体中的数据
		 * Tomcat也不会将请求体中的数据封装到map对象中，只有POST请求才会被封装
		 * 解决：
		 * org.springframework.web.filter.HttpPutFormContentFilter- HttpPutFormContentFilter
		 * 配置该过滤器
		 * 过滤器实现将请求体封装到自定义的一个继承于map的MultiValueMap对象实例中，并重写getParamater()方法：
		 * 除从原生的对象(原生的getParamater()方法)中获取数据，还从自定义的map对象中获取
		 */
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	/**
	 * 通过id查询指定雇员信息
	 * @return
	 */
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	/**
	 * 校验雇员新增用户名是否可用
	 * @param empName
	 * @return
	 */
	@RequestMapping("/checkUser")
	@ResponseBody
	public Msg checkUse(@RequestParam("empName")String empName) {
		//正则校验
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]+$)";
		if(!empName.matches(regx)) {
			return Msg.fail().add("va_msg", "6~16位，数字和字母，下划线、短横组合或中文字符");
		}
		//数据库唯一值校验
		boolean checkFlag = employeeService.checkUser(empName);
		if(checkFlag) {
			//可用
			return Msg.success();
		}else return Msg.fail().add("va_msg", "用户名已存在");
	}
	/**
	 * 保存雇员
	 * 支持JSR303校验
	 * 引入Hibernate-Validator
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee,BindingResult result) {
		if(result.hasErrors()) {//校验失败
			//在前端模态框中显示校验失败的消息
			Map<String, Object> map = new HashMap<>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError:errors) {
				System.out.println("错误的字段名:"+fieldError.getField());
				System.out.println("错误信息："+fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else {
			employeeService.saveEmp(employee);
			return Msg.success();
		}
		
	}
	/**
	 * 导入jackson包：将返回对象转换成json字串
	 * @param pn
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
		// 引入PageHelper分页插件
		// 调用插件相关方法startPage(页码，每页的的大小)
		PageHelper.startPage(pn, 5);
		List<Employee> emps = employeeService.getAll();// startPage紧跟的查询为分页查询
		// 用PageInfo对结果进行包装，并提交PageInfo至页面
		// 封装信息包括详细的分页属性和查询得到的数据，传入连续显示的页数
		PageInfo<Employee> page = new PageInfo<Employee>(emps, 5);
		return Msg.success().add("pageInfo",page);
	}

	/**
	 * 查询员工数据(分页查询)
	 * 
	 * @return
	 */
	// @RequestMapping("/emps")
	public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
		// 引入PageHelper分页插件
		// 调用插件相关方法startPage(页码，每页的的大小)
		PageHelper.startPage(pn, 5);
		List<Employee> emps = employeeService.getAll();// startPage紧跟的查询为分页查询
		// 用PageInfo对结果进行包装，并提交PageInfo至页面
		// 封装信息包括详细的分页属性和查询得到的数据，传入连续显示的页数
		PageInfo<Employee> page = new PageInfo<Employee>(emps, 5);
		model.addAttribute("pageInfo", page);
		return "list";
	}
	
	
	
}
