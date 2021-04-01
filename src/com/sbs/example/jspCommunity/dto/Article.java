package com.sbs.example.jspCommunity.dto;

import java.util.LinkedHashMap;
import java.util.Map;

import lombok.Data;

@Data
public class Article {
	private int id;
	private String regDate;
	private String updateDate;
	private String title;
	private String body;
	private int memberId;
	private int boardId;
	private int hitCount;
	private int replyCount;
	
	private Map<String, Object> extra;
	
	private String extra__writer;
	private String extra__boardName;
	private String extra__boardCode;
	private int extra__likeCount;
	private int extra__dislikeCount;
	
	public Article(Map<String, Object> map) {
		this.id = (int) map.get("id");
		this.regDate = (String) map.get("regDate");
		this.updateDate = (String) map.get("updateDate");
		this.title = (String) map.get("title");
		this.body = (String) map.get("body");
		this.memberId = (int) map.get("memberId");
		this.boardId = (int) map.get("boardId");
		this.hitCount = (int) map.get("hitCount");
		this.replyCount = (int) map.get("replyCount");

		if (map.containsKey("extra__writer")) {
			this.extra__writer = (String) map.get("extra__writer");
		}

		if (map.containsKey("extra__boardName")) {
			this.extra__boardName = (String) map.get("extra__boardName");
		}

		if (map.containsKey("extra__boardCode")) {
			this.extra__boardCode = (String) map.get("extra__boardCode");
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
