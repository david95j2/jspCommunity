package com.sbs.example.jspCommunity.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.sbs.example.jspCommunity.dto.Article;
import com.sbs.example.jspCommunity.dto.Board;
import com.sbs.example.mysqlutil.MysqlUtil;
import com.sbs.example.mysqlutil.SecSql;

public class ArticleDao {
	public List<Article> getForPrintArticlesByBoardId(int boardId,int limitStart,int limitCount, String searchKeywordType, String searchKeyword) {
		List<Article> articles = new ArrayList<>();

		SecSql sql = new SecSql();
		sql.append("SELECT A.*");
		sql.append(", M.name AS extra__writer");
		sql.append(", B.name AS extra__boardName");
		sql.append(", B.code AS extra__boardCode");
		sql.append(", IFNULL(SUM(IF(L.point > 0, L.point, 0)) , 0) AS extra__likeCount");
		sql.append(", IFNULL(SUM(IF(L.point < 0, L.point * -1, 0)), 0) AS extra__dislikeCount");
		sql.append("FROM article AS A");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON A.memberId = M.id");
		sql.append("INNER JOIN `board` AS B");
		sql.append("ON A.boardId = B.id");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON L.relId = A.id");
		sql.append("AND A.id = L.relId");
		
		if (boardId != 0) {
			sql.append("WHERE A.boardId = ?", boardId);
		}

		if (searchKeyword != null) {
			if (searchKeywordType == null || searchKeywordType.equals("title")) {
				sql.append("AND A.title LIKE CONCAT('%', ? '%')", searchKeyword);
			} else if (searchKeywordType.equals("body")) {
				sql.append("AND A.body LIKE CONCAT('%', ? '%')", searchKeyword);
			} else if (searchKeywordType.equals("titleAndBody")) {
				sql.append("AND (A.title LIKE CONCAT('%', ? '%') OR A.body LIKE CONCAT('%', ? '%'))", searchKeyword, searchKeyword);
			}
		}
		
		sql.append("GROUP BY A.id");

		sql.append("ORDER BY A.id DESC");
		
		if (limitCount != -1) {
			sql.append("LIMIT ?, ?",limitStart,limitCount);
		}

		List<Map<String, Object>> articleMapList = MysqlUtil.selectRows(sql);

		for (Map<String, Object> articleMap : articleMapList) {
			articles.add(new Article(articleMap));
		}

		return articles;
	}

	public Article getForPrintArticleById(int id) {
		SecSql sql = new SecSql();
		sql.append("SELECT A.*");
		sql.append(", M.name AS extra__writer");
		sql.append(", B.name AS extra__boardName");
		sql.append(", B.code AS extra__boardCode");
		sql.append(", IFNULL(SUM(IF(L.point > 0, L.point, 0)) , 0) AS extra__likeCount");
		sql.append(", IFNULL(SUM(IF(L.point < 0, L.point * -1, 0)), 0) AS extra__dislikeCount");
		sql.append("FROM article AS A");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON A.memberId = M.id");
		sql.append("INNER JOIN `board` AS B");
		sql.append("ON A.boardId = B.id");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON L.relTypeCode = 'article'");
		sql.append("AND A.id = L.relId");
		sql.append("WHERE A.id = ?", id);
		sql.append("GROUP BY A.id");

		Map<String, Object> map = MysqlUtil.selectRow(sql);

		if (map.isEmpty()) {
			return null;
		}

		return new Article(map);
	}

	public Board getBoardById(int id) {

		SecSql sql = new SecSql();
		sql.append("SELECT B.*");
		sql.append("FROM board AS B");
		sql.append("WHERE B.id = ?", id);

		Map<String, Object> map = MysqlUtil.selectRow(sql);

		if (map.isEmpty()) {
			return null;
		}

		return new Board(map);
	}

	public int write(Map<String, Object> args) {
		SecSql sql = new SecSql();
		sql.append("INSERT INTO article");
		sql.append("SET regDate = NOW()");
		sql.append(", updateDate = NOW()");
		sql.append(", boardId = ?", args.get("boardId"));
		sql.append(", memberId = ?", args.get("memberId"));
		sql.append(", title = ?", args.get("title"));
		sql.append(", `body` = ?", args.get("body"));

		return MysqlUtil.insert(sql);
	}

	public int delete(int id) {
		SecSql sql = new SecSql();
		sql.append("DELETE FROM article");
		sql.append("WHERE id = ?", id);

		return MysqlUtil.delete(sql);
	}

	public int modify(Map<String, Object> args) {
		SecSql sql = new SecSql();
		sql.append("UPDATE article");
		sql.append("SET updateDate = NOW()");

		boolean needToUpdate = false;

		if (args.get("title") != null) {
			needToUpdate = true;
			sql.append(", title = ?", args.get("title"));
		}

		if (args.get("body") != null) {
			needToUpdate = true;
			sql.append(", `body` = ?", args.get("body"));
		}

		if (needToUpdate == false) {
			return 0;
		}

		sql.append("WHERE id = ?", args.get("id"));

		return MysqlUtil.update(sql);
	}

