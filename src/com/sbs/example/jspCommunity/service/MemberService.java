package com.sbs.example.jspCommunity.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.sbs.example.jspCommunity.App;
import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dao.MemberDao;
import com.sbs.example.jspCommunity.dto.Attr;
import com.sbs.example.jspCommunity.dto.Member;
import com.sbs.example.jspCommunity.dto.ResultData;
import com.sbs.example.util.Util;

public class MemberService {

	private MemberDao memberDao;
	private EmailService emailService;
	private AttrService attrService;
	
	public MemberService() {
		memberDao = Container.memberDao;
		emailService = Container.emailService;
		attrService = Container.attrService;
	}

	public List<Member> getForPrintMembers() {
		return memberDao.getForPrintMembers();
	}

	public int join(Map<String, Object> args) {
		int id = memberDao.join(args);
		
		setLoginPwModifiedNow(id);
		
		return id;
	}
	
	public void removeMember(int id) {
		memberDao.removeMember(id);
	}

	public Member getMemberByLoginId(String loginId) {
		return memberDao.getMemberByLoginId(loginId);
	}

	public Member getMemberById(int id) {
		return memberDao.getMemberById(id);
	}

	public Member getMemberByNameAndEmail(String name, String email) {
		return memberDao.getMemberByNameAndEmail(name, email);
	}

	public ResultData sendTempLoginPwToEmail(Member actor) {
		// 메일 제목과 내용 만들기
		String siteName = App.getSiteName();
		String siteLoginUrl = App.getLoginUrl();
		String title = "[" + siteName + "] 임시 패스워드 발송";
		String tempPassword = Util.getTempPassword(6);
		String body = "<h1>임시 패스워드 : " + tempPassword + "</h1>";
		body += "<a href=\"" + siteLoginUrl + "\" target=\"_blank\">로그인 하러가기</a>";

		Map<String, Object> rs = new HashMap<>();

		// 메일 발송
		int sendRs = emailService.send(actor.getEmail(), title, body);

		if (sendRs != 1) {
			return new ResultData("F-1", "메일발송에 실패하였습니다.");
		}

		setTempPassword(actor, tempPassword);

		String resultMsg = String.format("고객님의 새 임시 패스워드가 %s (으)로 발송되었습니다.", actor.getEmail());
		return new ResultData("S-1", resultMsg, "email", actor.getEmail());
	}

	private void setTempPassword(Member actor, String tempPassword) {
		Map<String, Object> modifyParam = new HashMap<>();
		modifyParam.put("id", actor.getId());
		modifyParam.put("loginPw", Util.sha256(tempPassword));
		modify(modifyParam);
		
		attrService.setValue("member__"+actor.getId()+"__extra__isUsingTempPassword","1",null);
	}
	
	public void setIsUsingTempPassword(int actorId, boolean use) {
		attrService.setValue("member__" + actorId + "__extra__isUsingTempPassword", use, null);
	}
	
	public boolean isUsingTempPassword(int actorId) {
		return attrService.getValueAsBoolean("member__" + actorId + "__extra__isUsingTempPassword");
	}

	public void modify(Map<String, Object> param) {
		if (param.get("loginPw") != null) {
			setLoginPwModifiedNow((int)param.get("id"));
		}
		
		memberDao.modify(param);
	}

	private void setLoginPwModifiedNow(int actorId) {
		attrService.setValue("member__" + actorId + "__extra__loginPwModifiedDate", Util.getNowDateStr(), null);
	}
	
	public int getOldPasswordDays() {
		return 90;
	}

	public boolean isNeedToModifyOldLoginPw(int actorId) {
		String date = attrService.getValue("member__" + actorId + "__extra__loginPwModifiedDate");
		
		if ( Util.isEmpty(date) ) {
			return false;
		}
		
		// 얼마나 경과했는지 초단위로 알려줌.
		int pass = Util.getPassedSecondsFrom(date);
		
		// 기준일 가지고 와
		int oldPasswordDays = getOldPasswordDays();
		
		// date > 기준(90일) * 60초 * 60분 * 24시간
		if ( pass > oldPasswordDays * 60 * 60 * 24 ) {
			return true;
		}
		
		return false;
	}
	
	public boolean isAdmin(int memberId) {
		//return memberId == 1;

		return false;
	}
	
	
	
	public boolean isValidAuthCode(int actorId,String authCode) {
		String authCodeOnDB = attrService.getValue("member__"+actorId+"__extra__examineAuthCode");
		
		return authCodeOnDB.equals(authCode);
	}

	public String getAuthCode(int actorId) {
		String authCode = UUID.randomUUID().toString();
		attrService.remove("member__"+actorId+"__extra__examineAuthCode");
		attrService.setValue("member__"+actorId+"__extra__examineAuthCode", authCode, null);
		
		return authCode;
	}
	
	public ResultData sendAuthCodeToEmail(int actorId,String authCode,String email) {
		// 메일 제목과 내용 만들기
		String siteName = App.getSiteName();
		String title = "[" + siteName + "] 메일 인증 확인";
		String body = "<h1 style=\"font-weight: bold\">CHILLAX 메일 인증</h1>";
		body += "</br><a href=\"http://localhost:8083/jspCommunity/usr/member/doCheckByEmail?email="+email
				+"&code="+authCode+"&memberId="+actorId+"\" target=\"_blank\">인증하기</a>";
		
		Map<String, Object> rs = new HashMap<>();
		
		// 메일 발송
		int sendRs = emailService.send(email, title, body);

		if (sendRs != 1) {
			return new ResultData("F-1", "메일발송에 실패하였습니다.");
		}

		String resultMsg = String.format("인증메일이 %s (으)로 발송되었습니다.", email);
		return new ResultData("S-1", resultMsg, "email", email);
	}

	public boolean isLoginCodeConfirm(int actorId, String authCode, String email) {
		Attr attr = attrService.get("member__"+actorId+"__extra__examineAuthCode",authCode);
		
		if (!attr.getValue().equals(authCode)) {
			return false;
		}
		
		attrService.setValue("member__"+actorId+"__extra__emailAuthed", email, null);
		memberDao.changeMemberAuthStatus(actorId);
		
		return true;
	}

	public int doReissuanceAuthCode(int actorId, String email) {
		String authCode = UUID.randomUUID().toString();
		sendAuthCodeToEmail(actorId,authCode,email);
		
		return attrService.setValue("member__"+actorId+"__extra__examineAuthCode", authCode, null);
	}

	public void resetAuthStatus(int actorId) {
		memberDao.resetAuthStatus(actorId);
	}
}