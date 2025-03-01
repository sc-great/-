package com.great.manager.dao;

import java.util.List;
import java.util.Map;

import com.great.base.dao.BaseDao;
import com.great.manager.entity.STemperatureRecord;
import com.great.tool.PageBean;

import net.sf.json.JSONObject;

public interface TemperatureRecordDao extends BaseDao {
	public void getResult(PageBean pageBean);

	public List<STemperatureRecord> findAlarmToday(String todayStr);

	public int countDetectionNum();

	public int countVisitorNum();

	public int countTempAlarmNum();

	JSONObject getRecordByTimeLikeName(String userName, String startTime, String endTime, String org);

	public Map<String, Map<String, String>> getRecordByTimeLikeName2(Map<String, String> param);
	
}
