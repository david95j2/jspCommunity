package com.sbs.example.jspCommunity.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dto.Reply;
import com.sbs.example.jspCommunity.dto.ResultData;
import com.sbs.example.jspCommunity.service.ArticleService;
import com.sbs.example.jspCommunity.service.ReplyService;
import com.sbs.example.util.Util;

public class UsrReplyController extends Controller {

	private ReplyService replyService;
	private ArticleService articleService;

	public UsrReplyController() {
		replyService = Container.replyService;
		articleService = Container.articleService;
	}

	public String doWrite(HttpServletRequest req, HttpServletResponse resp) {
		String body = req.getParameter("body");
		int memberId = Integer.parseInt(req.getParameter("memberId"));
		int articleId = Integer.parseInt(req.getParameter("articleId"));

		int newReplyId = replyService.doWriteArticleReply(articleId, body, memberId);

		String afterWriteReplyUrl = req.getParameter("afterWriteReplyUrl");
		afterWriteReplyUrl = afterWriteReplyUrl.replace("[NEW_REPLY_ID]", newReplyId + "");

		if (Util.isEmpty(req.getParameter("afterWriteReplyUrl")) == false) {

			req.setAttribute("replaceUrl", afterWriteReplyUrl);
		}
		
		ResultData rs = new ResultData("","");

		return json(req,rs);
	}

	public String doDelete(HttpServletRequest req, HttpServletResponse resp) {
		String redirectUrl = req.getParameter("redirectUrl");

		int loginedMemberId = (int) req.getAttribute("loginedMemberId");

		int id = Util.getAsInt(req.getParameter("id"), 0);

		if (id == 0) {
			return msgAndBack(req, "번호를 입력해주세요.");
		}

		Reply reply = replyService.getReply(id);

		if (reply == null) {
			return msgAndBack(req, id + "번 댓글은 존재하지 않습니다.");
		}

		if (replyService.actorCanDelete(reply, loginedMemberId) == false) {
			return msgAndBack(req, "삭제권한이 없습니다.");
		}

		replyService.delete(id);

		return msgAndReplace(req, id + "번 댓글이 삭제되었습니다.", redirectUrl);
	}

	public String doModify(HttpServletRequest req, HttpServletResponse resp) {
		// TODO Auto-generated method stub
		return null;
	}

}