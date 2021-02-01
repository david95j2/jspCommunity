<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="Main page" />
<%@ include file="../../part/head.jspf"%>

<!--
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/usrHomeMain.css" />
<script src="${pageContext.request.contextPath}/static/usrHomeMain.js" defer></script>
-->

<section class="title-bar__main-page">
	<h1 class="con">
		${pageTitle}
	</h1>
</section>

<section class="section-main-text">
	<div class="con section-main-text__box">
		<h4 class="section-main-text__head">이곳은 메인페이지입니다. Have a nice day!!!!!!!!</h4>
		<c:if test="${isLogined}">
			<div class="section-main-text__nickname">			
				아이디 : ${loginedMember.loginId}
				<br>
				<hr>
				로그인된 회원의 닉네임 : ${loginedMember.nickname} 님 반갑습니다.
				<hr>
			</div>
			<div class="section-main-text__link">
				<a href="../article/write?boardId=1">공지사항 글쓰기</a>
				<a href="../article/write?boardId=2">자유게시판 글쓰기</a>
				<a href="../member/modify">회원정보수정</a>
				<a href="../member/doLogout">로그아웃</a>
			</div>
		</c:if>

	</div>
</section>

<%@ include file="../../part/foot.jspf"%>