package com.sbs.example.jspCommunity.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dto.Article;
import com.sbs.example.jspCommunity.dto.Board;
import com.sbs.example.jspCommunity.dto.Reply;
import com.sbs.example.jspCommunity.dto.ResultData;
import com.sbs.example.jspCommunity.service.ArticleService;
import com.sbs.example.jspCommunity.service.ReplyService;
import com.sbs.example.util.Util;

public class UsrArticleController extends Controller{
	private ArticleService articleService;
	private ReplyService replyService;
	
	public UsrArticleController() {
		articleService = Container.articleService;
		replyService = Container.replyService;
	}

	public String showList(HttpServletRequest req, HttpServletResponse resp) {
		String searchKeyword = req.getParameter("searchKeyword");
		String searchKeywordType = req.getParameter("searchKeywordType");

		int itemsInAPage = 30;
		int page = Util.getAsInt(req.getParameter("page"), 1);
		int limitStart = (page - 1) * itemsInAPage;

		int boardId = Integer.parseInt(req.getParameter("boardId"));

		Board board = articleService.getBoardById(boardId);
		req.setAttribute("board", board);

		int totalCount = articleService.getArticlesCountByBoardId(boardId, searchKeywordType, searchKeyword);
		List<Article> articles = articleService.getForPrintArticlesByBoardId(boardId, limitStart, itemsInAPage,
				searchKeywordType, searchKeyword);

		int totalPage = (int) Math.ceil(totalCount / (double) itemsInAPage);

		int pageBoxSize = 10;

		// 현재 페이지 박스 시작, 끝 계산

		int previousPageBoxesCount = (page - 1) / pageBoxSize;
		int pageBoxStartPage = pageBoxSize * previousPageBoxesCount + 1;
		int pageBoxEndPage = pageBoxStartPage + pageBoxSize - 1;

		if (pageBoxEndPage > totalPage) {
			pageBoxEndPage = totalPage;
		}

		// 이전버튼 페이지 계산
		int pageBoxStartBeforePage = pageBoxStartPage - 1;
		if (pageBoxStartBeforePage < 1) {
			pageBoxStartBeforePage = 1;
		}

		// 다음버튼 페이지 계산
		int pageBoxEndAfterPage = pageBoxEndPage + 1;

		if (pageBoxEndAfterPage > totalPage) {
			pageBoxEndAfterPage = totalPage;
		}

		// 이전버튼 노출여부 계산
		boolean pageBoxStartBeforeBtnNeedToShow = pageBoxStartBeforePage != pageBoxStartPage;
		// 다음버튼 노출여부 계산
		boolean pageBoxEndAfterBtnNeedToShow = pageBoxEndAfterPage != pageBoxEndPage;

		req.setAttribute("totalCount", totalCount);
		req.setAttribute("articles", articles);
		req.setAttribute("totalPage", totalPage);
		req.setAttribute("page", page);

		req.setAttribute("pageBoxStartBeforeBtnNeedToShow", pageBoxStartBeforeBtnNeedToShow);
		req.setAttribute("pageBoxEndAfterBtnNeedToShow", pageBoxEndAfterBtnNeedToShow);
		req.setAttribute("pageBoxStartBeforePage", pageBoxStartBeforePage);
		req.setAttribute("pageBoxEndAfterPage", pageBoxEndAfterPage);
		req.setAttribute("pageBoxStartPage", pageBoxStartPage);
		req.setAttribute("pageBoxEndPage", pageBoxEndPage);

		return "usr/article/list";
	}

	public String showDetail(HttpServletRequest req, HttpServletResponse resp) {
		int id = Integer.parseInt(req.getParameter("id"));
		Article article = articleService.getArticleById(id);

		req.setAttribute("article", article);

		article = articleService.getForPrintArticleById(id);

		int memberId = 0;

		HttpSession session = req.getSession();
		if (session.getAttribute("loginedMemberId") != null) {

			memberId = (int) session.getAttribute("loginedMemberId");
		}

		boolean isLikedArticle = articleService.isLikedArticle(id, memberId);
		boolean isDislikedArticle = articleService.isDislikedArticle(id, memberId);
				
		List<Reply> replies = replyService.getArticleReplysByArticleId(id);

		req.setAttribute("article", article);
		req.setAttribute("isLikedArticle", isLikedArticle);
		req.setAttribute("isDislikedArticle", isDislikedArticle);
		req.setAttribute("replies", replies);

		return "usr/article/detail";
	}

	public String showWrite(HttpServletRequest req, HttpServletResponse resp) {
		return "usr/article/write";
	}

	public String doWrite(HttpServletRequest req, HttpServletResponse resp) {
		int loginedMemberId = (int) req.getAttribute("loginedMemberId");

		int boardId = Util.getAsInt(req.getParameter("boardId"), 0);

		if (boardId == 0) {
			return msgAndBack(req, "게시판을 선택해주세요.");
		}

		Board board = articleService.getBoardById(boardId);

		if (board == null) {
			return msgAndBack(req, boardId + "번 게시판은 존재하지 않습니다.");
		}

		String title = req.getParameter("title");

		if (Util.isEmpty(title)) {
			return msgAndBack(req, "제목을 입력해주세요.");
		}

		String body = req.getParameter("body");

		if (Util.isEmpty(body)) {
			return msgAndBack(req, "내용을 입력해주세요.");
		}

		Map<String, Object> writeArgs = new HashMap<>();
		writeArgs.put("memberId", loginedMemberId);
		writeArgs.put("boardId", boardId);
		writeArgs.put("title", title);
		writeArgs.put("body", body);

		int newArticleId = articleService.write(writeArgs);

		return msgAndReplace(req, newArticleId + "번 게시물이 생성되었습니다.", String.format("detail?id=%d&listUrl=/jspCommunity/usr/article/list?boardId=%d", newArticleId,boardId));
	}