	public int getArticlesCountByBoardId(int boardId, String searchKeywordType, String searchKeyword) {
		SecSql sql = new SecSql();
		sql.append("SELECT COUNT(*) AS cnt");
		sql.append("FROM article AS A");
		sql.append("WHERE 1");

		if (boardId != 0) {
			sql.append("AND A.boardId = ?", boardId);
		}

		if (searchKeyword != null) {
			if (searchKeywordType == null || searchKeywordType.equals("title")) {
				sql.append("AND A.title LIKE CONCAT('%', ? '%')", searchKeyword);
			} else if (searchKeywordType.equals("body")) {
				sql.append("AND A.body LIKE CONCAT('%', ? '%')", searchKeyword);
			} else if (searchKeywordType.equals("titleAndBody")) {
				sql.append("AND (A.title LIKE CONCAT('%', ? '%') OR A.body LIKE CONCAT('%', ? '%'))", searchKeyword, searchKeyword);
			}
		}

		return MysqlUtil.selectRowIntValue(sql);
	}
	
	public Article getArticleById(int id) {
		Article article = null;
		SecSql sql = new SecSql();

		sql.append("SELECT A.* , M.name AS extra__writer , B.name AS extra__boardName");
		sql.append(",IFNULL(SUM(IF(L.point > 0 , L.point , 0)) , 0) AS extra__likeCount");
		sql.append(",IFNULL(SUM(IF(L.point < 0 , L.point * -1 , 0)) , 0) AS extra__dislikeCount");
		sql.append(" FROM article AS A");
		sql.append("INNER JOIN `member` AS M");
		sql.append("ON A.memberId = M.id");
		sql.append("INNER JOIN `board` AS B");
		sql.append("ON A.boardId = B.id");
		sql.append("LEFT JOIN `like` AS L");
		sql.append("ON A.id = L.relId");
		sql.append("AND L.relTypeCode = 'article'");		
		sql.append("WHERE A.id = ?", id);
		sql.append("GROUP BY A.id");

		Map<String, Object> articleMap = MysqlUtil.selectRow(sql);
		if (articleMap != null) {
			article = new Article(articleMap);
		}
		return article;
	}

	public void doIncreaseArticleHitCount(Article article) {
		SecSql sql = new SecSql();

		int hitCount = article.getHitCount();

		sql.append("UPDATE article SET");
		sql.append("hitCount = ?", hitCount + 1);
		sql.append("WHERE id = ?", article.getId());

		MysqlUtil.update(sql);
	}
	
	public void doIncreaseArticleHitCount(int articleId, int memberId) {
		SecSql sql = new SecSql();

		sql.append("UPDATE article SET");
		sql.append("hitCount = hitCount + 1");
		sql.append("WHERE id = ?", articleId);

		MysqlUtil.update(sql);
	}	

	public boolean isLikedArticle(int id, int memberId) {
		SecSql sql = new SecSql();

		sql.append("SELECT * FROM `like`");
		sql.append("WHERE `relTypeCode` = 'article'");
		sql.append("AND `relType2` = 'like'");
		sql.append("AND `relId` = ?", id);
		sql.append("AND `memberId` = ?", memberId);

		Map<String, Object> recommendMap = MysqlUtil.selectRow(sql);

		if (!recommendMap.isEmpty()) {
			return true;
		}

		return false;
	}	

	public void doLikeArticle(int id, int memberId) {

		SecSql sql = new SecSql();

		sql.append("INSERT INTO `like` SET");
		sql.append("regDate = NOW(), updateDate = NOW(),");
		sql.append("`relTypeCode` = 'article'");
		sql.append(",`relType2` = 'like'");
		sql.append(", `relId` = ?", id);
		sql.append(", memberId = ?", memberId);
		sql.append(",`point` = 1");

		MysqlUtil.insert(sql);
	}

	public void removeLikeArticle(int id, int memberId) {

		SecSql sql = new SecSql();

		sql.append("DELETE FROM `like`");
		sql.append("WHERE `relTypeCode` = 'article'");
		sql.append("AND `relType2` = 'like'");
		sql.append("AND `relId` = ?", id);
		sql.append("AND memberId = ?", memberId);

		MysqlUtil.delete(sql);
	}

	public boolean isDislikedArticle(int id, int memberId) {
		SecSql sql = new SecSql();

		sql.append("SELECT * FROM `like`");
		sql.append("WHERE `relTypeCode` = 'article'");
		sql.append("AND `relType2` = 'dislike'");
		sql.append("AND `relId` = ?", id);
		sql.append("AND `memberId` = ?", memberId);

		Map<String, Object> recommendMap = MysqlUtil.selectRow(sql);

		if (!recommendMap.isEmpty()) {
			return true;
		}

		return false;
	}

	public void doDislikeArticle(int id, int memberId) {
		SecSql sql = new SecSql();

		sql.append("INSERT INTO `like` SET");
		sql.append("regDate = NOW(), updateDate = NOW()");
		sql.append(",`relTypeCode` = 'article'");
		sql.append(",`relType2` = 'dislike'");
		sql.append(", `relId` = ?", id);
		sql.append(", memberId = ?", memberId);
		sql.append(",`point` = -1");		

		MysqlUtil.insert(sql);
	}

	public void removeDislikeArticle(int id, int memberId) {
		SecSql sql = new SecSql();

		sql.append("DELETE FROM `like`");
		sql.append("WHERE `relTypeCode` = 'article'");
		sql.append("AND `relType2` = 'dislike'");
		sql.append("AND `relId` = ?", id);
		sql.append("AND memberId = ?", memberId);

		MysqlUtil.delete(sql);
	}

}