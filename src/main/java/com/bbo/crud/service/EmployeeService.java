package com.bbo.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bbo.crud.bean.Employee;
import com.bbo.crud.bean.EmployeeExample;
import com.bbo.crud.bean.EmployeeExample.Criteria;
import com.bbo.crud.dao.EmployeeMapper;


@Service
public class EmployeeService {
	
	@Autowired
	EmployeeMapper employeeMapper;
	/**
	 * 获取所有雇员信息
	 * @return
	 */
	public List<Employee> getAll() {
		
		return employeeMapper.selectByExampleWithDept(null);
	}
	/**
	 * 保存雇员
	 * @param employee
	 */
	public void saveEmp(Employee employee) {
		employeeMapper.insertSelective(employee);
	}
	/**
	 * 校验用户名可用性
	 * @param empName
	 * @return true:当前雇员姓名可用 false:雇员姓名不可用
	 */
	public boolean checkUser(String empName) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		employeeMapper.countByExample(example);
		return count==0;
		
	}
	/**
	 * 查询雇员信息
	 * @param id
	 * @return
	 */
	public Employee getEmp(Integer id) {
		Employee employee =  employeeMapper.selectByPrimaryKey(id);
		return employee;
	}
	/**
	 * 修改雇员信息
	 * @param employee
	 */
	public void updateEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);
		
	}
	/**
	 * 删除雇员
	 * @param id
	 */
	public void deleteEmp(Integer id) {
		employeeMapper.deleteByPrimaryKey(id);
	}
	/**
	 * 批量删除
	 * @param str_ids
	 */
	public void deleteBatch(List<Integer> ids) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(ids);
		
		employeeMapper.deleteByExample(example);
	}

}
