package com.great.manager.dao.Impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;
import com.great.base.dao.impl.BaseDaoImpl;
import com.great.manager.dao.ClientInfoDao;
import com.great.manager.entity.BClient;
import com.great.manager.entity.BPerson;
import com.great.tool.PageBean;

/**
 * @author LUOCHENG
 * 人员档案管理信息数据访问接口实现
 */
@Repository
public class ClientInfoDaoImpl extends BaseDaoImpl implements ClientInfoDao {
	
	/**
	 * 人员档案管理信息数据分页获取方法
	 */
	@Override
	public void getResult(PageBean pageBean) {
		// TODO Auto-generated method stub
		StringBuffer hql = new StringBuffer();
		hql.append("from  BClient  where 1=1  and isdeleted  = 0 ");
//		String muName = (String) pageBean.getMap().get("muName");
		//简单处理注入
		String templet = (String) pageBean.getMap().get("name");
		String status = (String) pageBean.getMap().get("status");
		String name =templet.replaceAll("\'|%", "\"");
		if (name != null && !"".equals(name)) {
			hql.append("and name like '%" + name + "%'");
		}
		if (status != null && !"".equals(status)) {
			hql.append("and status like '%" + status + "%'");
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
	

	/**
	 * 客户端信息状态修改方法
	 */
	@Override
	public void changeStatus(String[] ids, String status) {
		StringBuilder hql = new StringBuilder();
		hql.append("update BClient set status =:status  WHERE id IN (:list)");
		Query query = getSession().createQuery(hql.toString());
		query.setParameter("status", Integer.parseInt(status));
		query.setParameterList("list", ids);
		query.executeUpdate();
	}

	/**
	 * 客户端查看详细信息方法
	 */
	@Override
	public BClient getPersonneValueById(String clientId) {
		StringBuffer hql = new StringBuffer();
		hql.append("from  BClient  where 1=1 and clientId =:clientId");
		Query query = getSession().createQuery(hql.toString());
		query.setParameter("clientId", clientId);
		return (BClient) query.uniqueResult();
	}


	@Override
	public BClient getClientByCode(String code) {
		String sql = "from BClient where code = " + code;
		return (BClient) getSession().createQuery(sql.toString()).list().get(0);
	}


	@Override
	public List<BClient> getCliValueById(String code) {
		StringBuffer hql = new StringBuffer();
		hql.append("from  BClient  where 1=1");
		if (code != null && !"".equals(code)) {
			hql.append("and code = '" + code + "'");
		}
		Query query = getSession().createQuery(hql.toString());
		return query.list();
	}

}
