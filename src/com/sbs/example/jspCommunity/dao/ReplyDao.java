package com.sbs.example.jspCommunity.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.sbs.example.jspCommunity.dto.Reply;
import com.sbs.example.mysqlutil.MysqlUtil;
import com.sbs.example.mysqlutil.SecSql;

public class ReplyDao {
	
	public List<Reply> getForPrintReplies(String relTypeCode, int relId) {
		List<Reply> replies = new ArrayList<>();

		SecSql sql = new SecSql();
		sql.append("SELECT R.*");
		sql.append(", M.name AS extra__writer");
		sql.append(", IFNULL(SUM(L.point), 0) AS extra__likePoint");
		sql.append(", IFNULL(SUM(IF(L.point > 0, L.point, 0)), 0) AS extra__likeOnlyPoint");
		sql.append(", IFNULL(SUM(IF(L.point < 0, L.point * -1, 0)), 0) extra__dislikeOnlyPoint");
		sql.append("FROM reply AS R");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON R.memberId = M.id");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON L.relTypeCode = 'article'");
		sql.append("AND R.id = L.relId");
		sql.append("WHERE 1");
		sql.append("AND R.relTypeCode = ?", relTypeCode);
		sql.append("AND R.relId = ?", relId);
		sql.append("GROUP BY R.id");
		sql.append("ORDER BY R.id DESC");

		List<Map<String, Object>> mapList = MysqlUtil.selectRows(sql);

		for (Map<String, Object> map : mapList) {
			replies.add(new Reply(map));
		}

