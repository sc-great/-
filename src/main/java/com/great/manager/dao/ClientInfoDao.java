package com.great.manager.dao;

import java.util.List;

import com.great.base.dao.BaseDao;
import com.great.manager.entity.BClient;
import com.great.tool.PageBean;

public interface ClientInfoDao extends BaseDao {
	
	/***分页查询 */
	public void getResult(PageBean pageBean);

	
	/***
	 * 详细信息查看
	 * @param value
	 * @return
	 */
	public BClient getPersonneValueById(String clientId);
	
	/***客户端更改状态 */
	public void changeStatus(String[] ids, String status);

	public BClient getClientByCode(String clientId);
	
	public List<BClient> getCliValueById(String code);
	
}
