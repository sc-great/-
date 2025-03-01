package com.great.manager.dao.Impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.great.base.dao.impl.BaseDaoImpl;
import com.great.manager.dao.LeaveDao;
import com.great.manager.entity.BLeave;
import com.great.manager.entity.BPerson;
import com.great.system.entity.SDictionaryValEntity;
import com.great.tool.PageBean;

import net.sf.json.JSONObject;


@Repository
public class LeaveDaoImpl extends BaseDaoImpl implements LeaveDao{
	/**
	 * 初始化查询列表
	 * */
	public List<BLeave> getSelectList(){
		Criteria criteria = getSession().createCriteria(BLeave.class);		
		criteria.add(Restrictions.and(Restrictions.eq("isdeleted", "0")));
		return criteria.list();
	}
	/**
	 * 	按条件搜索列表
	 */
	@Override
	public void getResult(PageBean pageBean) {
		// TODO Auto-generated method stub
		StringBuffer hql = new StringBuffer();
		 hql.append("from  BLeave  a  where  isdeleted='0'  ");
		
		//简单处理注入
		String templet = (String) pageBean.getMap().get("code");
		String code =templet.replaceAll("\'|%", "\"");
		if (code != null && !"".equals(code)) {
			hql.append("and a.person.userCode like '%" + code + "%'");
		}
		String name = (String) pageBean.getMap().get("name");
		name =name.replaceAll("\'|%", "\"");
		if (name != null && !"".equals(name)) {
			hql.append("and a.person.pName like '%" + name + "%'");
		}
		String startTime = (String) pageBean.getMap().get("startTime");
		if (startTime != null && !"".equals(startTime)) {
			hql.append(" and leaveDate >='" + startTime + "'");
		}
		String endTime = (String) pageBean.getMap().get("endTime");
		if (endTime != null && !"".equals(endTime)) {
			hql.append(" and leaveDate <= '" + endTime + "'");
		}
		
		StringBuilder ledHql = new StringBuilder();
		ledHql.append("select count(*) " +hql.toString());
		Query ledQuery = getSession().createQuery(ledHql.toString());		
		Long countLong = (Long)ledQuery.uniqueResult();
			
		pageBean.setCount(countLong.intValue());
		hql.append(" order by createTime desc");		
				
		Query query = getSession().createQuery(hql.toString());
			
		query.setFirstResult(pageBean.getStartNum());
		query.setMaxResults(pageBean.getLimit());
		
		@SuppressWarnings("unchecked")
		List<BLeave> list = query.list();

		pageBean.setData(list);

	}

	/**
	 * 逻缉批量删除
	 */
	@Override
	public void changeDelStatus(String[] ids, String status) {
		StringBuilder hql = new StringBuilder();
		hql.append("update BLeave set isdeleted =:status  WHERE id IN (:list)");
		Query query = getSession().createQuery(hql.toString());
		query.setParameter("status", status);
		query.setParameterList("list", ids);	
		query.executeUpdate();
	
	}
	
	/**
	 * 添加页面中:下拉员工姓名
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<BPerson> getPersonNameByAll(){		
		Criteria criteria = getSession().createCriteria(BPerson.class);
		criteria.add(Restrictions.and(Restrictions.eq("status", 0)));				
		return criteria.list();
		
	}
	/**
	 * 添加页面中:下拉类型
	 */
	public List<SDictionaryValEntity> getDictValByTypeCodeId(String typeCode){
		StringBuilder hql = new StringBuilder();
		hql.append(" FROM SDictionaryValEntity ue").append(
				" WHERE ue.status=0 and ue.dicId IN(select ut.dicId from SDictionaryEntity ut where ut.status=0 and ut.dicCode = :useType)");
		Query query = getSession().createQuery(hql.toString());
		query.setParameter("useType", typeCode);
		return query.list();
			
	}
	
	
	/**
	 * 据ID取主机对象
	 */
	public  BLeave getBLeave(String id ){
		BLeave returnObj= (BLeave)this.get(BLeave.class, id);	   	
		return returnObj;
	}
	
	/**
	 * //员工主键+日期不能重复
	 */
	@Override
	public List<BLeave> getBLeaveDuplicate(String pId,String leaveDate) {
		Criteria criteria = getSession().createCriteria(BLeave.class);
		criteria.add(Restrictions.and(Restrictions.eq("leaveDate", leaveDate)));
		criteria.add(Restrictions.and(Restrictions.eq("person.pId", pId)));
		return criteria.list();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<BLeave> findByParam(String org, String startTime, String endTime) {
		StringBuilder hql = new StringBuilder();
		hql.append(" from BLeave ").append(" where isdeleted = 0");
		hql.append(" and leaveDate >= '" + startTime + "'");
		hql.append(" and leaveDate <= '" + endTime + "'");
		if (org != null && !"".equals(org))
			hql.append(" and person.pId in (select pId from BPerson where orgId = '" + org + "')");
		
		return getSession().createQuery(hql.toString()).list();
	}
}
