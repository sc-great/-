package com.great.manager.service;

import java.util.List;

import com.great.base.service.BaseService;
import com.great.manager.entity.BPerson;
import com.great.manager.entity.BPersonInfo;
import com.great.manager.entity.STemperatureRecord;


/**
 * @author ZQQ
 * */
public interface PersonnelInfoService extends BaseService<BPersonInfo> {

	/**
	 * 用户手机端登录查询
	 */
	public List<BPersonInfo> getListId(String phone,String checkCode);
	/**
	 * 用户登录查询信息接口
	 */
	public List<BPersonInfo> getListInfoId(String userCode);
	
	public List<STemperatureRecord> getArrayStList(String uCode);
	

	
}
