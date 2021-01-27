<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="메인화면" />
<%@ include file="../../part/head.jspf"%>

<!--
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/usrHomeMain.css" />
<script src="${pageContext.request.contextPath}/static/usrHomeMain.js" defer></script>
-->

<section class="title-bar con-min-width">
	<h1 class="con">
		${pageTitle}
	</h1>
</section>

<section class="section-main-text con-min-width">
	<div class="con">
		<h4>메인화면을 구현하기 위함입니다~~~~~~~</h4>
		<h3>jsp 블로그</h3>
	</div>
</section>

<%@ include file="../../part/foot.jspf"%>