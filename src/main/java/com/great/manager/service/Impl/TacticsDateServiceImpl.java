package com.great.manager.service.Impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.great.base.service.impl.BaseServiceImpl;
import com.great.manager.dao.TacticsDateDao;
import com.great.manager.entity.CTacticsDate;
import com.great.manager.service.TacticsDateService;

@Service
public class TacticsDateServiceImpl extends BaseServiceImpl<CTacticsDate> implements TacticsDateService {

	@Autowired
	private TacticsDateDao tacticsDateDao;

	@Override
	public List<CTacticsDate> getBytId(String gettId) {
		return tacticsDateDao.getBytId(gettId);
	}

	@Override
	public void deleteByTId(String gettId) {
		tacticsDateDao.deleteByTId(gettId);
	}

	@Override
	public List<CTacticsDate> findByTdDate(String startTime, String endTime) {
		return tacticsDateDao.findByTdDate(startTime, endTime);
	}
}