		return replies;
	}

	public int doWriteArticleReply(int articleId, String body, int memberId) {
		int newReplyId = 0;

		SecSql sql = new SecSql();

		sql.append("INSERT INTO reply SET");
		sql.append("regDate = NOW() , updateDate = NOW()");
		sql.append(",`relTypeCode` = 'article'");
		sql.append(",`relId` = ?", articleId);
		sql.append(",`body` = ?", body);
		sql.append(",`memberId` = ?", memberId);
		sql.append(",`status` = 1");

		newReplyId = MysqlUtil.insert(sql);

		sql = new SecSql();

		sql.append("UPDATE article SET");
		sql.append("replyCount = replyCount + 1");
		sql.append("WHERE id = ?", articleId);

		MysqlUtil.update(sql);

		return newReplyId;
	}


	public List<Reply> getArticleReplysByArticleId(int id) {
		List<Reply> replies = null;
		
		SecSql sql = new SecSql();
		
		sql.append("SELECT R.* , M.nickName AS extra__writer");
		sql.append(",IFNULL(SUM(IF(L.point > 0 , L.point , 0)) , 0) AS extra__likeCount");
		sql.append(",IFNULL(SUM(IF(L.point < 0 , L.point * -1 , 0)) , 0) AS extra__dislikeCount");
		sql.append(" FROM `reply` AS R");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON R.memberId = M.id");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON R.id = L.relId");
		sql.append("GROUP BY R.id");
		
		List<Map<String,Object>> replyMapList = MysqlUtil.selectRows(sql);
		
		if(!replyMapList.isEmpty()) {
			replies = new ArrayList<>();
			for(Map<String,Object> replyMap : replyMapList) {
				replies.add(new Reply(replyMap));
			}
		}
		
		return replies;
	}


	public void doModifyArticleReply(int id, int articleId, String body, int memberId) {
		SecSql sql = new SecSql();

		sql.append("UPDATE `reply` SET");
		sql.append("updateDate = NOW()");
		sql.append(", `body` = ?", body);
		sql.append("WHERE id = ?", id);
		sql.append("AND `relTypeCode` = 'article'");
		sql.append("AND `relId` = ?", articleId);
		sql.append("AND memberId = ?", memberId);

		MysqlUtil.update(sql);
	}


	public void doDeleteArticleReply(int id, int articleId) {
		SecSql sql = new SecSql();

		sql.append("UPDATE `reply` SET");
		sql.append("`status` = -1");
		sql.append("WHERE id = ?", id);

		MysqlUtil.update(sql);

		sql = new SecSql();

		sql.append("UPDATE article SET");
		sql.append("replyCount = replyCount -1");
		sql.append("WHERE id = ?", articleId);

		MysqlUtil.update(sql);
	}
	
	public boolean isLikedReply(int id, int memberId) {

		SecSql sql = new SecSql();

		sql.append("SELECT * FROM `like`");
		sql.append("WHERE relId = ? ", id);
		sql.append("AND memberId = ?", memberId);
		sql.append("AND relTypeCode = 'reply'");
		sql.append("AND `point` = 1");

		Map<String, Object> map = MysqlUtil.selectRow(sql);

		if (!map.isEmpty()) {
			return true;
		}

		return false;

	}

	public void doDeleteReplyLike(int id, int memberId) {
		SecSql sql = new SecSql();

		sql.append("DELETE FROM `like`");
		sql.append("WHERE relId = ? ", id);
		sql.append("AND memberId = ?", memberId);
		sql.append("AND relTypeCode = 'reply'");
		sql.append("AND `point` = 1");
		
		MysqlUtil.delete(sql);
	}

	public Reply getReplyById(int id) {
		
		Reply reply = null;
		
		SecSql sql = new SecSql();

		sql.append("SELECT R.* "
				+ ",IFNULL(SUM(IF(L.point > 0 , L.point , 0)) , 0) AS extra__likeCount"				
				+ ",IFNULL(SUM(IF(L.point < 0 , L.point * -1 , 0)) , 0) AS extra__dislikeCount"
				+ " FROM reply AS R");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON R.id = L.relId");
		sql.append("AND L.relTypeCode = 'reply'");
		sql.append("WHERE R.id = ? ", id);
		sql.append("GROUP BY R.id");
		Map<String,Object> map = MysqlUtil.selectRow(sql);
		
		if(!map.isEmpty()) {
			reply = new Reply(map);
		}
		
		return reply;
				
	}

	public void doIncreaseReplyLike(int id, int memberId) {
		SecSql sql = new SecSql();

		sql.append("INSERT INTO `like` SET");
		sql.append("regDate = NOW() , updateDate = NOW()");
		sql.append(", relTypeCode = 'reply'");
		sql.append(", relType2 = 'like'");
		sql.append(",`point` = 1");
		sql.append(",relId = ?",id);
		sql.append(",memberId = ?" , memberId);
		
		MysqlUtil.update(sql);
	}

	public boolean isDisLikedReply(int id, int memberId) {
		SecSql sql = new SecSql();

		sql.append("SELECT * FROM `like`");
		sql.append("WHERE relId = ? ", id);
		sql.append("AND memberId = ?", memberId);
		sql.append("AND relTypeCode = 'reply'");
		sql.append("AND `point` = -1");

		Map<String, Object> map = MysqlUtil.selectRow(sql);

		if (!map.isEmpty()) {
			return true;
		}

		return false;
	}

	public void doDeleteReplyDisLike(int id, int memberId) {
		SecSql sql = new SecSql();

		sql.append("DELETE FROM `like`");
		sql.append("WHERE relId = ? ", id);
		sql.append("AND memberId = ?", memberId);
		sql.append("AND relTypeCode = 'reply'");
		sql.append("AND `point` = -1");
		
		MysqlUtil.delete(sql);
	}

	public void doIncreaseReplyDisLike(int id, int memberId) {
		SecSql sql = new SecSql();

		sql.append("INSERT INTO `like` SET");
		sql.append("regDate = NOW() , updateDate = NOW()");
		sql.append(", relTypeCode = 'reply'");
		sql.append(", relType2 = 'dislike'");
		sql.append(",`point` = -1");
		sql.append(",relId = ?",id);
		sql.append(",memberId = ?" , memberId);
		
		MysqlUtil.update(sql);
	}

	public List<Reply> getReplies() {
		List<Reply> replies = null;

		SecSql sql = new SecSql();

		sql.append("SELECT R.* , M.nickName AS extra__writer"
				+ ",IFNULL(SUM(IF(L.point > 0 , L.point , 0)) , 0) AS extra__likeCount"
				+ ",IFNULL(SUM(IF(L.point < 0 , L.point * -1 , 0)) , 0) AS extra__dislikeCount"
				+ " FROM `reply` AS R");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON R.memberId = M.id");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON R.id = L.relId");
		sql.append("GROUP BY R.id");

		List<Map<String, Object>> replyMapList = MysqlUtil.selectRows(sql);

		if (!replyMapList.isEmpty()) {
			replies = new ArrayList<>();
			for (Map<String, Object> replyMap : replyMapList) {
				replies.add(new Reply(replyMap));
			}
		}

		return replies;

	}

	public int doWriteReply(String relType, int relId, String body, int memberId,int articleId) {
		
		SecSql sql = new SecSql();

		sql.append("INSERT INTO `reply` SET");
		sql.append("regDate = NOW(), updateDate = NOW()");
		sql.append(", `relTypeCode` = ?", relType);
		sql.append(", `relId` = ?", relId);
		sql.append(", `body` = ?", body);
		sql.append(", `memberId` = ?", memberId);
		sql.append(", `status` = 1");

		int id = MysqlUtil.insert(sql);
		
		sql = new SecSql();

		sql.append("UPDATE article SET");
		sql.append("replyCount = replyCount + 1");
		sql.append("WHERE id = ?", articleId);

		MysqlUtil.update(sql);
		
		return id;

	}

	public void doModifyReplyReply(int id, String body, int memberId) {
		SecSql sql = new SecSql();

		sql.append("UPDATE `reply` SET");
		sql.append("updateDate = NOW()");
		sql.append(", `body` = ?", body);
		sql.append("WHERE id = ?", id);
		sql.append("AND `relTypeCode` = 'reply'");
		sql.append("AND memberId = ?", memberId);

		MysqlUtil.update(sql);
	}

	public void doDeleteReplyReply(int id, int articleId) {
		SecSql sql = new SecSql();

		sql.append("UPDATE `reply` SET");
		sql.append("`status` = -1");
		sql.append("WHERE id = ?", id);

		MysqlUtil.update(sql);

		sql = new SecSql();

		sql.append("UPDATE article SET");
		sql.append("replyCount = replyCount -1");
		sql.append("WHERE id = ?", articleId);

		MysqlUtil.update(sql);

	}
	
}