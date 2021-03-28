<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.sbs.example.jspCommunity.dto.Article"%>

<%@ page import="com.sbs.example.jspCommunity.dto.Reply"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="${article.extra__boardName} 게시물 상세페이지" />
<%@ include file="../../part/head.jspf"%>

<script>
function doLikeBtn(){
	const memberId = ${article.memberId};
	const articleId = ${article.id};
	$.get(
			"doLikeArticle",
			{
				memberId,
				articleId
			},
			function(data) {
			if(data.success){
				$('.articleDetailBody__likeBtn > i').attr('class','fas fa-thumbs-up');
			} else{
				$('.articleDetailBody__likeBtn > i').attr('class','far fa-thumbs-up');
			  }
			},
			"json"
		);
}
function doDislikeBtn(){
	const memberId = ${article.memberId};
	const articleId = ${article.id};
	$.get(
			"doDislikeArticle",
			{
				memberId,
				articleId
			},
			function(data) {
			if(data.success){
				$('.articleDetailBody__dislikeBtn > i').attr('class','fas fa-thumbs-down');
			} else{
				$('.articleDetailBody__dislikeBtn > i').attr('class','far fa-thumbs-down');
			  }
			},
			"json"
		);
}

let DoWriteForm__submited = false;
function writeFormCheck(el) {
	if ( DoWriteForm__submited ) {
		alert('처리중입니다.');
		return false;
	}
	
	
	const editor = $(el).find('.toast-ui-editor').data('data-toast-editor');
	const body = editor.getMarkdown().trim();
	
	if ( body.length == 0 ) {
		alert('내용을 입력해주세요.');
		editor.focus();
		
		return false;
	}
	
	writeReplyForm.body.value = body;
	
	return true;
}

function modifyFormOpen(el){
	const form = $(el).parents().parents().siblings('.articleDetailBox__reply-modify');
	$(form).css({
		'display':'block',
		'margin-top':'15px'
		});
}

let DoModifyForm__submited = false;
function modifyFormCheck(el) {
	if ( DoModifyForm__submited ) {
		alert('처리중입니다.');
		return false;
	}
	
	
	const editor = $(el).find('.toast-ui-editor').data('data-toast-editor');
	const body = editor.getMarkdown().trim();
	
	if ( body.length == 0 ) {
		alert('내용을 입력해주세요.');
		editor.focus();
		
		return false;
	}
	
	$(el).closest('form').get(0).body.value = body;
	
	return true;
}
</script>

<div class="title-bar padding-0-10 con-min-width">
	<h1 class="con">
		<span>${article.title}</span>
	</h1>
</div>

<!-- 게시물 상세 박스 시작 -->
<div class="article-detail-box detail-box padding-0-10 con-min-width">
	<div class="con">
		<table>
			<colgroup>
				<col width="150">
			</colgroup>
			<tbody>
				<tr>
					<th><span>작성날짜</span></th>
					<td>
						<div>${article.regDate}</div>
					</td>
				</tr>
				<tr>
					<th><span>작성자</span></th>
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
<!-- 게시물 상세 박스 끝 -->

<!-- 게시물 버튼 박스 시작 -->
<div class="article-btn-box padding-0-10 con-min-width">
	<div class="btn articleDetailBody__likeBtn" onclick="doLikeBtn();">
	<c:if test="${isLikedArticle == true }">
  		<i class="fas fa-thumbs-up"></i>
  	</c:if>
	<c:if test="${isLikedArticle == false }">  
  		<i class="far fa-thumbs-up"></i>
  	</c:if>
  	</div>
  	<div class="btn articleDetailBody__dislikeBtn" onclick="doDislikeBtn();">
  	<c:if test="${isLikedArticle == true }">
  		<i class="fas fa-thumbs-down"></i>
  	</c:if>
  	<c:if test="${isLikedArticle == false }">  
  		<i class="far fa-thumbs-down"></i>
  	</c:if>
  	</div>
	<a class="btn btn-info hov-red" href="${param.listUrl}">리스트</a> <a
		class="btn btn-info hov-red" href="modify?id=${article.id}">수정</a> <a
		class="btn btn-danger hov-red"
		onclick="if ( confirm('정말 삭제하시겠습니까?') == false ) { return false; }"
		href="doDelete?id=${article.id}">삭제</a>
</div>
<!-- 게시물 버튼 박스 끝 -->

<!-- 댓글 입력 창 시작 -->
<div class="articleDetailBox__reply">
	
<!-- 댓글 입력 창(로그인 안했을 때) -->
	<c:if test="${isLogined == false }">
	<div class="flex flex-dir-col flex-jc-c flex-ai-c articleDetailBox__reply-isNotLogined">
		<div class="articleDetailBox__reply-isNotLogined__text">로그인한 회원만 댓글을 작성할 수 있습니다.</div>
		<c:url value="/usr/member/login" var="url">
			<c:param name="afterLoginUrl" value="${currentUrl }"/>
		</c:url>
		<a href="${url }">로그인</a>
	</div>
	</c:if>
		
	<!-- 댓글 입력 창(로그인 했을 때) -->
	<c:if test="${isLogined }">
	<div class="articleDetailBox__reply-isLogined">
		<form name="writeReplyForm" class="articleDetailBox__reply-form" action="../reply/doWrite" method="POST" onsubmit="return writeFormCheck(this);">
			<input type="hidden" name="body">
			<input type="hidden" name="memberId" value="${sessionScope.loginedMemberId }">
			<input type="hidden" name="articleId" value="${article.id }">
			<input type="hidden" name="afterWriteReplyUrl" value="${currentUrl }">
		<div class="writeReplyBodyInput">
			 <script type="text/x-template"></script>
	  		<div class="toast-ui-editor"></div>
	  	</div>
	  	<button class="submitWriteReply">등록</button>
	  	</form>
	</div>
	</c:if>
