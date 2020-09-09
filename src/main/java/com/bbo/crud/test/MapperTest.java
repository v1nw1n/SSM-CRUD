package com.bbo.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
/*import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;*/
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.bbo.crud.bean.Employee;
import com.bbo.crud.dao.DepartmentMapper;
import com.bbo.crud.dao.EmployeeMapper;

/**
 * 测试dao层的工作
 * 推荐Spring项目可以使用Spring的单元测试，可以自动注入我们需要的组件
 * @author vincent
 * 1、导入SpringTest模块
 * 2、@ContextConfiguration指定Spring配置文件的位置
 * 3、直接autowired要使用的组件即可
 */


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations= {"classpath:applicationContext.xml"})
public class MapperTest {
	@Autowired
	DepartmentMapper depatmentMapper;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
	SqlSession sqlSession;
	/*测试DepartmentMapper*/
	@Test
	public void testCRUD() {
		/*//创建SpringIOC容器
		ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
		//从容器中获取mapper
		DepatmentMapper bean = ioc.getBean(DepatmentMapper.class);*/
		System.out.println(depatmentMapper);
		
		//1、插入数据
		//depatmentMapper.insertSelective(new Department(null, "开发部"));
		//depatmentMapper.insertSelective(new Department(null, "采购部"));
		
		//2、生成雇员数据(插入数据
		/*employeeMapper.insertSelective(new Employee(null, "John", "M", "john@bbo.com", 1));
		employeeMapper.insertSelective(new Employee(null, "Lucy", "F", "lucy@bbo.com", 2));
		*/
		//3、批量插入：使用可以执行批量操作的sqlSession
		/*for(;;) {
			employeeMapper.insertSelective(new Employee(null, "Lucy", "F", "lucy@bbo.com", 2));
		}*/
		EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
		for(int i=0;i<500;i++) {
			String uid = UUID.randomUUID().toString().substring(0, 5) + i ;
			mapper.insertSelective(new Employee(null,
					uid,
					((int)(Math.random()*10+1)/2)==0?"M":"F",
					uid+"@bbo.com",
					(int)(Math.random()*3+1)));
		}
		System.out.println("批量插入完成");
	}
}
