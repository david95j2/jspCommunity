package com.sbs.example.jspCommunity.dto;

import java.util.LinkedHashMap;
import java.util.Map;

import lombok.Data;

@Data
public class Reply {
	private int id;
	private String regDate;
	private String updateDate;
	private String relTypeCode;
	private int relId;
	private String body;
	private int memberId;
	private int status;

	private Map<String, Object> extra;

	private String extra__writer;
	private int extra__likeCount;
	private int extra__dislikeCount;

	public Reply(Map<String, Object> map) {
		this.id = (int) map.get("id");
		this.regDate = (String) map.get("regDate");
		this.updateDate = (String) map.get("updateDate");
		this.relTypeCode = (String) map.get("relTypeCode");
		this.body = (String) map.get("body");
		this.memberId = (int) map.get("memberId");
		this.status = (int) map.get("status");

		this.relTypeCode = (String) map.get("relTypeCode");
		this.relId = (int) map.get("relId");

		if (map.containsKey("extra__writer")) {
			this.extra__writer = (String) map.get("extra__writer");
		}

		if (map.containsKey("extra__likeCount")) {
			this.extra__likeCount = (int) map.get("extra__likeCount");
		}

		if (map.containsKey("extra__dislikeCount")) {
			this.extra__dislikeCount = (int) map.get("extra__dislikeCount");
		}

		this.extra = new LinkedHashMap<>();
	}
}