package com.great.manager.dao.Impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.great.base.dao.impl.BaseDaoImpl;
import com.great.manager.dao.ClientInfoDao;
import com.great.manager.dao.PersonDao;
import com.great.manager.dao.TemperatureRecordDao;
import com.great.manager.entity.BPerson;
import com.great.manager.entity.STemperatureRecord;
import com.great.tool.PageBean;

import net.sf.json.JSONObject;

/**
 * @author LM
 */
@Repository
public class TemperatureRecordDaoImpl extends BaseDaoImpl implements TemperatureRecordDao {
	
	@Autowired
	private PersonDao personDao;
	@Autowired
	private ClientInfoDao clientInfoDao;
	
	public void getResult(PageBean pageBean) {
		StringBuffer hql = new StringBuffer();
		hql.append("from STemperatureRecord where 1=1 ");
		
		int isAlarm = (int) pageBean.getMap().get("isAlarm");
		if (isAlarm == 1)
			hql.append("and isAlarm = 1 ");
		
		// 简单处理注入
		String templet = (String) pageBean.getMap().get("userName");
		String clientId = (String) pageBean.getMap().get("clientId");
		String userName = templet.replaceAll("\'|%", "\"");
		if (userName != null && !"".equals(userName)) {
			hql.append("and pName like '%" + userName + "%'");
		}
		if (clientId != null && !"".equals(clientId)) {
			hql.append("and clientId like '%" + clientId + "%'");
		}
		String startTime = (String) pageBean.getMap().get("startTime");
		if (startTime != null && !"".equals(startTime)) {
			hql.append(" and createTime >'" + startTime + "'");
		}
		String endTime = (String) pageBean.getMap().get("endTime");
		if (endTime != null && !"".equals(endTime)) {
			hql.append(" and createTime < '" + endTime + "'");
		}
		String hqlString = "select count(*) " + hql.toString();
		Long countLong = (Long) getSession().createQuery(hqlString).uniqueResult();
		pageBean.setCount(countLong.intValue());
		hql.append(" order by createTime desc");
		Query query = getSession().createQuery(hql.toString());
		query.setFirstResult(pageBean.getStartNum());
		query.setMaxResults(pageBean.getLimit());
		List<STemperatureRecord> list = query.list();
		
		List<STemperatureRecord> list_new = new ArrayList<>();
		String uCode = "";
		BPerson person = null;
		for (STemperatureRecord temperature : list) {
			uCode = temperature.getUCode();
			temperature.setClientName(clientInfoDao.getClientByCode(temperature.getClientId()).getName());
			if (uCode == null || "".equals(uCode)) {
				list_new.add(temperature);
				continue;
			}
			person = personDao.getPersonById(uCode);
			if (person == null) {
				list_new.add(temperature);
				continue;
			}
			temperature.setPerson(person);
			list_new.add(temperature);
		}
		
		pageBean.setData(list_new);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<STemperatureRecord> findAlarmToday(String todayStr) {
		StringBuilder hql = new StringBuilder();
		hql.append(" from STemperatureRecord ").append(" where isAlarm = 1 and createTime >= '" + todayStr + "' order by createTime desc");
		Query query = getSession().createQuery(hql.toString());
		List<STemperatureRecord> temperatureRecordList = (List<STemperatureRecord>) query.list();
		List<STemperatureRecord> list_new = new ArrayList<>();
		String uCode = "";
		BPerson person = null;
		for (STemperatureRecord temperature : temperatureRecordList) {
			uCode = temperature.getUCode();
			temperature.setClientName(clientInfoDao.getClientByCode(temperature.getClientId()).getName());
			if (uCode == null || "".equals(uCode)) {
				list_new.add(temperature);
				continue;
			}
			person = personDao.getPersonById(uCode);
			if (person == null) {
				list_new.add(temperature);
				continue;
			}
			temperature.setPerson(person);
			list_new.add(temperature);
		}
		return list_new;
	}

	@Override
	public int countDetectionNum() {
		String sql = "select count(*) from STemperatureRecord where createTime >= '" + (new SimpleDateFormat("yyyy-MM-dd").format(new Date())) + "'";
		return Integer.parseInt((Long) getSession().createQuery(sql).uniqueResult() + "");
	}

	@Override
	public int countVisitorNum() {
		String sql = "select count(*) from STemperatureRecord where trim(uCode) != '' and createTime >= '" + (new SimpleDateFormat("yyyy-MM-dd").format(new Date())) + "'";
		return Integer.parseInt((Long) getSession().createQuery(sql).uniqueResult() + "");
	}

	@Override
	public int countTempAlarmNum() {
		String sql = "select count(*) from STemperatureRecord where isAlarm = 1 and createTime >= '" + (new SimpleDateFormat("yyyy-MM-dd").format(new Date())) + "'";
		return Integer.parseInt((Long) getSession().createQuery(sql).uniqueResult() + "");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getRecordByTimeLikeName(String userName, String startTime, String endTime, String org) {
		// 设置转换的日期格式
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// 得到相差的天数 betweenDate
        long start = 0;
        long end = 0;
		try {
			start = sdf.parse(startTime).getTime();
			if (endTime == null && "".equals(endTime))
	        	end = sdf.parse(new SimpleDateFormat("yyyy-MM-dd").format(new Date())).getTime();
			else
				end = sdf.parse(endTime).getTime();
		} catch (ParseException e) {
			e.printStackTrace();
		}
		int num = Integer.parseInt((end - start) / (60 * 60 * 24 * 1000) + "");
		
		List<String> dateList = new ArrayList<>();
		StringBuffer hql = new StringBuffer();
		hql.append("SELECT t.u_code, t.p_name");
		String date = "";
		for (int i = 0; i <= num; i ++) {
			date = dateUpOneDay(startTime, i);
			dateList.add(date);
			hql.append(", MAX( CASE DATE_FORMAT( t.create_time, '%Y-%m-%d' ) WHEN '" + date + "' THEN t.create_time END ) as '" + date + ".max'");
			hql.append(", MIN( CASE DATE_FORMAT( t.create_time, '%Y-%m-%d' ) WHEN '" + date + "' THEN t.create_time END ) as '" + date + ".min'");
		}
		hql.append(" FROM s_temp_record t where 1 = 1");
		
		if (userName != null && !"".equals(userName))
			hql.append(" and t.u_code in (select p_id from b_person where p_name like '%" + userName.replaceAll("\'|%", "\"") + "%')");
		if (org != null && !"".equals(org))
			hql.append(" and t.u_code in (select p_id from b_person where org_id = '" + org + "')");
		if (startTime != null && !"".equals(startTime))
			hql.append(" and t.create_time >= '" + startTime + "'");
		if (endTime != null && !"".equals(endTime))
			hql.append(" and t.create_time <= '" + endTime + "'");
		
		hql.append(" GROUP BY t.u_code");
		
		List<Object[]> list = getSession().createSQLQuery(hql.toString()).list();
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("jsonObject", list);
		jsonObject.put("jsonDate", dateList);

//		System.out.println(jsonObject);
		return jsonObject;
	}
	
	// 时间加一天的方法
	public static String dateUpOneDay(String date, int i) {
		Calendar calendar = new GregorianCalendar();
		try {
			calendar.setTime(new SimpleDateFormat("yyyy-MM-dd").parse(date));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		calendar.add(calendar.DATE, i); // 把日期往后增加i天，整数往后推，负数往前移动
		return new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime()); // 这个时间就是日期往后推一天的结果
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Map<String, String>> getRecordByTimeLikeName2(Map<String, String> param) {
		Map<String, Map<String, String>> map = new HashMap<>();
		Map<String, String> m = null;
		String userName = param.get("userName"), 
				startTime = param.get("startTime"), 
				endTime = param.get("endTime"),
				org = param.get("org");
		
		int num = Integer.parseInt(param.get("num"));
		
		StringBuffer hql = new StringBuffer();
		hql.append("SELECT t.u_code, t.p_name");
		String date = "";
		for (int i = 0; i <= num; i ++) {
			date = dateUpOneDay(startTime, i);
			hql.append(", MAX( CASE DATE_FORMAT( t.create_time, '%Y-%m-%d' ) WHEN '" + date + "' THEN t.create_time END ) as '" + date + ".max'");
			hql.append(", MIN( CASE DATE_FORMAT( t.create_time, '%Y-%m-%d' ) WHEN '" + date + "' THEN t.create_time END ) as '" + date + ".min'");
		}
		hql.append(" FROM s_temp_record t where 1 = 1");
		
		if (userName != null && !"".equals(userName))
			hql.append(" and t.u_code in (select p_id from b_person where p_name like '%" + userName.replaceAll("\'|%", "\"") + "%')");
		if (org != null && !"".equals(org))
			hql.append(" and t.u_code in (select p_id from b_person where org_id = '" + org + "')");
		if (startTime != null && !"".equals(startTime))
			hql.append(" and t.create_time >= '" + startTime + "'");
		if (endTime != null && !"".equals(endTime))
			hql.append(" and t.create_time <= '" + endTime + "'");
		
		hql.append(" GROUP BY t.u_code");
		
		List<Object[]> list = getSession().createSQLQuery(hql.toString()).list();
		String[] array = null;
		for (Object[] obj : list) {
			m = new HashMap<>();
			// 如果没有org的话，会查到外来人员，在此处剔除
			if (obj[0] == null)
				continue;
			for (int i = 2; i < obj.length; i = i + 2) {
				if (obj[i] != null) {
					array = obj[i].toString().split(" ");
					m.put(array[0] + ".max", array[1]);
					array = obj[i + 1].toString().split(" ");
					m.put(array[0] + ".min", array[1]);
				}
			}
			map.put(obj[0].toString(), m);
		}
		return map;
	}
}
