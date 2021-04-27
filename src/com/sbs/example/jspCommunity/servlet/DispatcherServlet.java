package com.sbs.example.jspCommunity.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sbs.example.jspCommunity.App;
import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.dto.Member;
import com.sbs.example.mysqlutil.MysqlUtil;
import com.sbs.example.util.Util;

public abstract class DispatcherServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		run(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

	public void run(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Map<String, Object> doBeforeActionRs = doBeforeAction(req, resp);

		if (doBeforeActionRs == null) {
			return;
		}

		String jspPath = doAction(req, resp, (String) doBeforeActionRs.get("controllerName"), (String) doBeforeActionRs.get("actionMethodName"));

		if (jspPath == null) {
			resp.getWriter().append("jsp 정보가 없습니다.");
			return;
		}

		doAfterAction(req, resp, jspPath);
	}

	private Map<String, Object> doBeforeAction(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setContentType("text/html; charset=UTF-8");

		String requestUri = req.getRequestURI();
		String[] requestUriBits = requestUri.split("/");
		
		int minBitsCount = 5;
		
		if (App.isProductMode()) {
			minBitsCount = 4;
		}
		
		if (requestUriBits.length < minBitsCount) {
			resp.getWriter().append("올바른 요청이 아닙니다.");
			return null;
		}
		
		if (App.isProductMode()) {
			MysqlUtil.setDBInfo("127.0.0.1", "sbsstLocal", "sbs123414", "jspCommunity");
		} else {
			MysqlUtil.setDBInfo("127.0.0.1", "sbsst", "sbs123414", "jspCommunity");
			MysqlUtil.setDevMode(false);
		}
		
		req.setAttribute("appUrl", App.getAppUrl());
		
		int controllerTypeNameIndex = 2;
		int controllerNameIndex = 3;
		int actionMethodNameIndex = 4;
		
		if (App.isProductMode()) {
			controllerTypeNameIndex = 1;
			controllerNameIndex = 2;
			actionMethodNameIndex = 3;
		}
		
		String controllerTypeName = requestUriBits[controllerTypeNameIndex];
		String controllerName = requestUriBits[controllerNameIndex];
		String actionMethodName = requestUriBits[actionMethodNameIndex];

		String actionUrl = "/" + controllerTypeName + "/" + controllerName + "/" + actionMethodName;

		// 데이터 추가 인터셉터 시작
		boolean isLogined = false;
		int loginedMemberId = 0;
		Member loginedMember = null;
		Boolean waringPw = false;

		HttpSession session = req.getSession();

		if (session.getAttribute("loginedMemberId") != null) {
			isLogined = true;
			loginedMemberId = (int) session.getAttribute("loginedMemberId");
			loginedMember = Container.memberService.getMemberById(loginedMemberId);
			
			String value = Container.attrService.getValue("member__"+ loginedMemberId+"__extra__isUsingTempPassword");
			if (value.equals("1")) {
				waringPw = true;
			}
		}
		
		req.setAttribute("waringPw", waringPw);
		req.setAttribute("isLogined", isLogined);
		req.setAttribute("loginedMemberId", loginedMemberId);
		req.setAttribute("loginedMember", loginedMember);
		
		// http://localhost:8083/jspCommunity/usr/member/login?dummy 에서
		// jspCommunity/usr/member/login 이 requestUri 로 반환
		String currentUrl = req.getRequestURI();
		
		// getQueryString 은 ? 를 반환
		if (req.getQueryString() != null) {
			currentUrl += "?" + req.getQueryString();
		}
		
		// requestUri 뒤에 변수까지인지 변수 이전까지인지 확인하기 위해 encoded 필요
		String encodedCurrentUrl = Util.getUrlEncoded(currentUrl);
		
		req.setAttribute("currentUrl", currentUrl);
		req.setAttribute("encodedCurrentUrl",encodedCurrentUrl);
		
		Map<String, Object> param = Util.getParamMap(req);

		String paramJson = Util.getJsonText(param);
		
		req.setAttribute("paramMap", param);
		req.setAttribute("paramJson", paramJson);
		// 데이터 추가 인터셉터 끝

		// 로그인 필요 필터링 인터셉터 시작
		List<String> needToLoginActionUrls = new ArrayList<>();

		needToLoginActionUrls.add("/usr/member/doLogout");
		needToLoginActionUrls.add("/usr/member/modify");
		needToLoginActionUrls.add("/usr/member/doModify");
		needToLoginActionUrls.add("/usr/member/showMine");

		needToLoginActionUrls.add("/usr/member/showCheckLoginPw");
		needToLoginActionUrls.add("/usr/member/doCheckLoginPw");
		needToLoginActionUrls.add("/usr/member/doMailAuth");
		needToLoginActionUrls.add("/usr/member/doCheckByEmail");
		needToLoginActionUrls.add("/usr/member/doReissuanceAuthCode");
		
		needToLoginActionUrls.add("/usr/article/write");
		needToLoginActionUrls.add("/usr/article/doWrite");
		needToLoginActionUrls.add("/usr/article/modify");
		needToLoginActionUrls.add("/usr/article/doModify");
		needToLoginActionUrls.add("/usr/article/doDelete");
		needToLoginActionUrls.add("/usr/article/dolikeArticle");
		needToLoginActionUrls.add("/usr/article/doDislikeArticle");		
		
		needToLoginActionUrls.add("/usr/like/doLike");
		needToLoginActionUrls.add("/usr/like/doCancleLike");
		needToLoginActionUrls.add("/usr/like/doDislike");
		needToLoginActionUrls.add("/usr/like/doCancelDislike");
		
		needToLoginActionUrls.add("/usr/reply/doWrite");
		needToLoginActionUrls.add("/usr/reply/modify");
		needToLoginActionUrls.add("/usr/reply/doModify");
		needToLoginActionUrls.add("/usr/reply/doDelete");
		
		if (needToLoginActionUrls.contains(actionUrl)) {
			if ((boolean) req.getAttribute("isLogined") == false) {
				req.setAttribute("alertMsg", "로그인 후 이용해주세요.");
				req.setAttribute("replaceUrl", "../member/login?afterLoginUrl="+ encodedCurrentUrl);

				RequestDispatcher rd = req.getRequestDispatcher(getJspDirPath() + "/common/redirect.jsp");
				rd.forward(req, resp);
			}
		}

		// 로그인 필요 필터링 인터셉터 끝

		// 로그아웃 필요 필터링 인터셉터 시작
		List<String> needToLogoutActionUrls = new ArrayList<>();

		needToLogoutActionUrls.add("/usr/member/login");
		needToLogoutActionUrls.add("/usr/member/doLogin");
		needToLogoutActionUrls.add("/usr/member/join");
		needToLogoutActionUrls.add("/usr/member/doJoin");
		needToLogoutActionUrls.add("/usr/member/findLoginId");
		needToLogoutActionUrls.add("/usr/member/doFindLoginId");
		needToLogoutActionUrls.add("/usr/member/findLoginPw");
		needToLogoutActionUrls.add("/usr/member/doFindLoginPw");

		if (needToLogoutActionUrls.contains(actionUrl)) {
			if ((boolean) req.getAttribute("isLogined")) {
				req.setAttribute("alertMsg", "로그아웃 후 이용해주세요.");
				req.setAttribute("historyBack", true);

				RequestDispatcher rd = req.getRequestDispatcher(getJspDirPath() + "/common/redirect.jsp");
				rd.forward(req, resp);
			}
		}

		// 로그아웃 필요 필터링 인터셉터 끝

		Map<String, Object> rs = new HashMap<>();
		rs.put("controllerName", controllerName);
		rs.put("actionMethodName", actionMethodName);

		return rs;
	}

	protected abstract String doAction(HttpServletRequest req, HttpServletResponse resp, String controllerName, String actionMethodName);

	private void doAfterAction(HttpServletRequest req, HttpServletResponse resp, String jspPath) throws ServletException, IOException {
		MysqlUtil.closeConnection();

		RequestDispatcher rd = req.getRequestDispatcher(getJspDirPath() + "/" + jspPath + ".jsp");
		rd.forward(req, resp);
	}
	
	private String getJspDirPath() {
		return "/WEB-INF/jsp";
	}
}