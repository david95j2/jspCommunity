<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="${article.extra__boardName} 게시물 상세페이지" />
<%@ include file="../../part/head.jspf"%>

<div class="title-bar padding-0-10 con-min-width">
	<h1 class="con">
		<span>
			<i class="fas fa-newspaper"></i>
		</span>
		<span>${pageTitle}</span>
	</h1>
</div>

<div class="article-detail-box detail-box padding-0-10 con-min-width">
	<div class="con">
		<table>
			<colgroup>
				<col width="150">
			</colgroup>
			<tbody>
				<tr>
					<th>
						<span>제목</span>
					</th>
					<td>
						<div>${article.title}</div>
					</td>
				</tr>
				<tr>
					<th>
						<span>작성날짜</span>
					</th>
					<td>
						<div>${article.regDate}</div>
					</td>
				</tr>
				<tr>
					<th>
						<span>작성자</span>
					</th>
					<td>
						<div>${article.extra__writer}</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="toast-viewer-css">
							<script type="text/x-template">${article.body}</script>
							<div class="toast-ui-viewer"></div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>

<div class="article-btn-box padding-0-10 con-min-width">
	<div class="con btn-wrap">
		<c:if test="${article.extra.actorCanLike}">
			<a class="btn btn-primary hov-red" href="../like/doLike?relTypeCode=article&relId=${article.id}&redirectUrl=${encodedCurrentUrl}"
			 onclick="if ( !confirm('`좋아요` 처리 하시겠습니까?') ) return false;">
				<span><i class="far fa-thumbs-up"></i></span>
				<span>${article.extra__likeOnlyPoint}</span>
			</a>
		</c:if>
		
		<c:if test="${article.extra.actorCanCancelLike}">
			<a class="btn btn-info hov-red" href="../like/doCancelLike?relTypeCode=article&relId=${article.id}&redirectUrl=${encodedCurrentUrl}"
			 onclick="if ( !confirm('`좋아요`를 취소 처리 하시겠습니까?') ) return false;">
				<span><i class="fas fa-thumbs-up"></i></span>
				<span>${article.extra__likeOnlyPoint}</span>
			</a>
		</c:if>
		
		<c:if test="${article.extra.actorCanDislike}">
			<a class="btn btn-danger hov-red" href="../like/doDislike?relTypeCode=article&relId=${article.id}&redirectUrl=${encodedCurrentUrl}" onclick="if ( !confirm('`싫어요` 처리 하시겠습니까?') ) return false;">
				<span><i class="far fa-thumbs-down"></i></span>
				<span>${article.extra__dislikeOnlyPoint}</span>
			</a>
		</c:if>
		
		<c:if test="${article.extra.actorCanCancelDislike}">
			<a class="btn btn-info hov-red" href="../like/doCancelDislike?relTypeCode=article&relId=${article.id}&redirectUrl=${encodedCurrentUrl}"
			 onclick="if ( !confirm('`싫어요`를 취소 처리 하시겠습니까?') ) return false;">
				<span><i class="fas fa-thumbs-down"></i></span>
				<span>${article.extra__dislikeOnlyPoint}</span>
			</a>
		</c:if>
		
		<a class="btn btn-info hov-red" href="${param.listUrl}">리스트</a>
		<a class="btn btn-info hov-red" href="modify?id=${article.id}">수정</a>
		<a class="btn btn-danger hov-red" onclick="if ( confirm('정말 삭제하시겠습니까?') == false ) { return false; }"
		href="doDelete?id=${article.id}">삭제</a>
	</div>
</div>

<%@ include file="../../part/foot.jspf"%>