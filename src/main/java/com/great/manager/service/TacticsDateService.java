package com.great.manager.service;

import java.util.List;

import com.great.base.service.BaseService;
import com.great.manager.entity.CTacticsDate;

public interface TacticsDateService extends BaseService<CTacticsDate>{

	List<CTacticsDate> getBytId(String gettId);

	void deleteByTId(String gettId);

	List<CTacticsDate> findByTdDate(String startTime, String endTime);

}
