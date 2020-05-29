package com.great.base.entity;

import net.sf.json.JSONObject;

public class Message2Page2 {

	private boolean success;
	private Integer code;
	private String message;
	private JSONObject data;

	public Message2Page2(boolean success, Integer code, String message, JSONObject data) {
		super();
		this.success = success;
		this.code = code;
		this.message = message;
		this.data = data;
	}

	public Message2Page2(boolean success, Integer code, String message) {
		super();
		this.success = success;
		this.code = code;
		this.message = message;
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public JSONObject getData() {
		return data;
	}

	public void setData(JSONObject data) {
		this.data = data;
	}

	@Override
	public String toString() {
		return "Message2Page2 [success=" + success + ", code=" + code + ", message=" + message + ", data=" + data + "]";
	}

}