</div>


<div class="title-bar padding-0-10 con-min-width">
	<h1 class="con">
		<span> <i class="fas fa-newspaper"></i>
		</span> <span>댓글작성</span>
	</h1>
</div>

<c:if test="${isLogined == false}">
	<div
		class="article-reply-write-form-box form-box padding-0-10 con-min-width">
		<div class="con">
			<a class="udl hover-link"
				href="../member/login?afterLoginUrl=${encodedCurrentUrl}">로그인</a> 후
			이용해주세요.
		</div>
	</div>
</c:if>

<!-- 댓글 쓰기 폼 시작 -->
<div class="article-reply-write-form-box form-box padding-0-10 con-min-width">
	<form class="con" action="../reply/doWrite" method="POST"
		onsubmit="Reply__DoWriteForm__submit(this); return false;">
		<input type="hidden" name="redirectUrl" value="${currentUrl}" /> <input
			type="hidden" name="relTypeCode" value="article" /> <input
			type="hidden" name="relId" value="${article.id}" /> <input
			type="hidden" name="body" />

		<table>
			<colgroup>
				<col width="150">
			</colgroup>
			<tbody>
				<tr>
					<th><span>내용</span></th>
					<td>
						<div>
							<div>
								<script type="text/x-template"></script>
								<div class="toast-ui-editor" data-height="200"></div>
							</div>
						</div>
					</td>
				</tr>

				<tr>
					<th><span>작성</span></th>
					<td>
						<div>
							<div class="btn-wrap">
								<input class="btn btn-primary" type="submit" value="작성" />
								<button class="btn btn-info" type="button"
									onclick="history.back();">뒤로가기</button>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>


<div class="reply-list-box article-list-box padding-0-10 con-min-width">
	<div class="con">
		<table>
			<colgroup>
				<col width="50">
				<col width="150">
				<col width="100">
				<col width="100">
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>
					<th>날짜</th>
					<th>작성자</th>
					<th>좋아요</th>
					<th>내용</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${replies}" var="reply">
					<tr>
						<td><span class="article-list-box__id">${reply.id}</span></td>
						<td><span class="article-list-box__reg-date">${reply.regDate}</span>
						</td>
						<td><span class="article-list-box__writer">${reply.extra__writer}</span>
						</td>
						<td><span class="article-list-box__likeOnlyPoint"> <span>
									<i class="far fa-thumbs-up"></i>
							</span> <span> ${reply.extra__likeOnlyPoint} </span>
						</span> <span class="article-list-box__dislikeOnlyPoint"> <span>
									<i class="far fa-thumbs-down"></i>
							</span> <span> ${reply.extra__dislikeOnlyPoint} </span>
						</span></td>
						<td><script type="text/x-template">${reply.body}</script>
							<div class="toast-ui-viewer"></div></td>
						<td>
							<div class="btn-wrap">
								<a class="btn btn-info hov-red"
									href="../reply/modify?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">수정</a>
								<a class="btn btn-danger hov-red"
									onclick="if ( confirm('정말 삭제하시겠습니까?') == false ) { return false; }"
									href="../reply/doDelete?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">삭제</a>
							</div>
						</td>
						<td class="visible-sm-down">
							<div class="flex">
								<span class="article-list-box__id article-list-box__id--mobile">${reply.id}</span>
							</div>

							<div class="flex">
								<span class="article-list-box__likeOnlyPoint"> <span>
										<i class="far fa-thumbs-up"></i>
								</span> <span> ${reply.extra__likeOnlyPoint} </span>
								</span> <span class="article-list-box__dislikeOnlyPoint"> <span>
										<i class="far fa-thumbs-down"></i>
								</span> <span> ${reply.extra__dislikeOnlyPoint} </span>
								</span>
							</div>

							<div class="flex">
								<span
									class="article-list-box__writer article-list-box__writer--mobile">${reply.extra__writer}</span>
								<span>&nbsp;|&nbsp;</span> <span
									class="article-list-box__reg-date article-list-box__reg-date--mobile">${reply.regDate}</span>
							</div>
							<div>
								<script type="text/x-template">${reply.body}</script>
								<div class="toast-ui-viewer"></div>
							</div>
							<div class="btn-wrap">
								<a class="btn btn-info hov-red"
									href="../reply/modify?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">수정</a>
								<a class="btn btn-danger hov-red"
									onclick="if ( confirm('정말 삭제하시겠습니까?') == false ) { return false; }"
									href="../reply/doDelete?id=${reply.id}&redirectUrl=${encodedCurrentUrl}">삭제</a>
							</div>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>

<%@ include file="../../part/foot.jspf"%>