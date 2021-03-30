package com.sbs.example.jspCommunity.service;

import java.util.List;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dao.ReplyDao;
import com.sbs.example.jspCommunity.dto.Reply;

public class ReplyService {

	private ReplyDao replyDao;
	private MemberService memberService;

	public ReplyService() {
		replyDao = Container.replyDao;
		memberService = Container.memberService;
	}

	public List<Reply> getForPrintReplies(String relTypeCode, int relId) {
		return replyDao.getForPrintReplies(relTypeCode, relId);
	}

	public Reply getReply(int id) {
		return replyDao.getReply(id);
	}

	public boolean actorCanDelete(Reply reply, int actorId) {
		if (memberService.isAdmin(actorId)) {
			return true;
		}

		return reply.getMemberId() == actorId;
	}

	public int doWriteArticleReply(int articleId, String body, int memberId) {
		return replyDao.doWriteArticleReply(articleId,body,memberId);
	}
	
	// id 번인 게시물 댓글 불러오기
	public List<Reply> getArticleReplysByArticleId(int id) {
		return replyDao.getArticleReplysByArticleId(id);
	}

	public void doModifyArticleReply(int id, int articleId, String body, int memberId) {
		replyDao.doModifyArticleReply(id,articleId,body,memberId);
	}

	public void doDeleteArticleReply(int id, int articleId) {
		replyDao.doDeleteArticleReply(id,articleId);
	}

}