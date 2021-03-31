package com.sbs.example.jspCommunity.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dto.Reply;
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

	
	public String doLikeReply(HttpServletRequest request, HttpServletResponse response) {

		int memberId = Integer.parseInt(request.getParameter("memberId"));
		int id = Integer.parseInt(request.getParameter("replyId"));

		boolean isLikedReply = replyService.isLikedReply(id, memberId);
		int likeCount = 0;
		Reply reply = null;
		String resultCode = null;
		Map<String,Object> map = new HashMap<>();
		
		if (isLikedReply) {
			replyService.doDeleteReplyLike(id,memberId);
			reply = replyService.getReplyById(id);
			likeCount = reply.getExtra__likeCount();
			resultCode = "F-1";
			map.put("replyLikeCount", likeCount);
		} else {
			replyService.doIncreaseReplyLike(id,memberId);
			reply = replyService.getReplyById(id);
			likeCount = reply.getExtra__likeCount();
			resultCode = "S-1";
			map.put("replyLikeCount", likeCount);
		}

		return json(request, new ResultData(resultCode, "", map));

	}

	public String doDisLikeReply(HttpServletRequest request, HttpServletResponse response) {
		int memberId = Integer.parseInt(request.getParameter("memberId"));
		int id = Integer.parseInt(request.getParameter("replyId"));

		boolean isDisLikedReply = replyService.isDisLikedReply(id, memberId);
		int likeCount = 0;
		Reply reply = null;
		String resultCode = null;
		Map<String,Object> map = new HashMap<>();
		
		if (isDisLikedReply) {
			replyService.doDeleteReplyDisLike(id,memberId);
			reply = replyService.getReplyById(id);
			likeCount = reply.getExtra__dislikeCount();
			resultCode = "F-1";
			map.put("replyDislikeCount", likeCount);
		} else {
			replyService.doIncreaseReplyDisLike(id,memberId);
			reply = replyService.getReplyById(id);
			likeCount = reply.getExtra__dislikeCount();
			resultCode = "S-1";
			map.put("replyDislikeCount", likeCount);
		}

		return json(request, new ResultData(resultCode, "", map));

	}	

	public String doWriteReplyReply(HttpServletRequest request, HttpServletResponse response) {

		String body = request.getParameter("body");
		int memberId = Integer.parseInt(request.getParameter("memberId"));
		int replyId = Integer.parseInt(request.getParameter("replyId"));
		String relType = "reply";
		int articleId = Integer.parseInt(request.getParameter("articleId"));
		
		int newReplyId = replyService.doWriteReply(relType, replyId, body, memberId, articleId);

		String afterWriteReplyUrl = request.getParameter("afterWriteReplyUrl");
		afterWriteReplyUrl = afterWriteReplyUrl.replace("[NEW_REPLY_ID]", newReplyId + "");

		if (Util.isEmpty(request.getParameter("afterWriteReplyUrl")) == false) {

			request.setAttribute("replaceUrl", afterWriteReplyUrl);
		}
		
		return json(request,new ResultData("",""));
	}

	public String doModifyReplyReply(HttpServletRequest request, HttpServletResponse response) {

		String body = request.getParameter("body");
		int memberId = Integer.parseInt(request.getParameter("memberId"));
		int id = Integer.parseInt(request.getParameter("replyId"));

		replyService.doModifyReplyReply(id, body, memberId);

		String afterWriteReplyUrl = request.getParameter("afterWriteReplyUrl");
		afterWriteReplyUrl = afterWriteReplyUrl.replace("[NEW_REPLY_ID]", id + "");

		if (Util.isEmpty(request.getParameter("afterWriteReplyUrl")) == false) {

			request.setAttribute("replaceUrl", afterWriteReplyUrl);
		}

		return json(request,new ResultData("",""));

	}

	public String doDeleteReplyReply(HttpServletRequest request, HttpServletResponse response) {
		
		int id = Integer.parseInt(request.getParameter("id"));
		int articleId = Integer.parseInt(request.getParameter("articleId")); 

		replyService.doDeleteReplyReply(id,articleId);

		if (Util.isEmpty(request.getParameter("afterWriteReplyUrl")) == false) {

			request.setAttribute("replaceUrl", request.getParameter("afterWriteReplyUrl"));
		}

		return "common/redirect";
	}

	public String getReplies(HttpServletRequest request, HttpServletResponse response) {		
		List<Reply> replies = replyService.getReplies();
		return json(request, new ResultData("S-1","",replies));
	}
}