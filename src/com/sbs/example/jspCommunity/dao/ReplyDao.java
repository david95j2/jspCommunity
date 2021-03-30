package com.sbs.example.jspCommunity.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.sbs.example.jspCommunity.dto.Reply;
import com.sbs.example.mysqlutil.MysqlUtil;
import com.sbs.example.mysqlutil.SecSql;

public class ReplyDao {

	public int write(Map<String, Object> args) {
		SecSql sql = new SecSql();
		sql.append("INSERT INTO reply");
		sql.append("SET regDate = NOW()");
		sql.append(", updateDate = NOW()");
		sql.append(", relTypeCode = ?", args.get("relTypeCode"));
		sql.append(", relId = ?", args.get("relId"));
		sql.append(", memberId = ?", args.get("memberId"));
		sql.append(", `body` = ?", args.get("body"));

		return MysqlUtil.insert(sql);
	}
	
	
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
	
	public Reply getReply(int id) {
		SecSql sql = new SecSql();
		sql.append("SELECT R.*");
		sql.append("FROM reply AS R");
		sql.append("WHERE 1");
		sql.append("AND R.id = ?", id);

		Map<String, Object> map = MysqlUtil.selectRow(sql);

		if (map.isEmpty()) {
			return null;
		}

		return new Reply(map);
	}

	public int delete(int id) {
		SecSql sql = new SecSql();
		sql.append("DELETE FROM reply");
		sql.append("WHERE id = ?", id);

		return MysqlUtil.delete(sql);
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
		
		sql.append("SELECT R.* , M.nickName AS extra__writer FROM `reply` AS R");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON R.memberId = M.id");
		sql.append("WHERE R.relTypeCode = 'article'");
		sql.append("AND R.relId = ?", id);
		
		List<Map<String,Object>> replyMapList = MysqlUtil.selectRows(sql);
		
		if(!replyMapList.isEmpty()) {
			replies = new ArrayList<>();
			for(Map<String,Object> replyMap : replyMapList) {
				replies.add(new Reply(replyMap));
			}
		}
		
		return replies;
	}

}