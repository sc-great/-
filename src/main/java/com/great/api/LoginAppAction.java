package com.great.api;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.great.base.action.BaseAction;
import com.great.base.entity.Message2Page2;
import com.great.manager.dao.TemperatureRecordDao;
import com.great.manager.entity.BClient;
import com.great.manager.entity.BPerson;
import com.great.manager.entity.BPersonInfo;
import com.great.manager.entity.STemperatureRecord;
import com.great.manager.service.ClientInfoService;
import com.great.manager.service.PersonnelFileInfoService;
import com.great.manager.service.PersonnelInfoService;
import com.great.resource.StaticData;
import com.great.system.entity.SUserEntity;
import com.great.system.service.UserService;
import com.great.tool.DigitalSign;
import com.great.tool.JsonCovert;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import sun.misc.BASE64Decoder;

@RestController
@RequestMapping(value = "/api")
public class LoginAppAction extends BaseAction {

	@Autowired
	private UserService userService;
	@Autowired
	private PersonnelFileInfoService personnelFileInfoService;
	@Autowired
	private TemperatureRecordDao temperatureRecordDao;
	
	@Autowired
	private PersonnelInfoService personnelInfoService;
	@Autowired
	private ClientInfoService clientInfoService;
	
	private Logger logger = LoggerFactory.getLogger(getClass());

