package com.great.manager.service.Impl;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.great.base.service.impl.BaseServiceImpl;
import com.great.manager.dao.PersonnelFileInfoDao;
import com.great.manager.entity.BPerson;
import com.great.manager.service.PersonnelFileInfoService;
import com.great.system.entity.SDictionaryValEntity;
import com.great.tool.PageBean;

@Service
public class PersonnelFileInfoServiceImpl extends BaseServiceImpl<BPerson> implements PersonnelFileInfoService {

	@Autowired
	private PersonnelFileInfoDao personnelFileInfoDao;

	@Override
	public void getResult(PageBean pageBean) {
		this.personnelFileInfoDao.getResult(pageBean);
	}


	/**
	 * @author ZQQ
	 * @param pId
	 * 详细信息查看
	 * */
	@Override
	public BPerson getPersonneValueById(String pId) {
		// TODO Auto-generated method stub
		return personnelFileInfoDao.getPersonneValueById(pId);
	}

}
