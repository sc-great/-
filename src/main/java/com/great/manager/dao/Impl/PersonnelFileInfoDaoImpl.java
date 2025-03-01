package com.great.manager.dao.Impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;
import com.great.base.dao.impl.BaseDaoImpl;
import com.great.manager.dao.PersonnelFileInfoDao;
import com.great.manager.entity.BPerson;
import com.great.system.entity.SDictionaryValEntity;
import com.great.tool.PageBean;

/**
 * @author LUOCHENG
 * 人员档案管理信息数据访问接口实现
 */
@Repository
public class PersonnelFileInfoDaoImpl extends BaseDaoImpl implements PersonnelFileInfoDao {
	/* 
	 * 人员档案管理信息数据分页获取方法
	 * @see com.great.system.dao.UserDao#getResult(com.great.tool.PageBean)
	 */
	@Override
	public void getResult(PageBean pageBean) {
		// TODO Auto-generated method stub
		StringBuffer hql = new StringBuffer();
		hql.append("from  BPerson  where 1=1 and isdeleted  = 0   ");
//		String muName = (String) pageBean.getMap().get("muName");
		//简单处理注入
		String templet = (String) pageBean.getMap().get("pName");
		String pName =templet.replaceAll("\'|%", "\"");
		if (pName != null && !"".equals(pName)) {
			hql.append("and pName like '%" + pName + "%'");
		}
		String startTime = (String) pageBean.getMap().get("startTime");
		if (startTime != null && !"".equals(startTime)) {
			hql.append(" and lastDetection >'" + startTime + "'");
		}
		String endTime = (String) pageBean.getMap().get("endTime");
		if (endTime != null && !"".equals(endTime)) {
			hql.append(" and lastDetection < '" + endTime + "'");
		}
		String hqlString = "select count(*) " + hql.toString();
		Long countLong = (Long) getSession().createQuery(hqlString).uniqueResult();
		pageBean.setCount(countLong.intValue());
		Query query = getSession().createQuery(hql.toString());
		query.setFirstResult(pageBean.getStartNum());
		query.setMaxResults(pageBean.getLimit());
		List<BPerson> list = query.list();
		pageBean.setData(list);

	}

	/***
	 * @author ZQQ
	 * 详细信息查看
	 */
	@Override
	public BPerson getPersonneValueById(String pId) {
		StringBuffer hql = new StringBuffer();
		hql.append("from  BPerson  where 1=1 and pId =:pId");
		Query query = getSession().createQuery(hql.toString());
		query.setParameter("pId", pId);
		return (BPerson) query.uniqueResult();
	}

	


}
