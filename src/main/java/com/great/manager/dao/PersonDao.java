package com.great.manager.dao;

import java.util.List;

import com.great.base.dao.BaseDao;
import com.great.manager.entity.BPerson;

public interface PersonDao extends BaseDao {

	public BPerson getPersonByCode(String uCode);

	public BPerson getPersonById(String uCode);

	public int countNoDeleteByOrgAndHealth(String chId);

	public List<BPerson> findNoDeleteAlarmByTime(String todayStr);

	public List<BPerson> getPersonByTime(String lastTime);

	public int countNoDelete();

	public List<BPerson> getPersonByOrgAndLikeName(String org, String userName);
}