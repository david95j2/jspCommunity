package com.sbs.example.jspCommunity.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dto.ResultData;
import com.sbs.example.jspCommunity.service.ReplyService;
import com.sbs.example.util.Util;

public class UsrReplyController extends Controller {

	private ReplyService replyService;

	public UsrReplyController() {
		replyService = Container.replyService;
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
		int id = Integer.parseInt(req.getParameter("id"));
		int articleId = Integer.parseInt(req.getParameter("articleId"));
		replyService.doDeleteArticleReply(id,articleId);

		if (Util.isEmpty(req.getParameter("afterWriteReplyUrl")) == false) {

			req.setAttribute("replaceUrl", req.getParameter("afterWriteReplyUrl"));
		}

		return json(req,new ResultData("",""));
	}

	public String doModify(HttpServletRequest req, HttpServletResponse resp) {
		int id = Integer.parseInt(req.getParameter("id"));
		String body = req.getParameter("body");
		int memberId = Integer.parseInt(req.getParameter("memberId"));
		int articleId = Integer.parseInt(req.getParameter("articleId"));
		replyService.doModifyArticleReply(id, articleId, body, memberId);

		String afterWriteReplyUrl = req.getParameter("afterWriteReplyUrl");
		afterWriteReplyUrl = afterWriteReplyUrl.replace("[NEW_REPLY_ID]", id + "");

		if (Util.isEmpty(req.getParameter("afterWriteReplyUrl")) == false) {

			req.setAttribute("replaceUrl", afterWriteReplyUrl);
		}

		return json(req, new ResultData("",""));

	}

}