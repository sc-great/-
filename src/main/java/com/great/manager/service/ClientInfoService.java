package com.great.manager.service;

import java.util.List;

import com.great.base.service.BaseService;
import com.great.manager.entity.BClient;
import com.great.tool.PageBean;

public interface ClientInfoService extends BaseService<BClient> {

	//分页查询
	public void getResult(PageBean pageBean);
	
	//详细信息查看
	public BClient getPersonneValueById(String clientId);
	
	//更改状态
	public void changeStatus(String[] ids, String status);
	

	//查询客户端
	public List<BClient> getCliValueById(String code);
	
}
