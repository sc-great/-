package com.great.manager.dao.Impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.great.base.dao.impl.BaseDaoImpl;
import com.great.manager.dao.PersonDao;
import com.great.manager.entity.BPerson;

/**
 * @author LM 用户数据访问接口实现
 */
@Repository
public class PersonDaoImpl extends BaseDaoImpl implements PersonDao {

	@SuppressWarnings("unchecked")
	public BPerson getPersonByCode(String uCode) {
		StringBuilder hql = new StringBuilder();
		hql.append(" from BPerson where userCode = '" + uCode + "'");
		Query query = getSession().createQuery(hql.toString());
		List<BPerson> list = (List<BPerson>) query.list();
		return list != null ? list.get(0) : null;
	}

	public BPerson getPersonById(String uCode) {
		StringBuilder hql = new StringBuilder();
		hql.append(" from BPerson ").append(" where pId = '" + uCode + "'");
		Query query = getSession().createQuery(hql.toString());
		List<BPerson> list = (List<BPerson>) query.list();
		return list != null ? list.get(0) : null;
	}

	@Override
	public int countNoDeleteByOrgAndHealth(String chId) {
		String sql = "select count(*) from BPerson where orgId = '" + chId + "' and health = 1 and isdeleted = 0 and lastDetection >='" +  (new SimpleDateFormat("yyyy-MM-dd").format(new Date())) + "'";
		return Integer.parseInt((Long) getSession().createQuery(sql).uniqueResult() + "");
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BPerson> findNoDeleteAlarmByTime(String mondayDate) {
		StringBuilder hql = new StringBuilder();
		hql.append(" from BPerson ")
				.append(" where isdeleted = 0 and health = 1 and lastDetection >= '" + mondayDate + "'");
		Query query = getSession().createQuery(hql.toString());
		return (List<BPerson>) query.list();
	}

	public int countNoDelete() {
		String sql = "select count(*) from BPerson where isdeleted = 0";
		return Integer.parseInt((Long) getSession().createQuery(sql).uniqueResult() + "");
	}

	@Override
	public List<BPerson> getPersonByTime(String lastTime) {
		StringBuilder hql = new StringBuilder();
		hql.append(" from BPerson ").append(" where 1=1 and updateTime >= '" + lastTime + "'");
		Query query = getSession().createQuery(hql.toString());
		return (List<BPerson>) query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BPerson> getPersonByOrgAndLikeName(String org, String userName) {
		StringBuilder hql = new StringBuilder();
		hql.append(" from BPerson where 1 = 1");
		if (org != null && !"".equals(org))
			hql.append(" and orgId = '" + org + "'");
		if (userName != null && !"".equals(userName))
			hql.append(" and pName like '%" + userName + "%'");
		Query query = getSession().createQuery(hql.toString());
		return (List<BPerson>) query.list();
	}
}