	public String doDelete(HttpServletRequest req, HttpServletResponse resp) {
		int id = Util.getAsInt(req.getParameter("id"), 0);

		if (id == 0) {
			return msgAndBack(req, "번호를 입력해주세요.");
		}

		Article article = articleService.getForPrintArticleById(id);

		if (article == null) {
			return msgAndBack(req, id + "번 게시물은 존재하지 않습니다.");
		}

		int loginedMemberId = (int) req.getAttribute("loginedMemberId");

		if (article.getMemberId() != loginedMemberId) {
			return msgAndBack(req, id + "번 게시물에 대한 권한이 없습니다.");
		}

		articleService.delete(id);

		int boardId = article.getBoardId();

		return msgAndReplace(req, id + "번 게시물이 삭제되었습니다.", String.format("list?boardId=%d", boardId));
	}

	public String showModify(HttpServletRequest req, HttpServletResponse resp) {
		int id = Util.getAsInt(req.getParameter("id"), 0);

		if (id == 0) {
			return msgAndBack(req, "번호를 입력해주세요.");
		}

		Article article = articleService.getForPrintArticleById(id);

		if (article == null) {
			return msgAndBack(req, id + "번 게시물은 존재하지 않습니다.");
		}

		int loginedMemberId = (int) req.getAttribute("loginedMemberId");

		if (article.getMemberId() != loginedMemberId) {
			return msgAndBack(req, id + "번 게시물에 대한 권한이 없습니다.");
		}

		Board board = articleService.getBoardById(article.getBoardId());

		req.setAttribute("article", article);
		req.setAttribute("board", board);

		return "usr/article/modify";
	}

	public String doModify(HttpServletRequest req, HttpServletResponse resp) {
		int id = Util.getAsInt(req.getParameter("id"), 0);

		if (id == 0) {
			return msgAndBack(req, "번호를 입력해주세요.");
		}

		Article article = articleService.getForPrintArticleById(id);

		if (article == null) {
			return msgAndBack(req, id + "번 게시물은 존재하지 않습니다.");
		}

		int loginedMemberId = (int) req.getAttribute("loginedMemberId");

		if (article.getMemberId() != loginedMemberId) {
			return msgAndBack(req, id + "번 게시물에 대한 권한이 없습니다.");
		}

		String title = req.getParameter("title");

		if (Util.isEmpty(title)) {
			return msgAndBack(req, "제목을 입력해주세요.");
		}

		String body = req.getParameter("body");

		if (Util.isEmpty(body)) {
			return msgAndBack(req, "내용을 입력해주세요.");
		}

		Map<String, Object> modifyArgs = new HashMap<>();
		modifyArgs.put("id", id);
		modifyArgs.put("title", title);
		modifyArgs.put("body", body);

		articleService.modify(modifyArgs);

		return msgAndReplace(req, id + "번 게시물이 수정되었습니다.", String.format("detail?id=%d", id));
	}
	
	public String doLikeArticle(HttpServletRequest request, HttpServletResponse response) {
		int memberId = Integer.parseInt(request.getParameter("memberId"));
		int id = Integer.parseInt(request.getParameter("articleId"));

		boolean isLikedArticle = articleService.isLikedArticle(id, memberId);
		int likeCount = 0;
		Article article = null;
		String resultCode = null;
		Map<String, Object> map = new HashMap<>();
		
		if (isLikedArticle) {
			articleService.removeLikeArticle(id, memberId);
			article = articleService.getArticleById(id);
			likeCount = article.getExtra__likeCount();			
			resultCode = "F-1";
			map.put("likeCount", likeCount);			
		} else {
			articleService.removeDislikeArticle(id, memberId);
			articleService.doLikeArticle(id, memberId);
			article = articleService.getArticleById(id);
			likeCount = article.getExtra__likeCount();			
			resultCode = "S-1";
			map.put("likeCount", likeCount);			
		}

		return json(request, new ResultData(resultCode, "", map));

	}

	public String doDislikeArticle(HttpServletRequest request, HttpServletResponse response) {
		int memberId = Integer.parseInt(request.getParameter("memberId"));
		int id = Integer.parseInt(request.getParameter("articleId"));

		boolean isDislikedArticle = articleService.isDislikedArticle(id, memberId);
		int dislikeCount = 0;
		Article article = null;		
		String resultCode = null;
		Map<String, Object> map = new HashMap<>();
		
		if (isDislikedArticle) {
			articleService.removeDislikeArticle(id, memberId);
			article = articleService.getArticleById(id);			
			resultCode = "F-1";
			dislikeCount = article.getExtra__dislikeCount();
			map.put("dislikeCount", dislikeCount);			
		} else {
			articleService.removeLikeArticle(id, memberId);
			articleService.doDislikeArticle(id, memberId);
			article = articleService.getArticleById(id);
			dislikeCount = article.getExtra__dislikeCount();			
			resultCode = "S-1";
			map.put("dislikeCount", dislikeCount);			
		}

		return json(request, new ResultData(resultCode, "", map));
	}

	public String doIncreaseArticleHit(HttpServletRequest request, HttpServletResponse response) {

		int memberId = Integer.parseInt(request.getParameter("memberId"));
		int articleId = Integer.parseInt(request.getParameter("articleId"));

		articleService.doIncreaseArticleHitCount(articleId, memberId);

		int hitCount = 0;
		Article article = articleService.getArticleById(articleId);

		hitCount = article.getHitCount();

		Map<String, Object> map = new HashMap<>();

		map.put("hitCount", hitCount);

		return json(request, new ResultData("S-1", "", map));
	}	
}