	/**
	 * 手机用户登录验证
	 * 
	 * @param userName
	 * @param passWord
	 * @return
	 */
	@SuppressWarnings({ "phone", "checkCode", "msg" })
	@PostMapping("/loginApp")
	public Message2Page2 login(@RequestBody String jsonData) {
		JSONObject paramData = JSONObject.fromObject(jsonData);
		String phone = paramData.getString("phone");
		String verificationCode = paramData.getString("checkCode");
		
		
		//base64解码(密码)
		BASE64Decoder decoder = new BASE64Decoder();
		byte[] passW = null;
		try {
			passW = decoder.decodeBuffer(verificationCode);
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		//获取解码密码
		String checkCode = new String(passW);
		BPersonInfo user = new BPersonInfo();
		user.setPPhone(phone);
		user.setVerificationCode(checkCode);
		List<BPersonInfo> users = null;
		JSONObject us=new JSONObject();
		try {
			//users = personnelInfoService.findByExample(user);
			users=personnelInfoService.getListId(phone,checkCode);
			//返回需要的值
			us.put("userCode", users.get(0).getUserCode());
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		if (users != null && users.size() > 0) {
			if (true) {
				String loginmsg = "用户登录：" + user.getPName() + ",验证成功";
				saveLogB(loginmsg, StaticData.LOG_TYPE_LOGIN); 
				return new Message2Page2(true, 200, "成功", us);
			} else {
				return new Message2Page2(false, 201, "验证码错误");
			}
		} else {
			return new Message2Page2(false, 201,"该用户不存在！" );
		}
		}

	
	
	
	
	/**
	 * 手机用户登录验证
	 * 
	 * @param userName
	 * @param passWord
	 * @return
	 */
	@PostMapping("/loginAppInfo")
	public Message2Page2 loginAppInfo(@RequestBody String jsonData) {
		JSONObject paramData = JSONObject.fromObject(jsonData);
		String userCode = paramData.getString("userCode");
		String message = "";
		BPersonInfo user = new BPersonInfo();
		user.setPId(userCode);
		//时间格式
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		List<BPersonInfo> users = null;
		JSONObject us=new JSONObject();
		try {
			users=personnelInfoService.getListInfoId(userCode);
			//返回需要的值
			String lastDetection = sdf.format(users.get(0).getLastDetection());
			us.put("health",users.get(0).getHealth());
			us.put("lastTemp",users.get(0).getLastTemp());
			us.put("userCode",users.get(0).getUserCode());
		    us.put("lastDetection", lastDetection);
		    us.put("orgName", users.get(0).getOrgName());
		    us.put("pPic", users.get(0).getPPic());
		    us.put("pName", users.get(0).getPName());
		    us.put("pId", users.get(0).getPId());
		    us.put("pPhone", users.get(0).getPPhone());
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		if (users != null && users.size() > 0) {
			if (true) {
				String loginmsg = "用户登录：" + user.getPName() + ",验证成功";
				saveLogB(loginmsg, StaticData.LOG_TYPE_LOGIN); 
				return new Message2Page2(true, 200, message, us);
			} else {
				return new Message2Page2(false, 201, "验证码错误");
			}
		} else {
			return new Message2Page2(false, 201,"该用户不存在！" );
		}
		}

	

	/**
	 * 向手机端获取健康码的用户发送登录验证码
	 * 
	 * @param pPhone
	 * @return
	 */
	@PostMapping("/sendCode")
	public Message2Page2 sendCode(@RequestParam String pPhone) {

		return new Message2Page2(true, 200, "验证码已发送！");
	}

	/**
	 * 
	 * PC监控端登录验证
	 * 
	 * @param userName
	 * @param passWord
	 * @return
	 */
	@PostMapping("/loginMoin")
	public Message2Page2 loginMoin(@RequestBody String jsonData) {
		JSONObject paramData = JSONObject.fromObject(jsonData);
		String userName = paramData.getString("userName");
		String pass = paramData.getString("passWord");
		BASE64Decoder decoder = new BASE64Decoder();
		byte[] passW = null;
		try {
			passW = decoder.decodeBuffer(pass);
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		String passWord = new String(passW);
		SUserEntity user = new SUserEntity();
		user.setLoginName(userName);
		user.setStatus(StaticData.STATUS_NORMAL);
		user.setIsdeleted(false);
		List<SUserEntity> users = null;
		try {
			users = userService.findByExample(user);
		} catch (Exception e) {
			logger.error(e.getMessage());
			users = userService.findByExample(user);
		}
		// 判断用户密码
		if (users != null && users.size() > 0) {
			user = users.get(0);
			if (user.getPasswd().equals(DigitalSign.getMD5(passWord))) {
				user.setLastLoginTime(new Date());
				this.userService.update(user);
				String loginmsg = "用户登录：" + user.getUserName() + ",登录后监控系统";
				saveLogB(loginmsg, StaticData.LOG_TYPE_LOGIN);
				JSONObject userObject = JSONObject.fromObject(user);
				userObject = JsonCovert.filterNull(userObject);
				return new Message2Page2(true, 200, "登录成功", userObject);
			} else {
				return new Message2Page2(false, 201, "用户密码错误！");
			}
		} else {
			return new Message2Page2(false, 202, "该用户不存在！");
		}
	}

	@PostMapping("/loginOut")
	public Message2Page2 loginOut() {
		this.getSession().removeAttribute(StaticData.USER_SESSION);
		return new Message2Page2(true, 200, "");
	}

	/**
	 * 用户密码修改，PC端使用
	 * @param jsonData
	 * @return
	 */
	@PostMapping("/rechangePassword")
	public Message2Page2 rechangePassword(@RequestBody String jsonData) {
		JSONObject paramData = JSONObject.fromObject(jsonData);
		SUserEntity vmUser = userService.get(SUserEntity.class, paramData.getString("userId"));
		if (DigitalSign.getMD5(paramData.getString("password1")).equals(vmUser.getPasswd())) {
			vmUser.setPasswd(DigitalSign.getMD5(paramData.getString("password2")));
			userService.update(vmUser);
			String msg = "修改用户密码：" + vmUser.getUserName();
			// saveLogB(msg, StaticData.LOG_TYPE_DO);
			return new Message2Page2(true, 200, "修改成功");
		} else {
			return new Message2Page2(false, 200, "旧密码输入不正确,请重新输入");
		}
	}
	
	/**
	 * 用户ID查询当前最新的5条体温数据
	 */
	@PostMapping("/latesFivetData")
	public Message2Page2 latesFivetData(@RequestBody String jsonData) {
		JSONObject paramData = JSONObject.fromObject(jsonData);
		String uCode = paramData.getString("uCode");
		Map<String,Object> map=null;
		List<Map<String,Object>> list = new ArrayList();
		JSONObject us=new JSONObject();
		List<STemperatureRecord> users=null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			users = personnelInfoService.getArrayStList(uCode);
				//返回需要的值
				for(int i=0;i<users.size();i++) {
					
					map=new HashMap<>();
					map.put("pName", users.get(i).getPName());
					map.put("tempId", users.get(i).getTempId());
					//体温
					String temperature=String.valueOf(users.get(i).getTemperature());
					map.put("temperature", temperature.substring(0, 4));
					//客户端编号
					List<BClient> bc=clientInfoService.getCliValueById(users.get(i).getClientId());
					String clientId=bc.get(0).getName();
					map.put("clientId", clientId);
					//创建时间
					String createTime = sdf.format(users.get(i).getCreateTime());
					map.put("createTime", createTime);
					list.add(map);
				}
				
				
				
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		if (users != null && users.size() > 0) {
			if (true) {
				us.put("data", list);
				return new Message2Page2(true, 200, "成功", us);
			} else {
				return new Message2Page2(false, 201, "验证码错误");
			}
		} else {
			return new Message2Page2(false, 201,"该用户不存在！" );
		}
		
	}
}
