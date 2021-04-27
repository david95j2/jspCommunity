<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="회원 목록" />
<%@ include file="../../part/head.jspf"%>

<h1>${pageTitle}</h1>

<div>
	총 게시물 수 : ${totalCount}
</div>

<c:forEach var="member" items="${members}">
	<div>
		번호 : ${member.id}
		<br />
		이름 : ${member.name}
		<br />
		닉네임 : ${member.nickname}
		<hr />
	</div>
</c:forEach>

<%@ include file="../../part/foot.jspf"%>