<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.sbs.example.util.Util"%>
<%@ page import="com.sbs.example.jspCommunity.dto.Article"%>

<%@ page import="com.sbs.example.jspCommunity.dto.Reply"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="${article.extra__boardName} 게시물 상세페이지" />
<%@ include file="../../part/head.jspf"%>


<script>
let DoWriteForm__submited = false;
function writeFormCheck(el) {
	if ( DoWriteForm__submited ) {
		alert('처리중입니다.');
		return false;
	}
	
	const editor = $(el).find('.toast-ui-editor').data('data-toast-editor');
	const body = editor.getMarkdown().trim();
	
	const memberId = writeReplyForm.memberId.value;
	const articleId = writeReplyForm.articleId.value;
	const afterWriteReplyUrl = writeReplyForm.afterWriteReplyUrl.value;	
	
	if ( body.length == 0 ) {
		alert('내용을 입력해주세요.');
		editor.focus();
		
		return false;
	}
	
	writeReplyForm.body.value = body;
	
	$.get(
			"${appUrl}/usr/reply/doWrite",
			{
				body : writeReplyForm.body.value,
				memberId,
				articleId,
				afterWriteReplyUrl
			},
			function(data) {
			loadRepliesList();
			$('.toast-ui-editor').html('');
			EditorViewer__init();
			Editor__init();	
			},
			"json"
		);
	
	return false;
}
</script>

<script>
	let writeReplyReplyForm__submited = false;
	
	function replyReplyFormCheck(el){
	
	if ( writeReplyReplyForm__submited ) {
		alert('처리중입니다.');
		return false;
	}
	
	
	const editor = $(el).find('.toast-ui-editor').data('data-toast-editor');
	const body = editor.getMarkdown().trim();
	
	$(el).closest('form').get(0).body.value = body;
	
	if ( body.length == 0 ) {
		alert('내용을 입력해주세요.');
		editor.focus();		
		return false;
	}
	
	
	$.get(
			"${appUrl}/usr/reply/doWrite",
			{
				body,
				replyId : $(el).closest('form').get(0).replyId.value,
				memberId : $(el).closest('form').get(0).memberId.value,
				articleId : $(el).closest('form').get(0).articleId.value,
				afterWriteReplyUrl : $(el).closest('form').get(0).afterWriteReplyUrl.value
			},
			function(data) {
			loadRepliesList();
			},
			"json"
		);
		return false;
	
	}
</script>

<script>
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

function modifyReplyCancel(el){
	const form = $(el).parents().parents('.articleDetailBox__reply-modify');
		$(form).css('display','none');
}
</script>

<script>
	$(function() {
		if ( param.focusReplyId ) {
			const $target = $('.articleDetailBox__articleReplyList__reply[data-id="' + param.focusReplyId + '"]');
			$target.addClass('focus');
		
			setTimeout(function() {
				const targetOffset = $target.offset();
				
				$(window).scrollTop(targetOffset.top - 100);
				
				setTimeout(function() {
					$target.removeClass('focus');
				}, 1000);
			}, 1000);
		}
	});
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

<script>
function doLikeBtn(){
	const memberId = ${loginedMemberId};
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
				$('.articleDetailInfo-box2__likeCount').text(data.extra__likeOnlyPoint);				
			} else{
				$('.articleDetailBody__likeBtn > i').attr('class','far fa-thumbs-up');
				$('.articleDetailInfo-box2__likeCount').text(data.extra__likeOnlyPoint);				
			  }
			},
			"json"
		);
}
function doDislikeBtn(){
	const memberId = ${loginedMemberId};
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
				$('.articleDetailInfo-box2__dislikeCount').text(data.extra__dislikeOnlyPoint);
			} else{
				$('.articleDetailBody__dislikeBtn > i').attr('class','far fa-thumbs-down');
				$('.articleDetailInfo-box2__dislikeCount').text(data.extra__dislikeOnlyPoint);
			  }
			},
			"json"
		);
}
</script>

<!-- 게시물 버튼 박스 시작 -->
<div class="con article-btn-box padding-0-10 con-min-width">
		<div class="btn articleDetailBody__likeBtn" onclick="doLikeBtn();">
			<c:if test="${isLikedArticle == true }">
		  		<i class="fas fa-thumbs-up"></i>
		  		<span class="articleDetailInfo-box2__likeCount">${article.extra__likeOnlyPoint }</span>
		  	</c:if>
			<c:if test="${isLikedArticle == false }">  
		  		<i class="far fa-thumbs-up"></i>
		  		<span class="articleDetailInfo-box2__likeCount">${article.extra__likeOnlyPoint }</span>
		  	</c:if>
	  	</div>
	  	<div class="btn articleDetailBody__dislikeBtn" onclick="doDislikeBtn();">
		  	<c:if test="${isLikedArticle == true }">
		  		<i class="fas fa-thumbs-down"></i>
		  		<span class="articleDetailInfo-box2__dislikeCount">${article.extra__dislikeOnlyPoint }</span>
		  	</c:if>
		  	<c:if test="${isLikedArticle == false }">  
		  		<i class="far fa-thumbs-down"></i>
		  		<span class="articleDetailInfo-box2__dislikeCount">${article.extra__dislikeOnlyPoint }</span>
		  	</c:if>
	  	</div>
  	<a class="btn btn-info hov-red" href="${param.listUrl}">리스트</a>
	<a class="btn btn-info hov-red" href="modify?id=${article.id}">수정</a>
	<a class="btn btn-danger hov-red" onclick="if ( confirm('정말 삭제하시겠습니까?') == false ) { return false; }"
		href="doDelete?id=${article.id}">삭제</a>
</div>
<!-- 게시물 버튼 박스 끝 -->

<div class="title-bar padding-0-10 con-min-width">
	<h1 class="con">
		<span><i class="fas fa-newspaper"></i></span>
		<span>댓글</span>
	</h1>
</div>

<script>
function doLikeReplyBtn(el,id){
	const memberId = ${loginedMemberId};
	const replyId = id;
	$.get(
			"${appUrl}/usr/reply/doLikeReply",
			{
				memberId,
				replyId
			},
			function(data) {
			if(data.success){
				$(el).children('i').attr('class','fas fa-thumbs-up');
				$(el).children('span').text('좋아요 '+data.body.replyLikeCount);
				}
			else{
				$(el).children('i').attr('class','far fa-thumbs-up');
				$(el).children('span').text('좋아요 '+data.body.replyLikeCount);
				}
			},
			"json"
		);
}
function doDisLikeReplyBtn(el,id){
	const memberId = ${loginedMemberId};
	const replyId = id;
	$.get(
			"${appUrl}/usr/reply/doDisLikeReply",
			{
				memberId,
				replyId
			},
			function(data) {
			if(data.success){
				$(el).children('i').attr('class','fas fa-thumbs-down');
				$(el).children('span').text('싫어요 '+data.body.replyDislikeCount);
				}
			else{
				$(el).children('i').attr('class','far fa-thumbs-down');
				$(el).children('span').text('싫어요 '+data.body.replyDislikeCount);
				}
			},
			"json"
		);
}
</script>

<!-- 댓글 시작 -->
<div class="con articleDetailBox__reply">
	
	<!-- 댓글 입력 창(로그인 안했을 때) -->
	<c:if test="${isLogined == false }">
	<div class="flex flex-di-c flex-jc-c flex-ai-c articleDetailBox__reply-isNotLogined">
		<div class="articleDetailBox__reply-isNotLogined__text">로그인한 회원만 댓글을 작성할 수 있습니다.</div>
		<c:url value="/usr/member/login" var="url">
			<c:param name="afterLoginUrl" value="${currentUrl }"/>
		</c:url>
		<a href="${url }">로그인</a>
	</div>
	</c:if>
	<!-- 댓글 입력 창(로그인 안했을 때) 끝-->
		
	<!-- 댓글 입력 창(로그인 했을 때) -->
	<c:if test="${isLogined }">
		<div class="articleDetailBox__reply-isLogined">
			<form name="writeReplyForm" class="articleDetailBox__reply-form" action="${appUrl }/usr/reply/doWrite"
			 method="POST" onsubmit="return writeFormCheck(this);">
				<input type="hidden" name="body">
				<input type="hidden" name="memberId" value="${sessionScope.loginedMemberId }">
				<input type="hidden" name="articleId" value="${article.id }">
				<input type="hidden" name="afterWriteReplyUrl" value="${Util.getNewUrl(currentUrl, 'focusReplyId', '[NEW_REPLY_ID]')}">
				<div class="writeReplyBodyInput">
					 <script type="text/x-template"></script>
			  		 <div class="toast-ui-editor"></div>
			  	</div>
			  	<button class="btn-square writeReplyBodyInput">등록</button>
		  	</form>
		</div>
	</c:if>
	<!-- 댓글 입력 창(로그인 했을 때) 끝-->
	
	<!-- 댓글 리스트 시작-->
	<div class="articleDetailBox__articleReplyList">
	
		<!-- 전체 댓글 수 정보 시작 -->
		<div class="articleDetailBox__articleReplyList__info">
			<span>전체 댓글 수</span>
			<span>${totalReplyCount }</span>
		</div>
		<!-- 전체 댓글 수 정보 끝 -->
		
		<!-- 댓글 리스트 본문 시작 --> 
		<div class="articleDetailBox__articleReplyList__replies">
			<c:forEach var="reply" items="${replies }">
				<c:if test="${reply.relTypeCode eq 'article' && reply.relId == article.id}">	
					<div data-id="${reply.id }" class="flex flex-di-c articleDetailBox__articleReplyList__reply">
						
						<!-- 댓글 리스트 본문 PC버전 -->
						<div class="flex flex-di-c articleDetailBox__articleReplyList__reply-1-pc">
							<c:if test="${reply.status > 0 }">
								<div class="flex articleDetailBox__articleReplyList__reply-1-pc__box-1">
									<div class="reply__writer">${reply.extra__writer }</div>
									<div class="flex-grow-1 reply__body">${reply.body }</div>
									<div class="flex flex-ai-c flex-jc-sa reply__btns-2">
										<div class="reply__btns__like <c:if test="${isLogined }"> click</c:if>" <c:if test="${isLogined }">onclick="doLikeReplyBtn(this,${reply.id});"</c:if>>
											<i class="far fa-thumbs-up"></i>
											<span class="replyLikeCount">${reply.extra__likeCount }</span>
										</div>
										<div class="reply__btns__dislike <c:if test="${isLogined }"> click </c:if>" <c:if test="${isLogined }">onclick="doDisLikeReplyBtn(this,${reply.id});"</c:if>>
											<i class="far fa-thumbs-down"></i>
											<span class="replyDislikeCount">${reply.extra__dislikeCount }</span>
										</div>
									</div>
									<div class="reply__regDate">${reply.regDate }</div>
								</div>
									
								<div class="articleDetailBox__articleReplyList__reply-1-pc__box-2">
									<div class="float-l reply__btns-1 flex flex-ai-c flex-jc-sb">
										<c:if test="${loginedMemberId == reply.memberId }">
											<div class="reply__btns__modify click" onclick="modifyFormOpen(this);">수정</div>
											<div class="reply__btns__delete click">
												<form class="reply__btns__delete-form" action="${appUrl }/usr/reply/doDelete">														<input type="submit" value="삭제">
													<input type="hidden" name="id" value="${reply.id }">
													<input type="hidden" name="afterWriteReplyUrl" value="${currentUrl }">
												</form>
											</div>
										</c:if>
									</div>	
									<c:if test="${isLogined }">
										<div class="float-r flex flex-ai-c reply__reply" onclick="replyReplyFormOpen(this);">
											<div>[답글]</div>
										</div>
									</c:if>
								</div>
							</c:if>
							
							<c:if test="${reply.status < 0 }">
								<div class="flex flex-ai-c articleDetailBox__articleReplyList__reply-1-pc__deletedReply">삭제된 댓글입니다.</div>
							</c:if>
							
							<!-- 대댓글 리스트 시작 -->
							<c:forEach var="replyReply" items="${replies }">
								<c:if test="${replyReply.relTypeCode eq 'reply' && replyReply.relId == reply.id}">
									<div data-id="${replyReply.id }" class="targetReply flex replyreplies">
										<div class="replyreplies__arrow"></div>
										<div class="flex flex-di-c replyreplies__replyReplyList">
											<div class="replyreplies__replyReplyList__replyContainer">
												<div class="flex flex-ai-c replyreplies__replyReplyList__replyContainer__box-1">
													<span class="replyreplies__writer">${replyReply.extra__writer }</span>
													<span class="flex-grow-1 replyreplies__body">${replyReply.body }</span>
													<div class="flex flex-ai-c flex-jc-sa replyreplies__btns-1">
														<span>
															<i class="far fa-thumbs-up"></i>${replyReply.extra__likeCount }
														</span>
														<span>
															<i class="far fa-thumbs-down"></i>${replyReply.extra__dislikeCount }
														</span>
													</div>
													<span class="replyreplies__regDate">${reply.regDate }</span>
												</div>
												<div class="replyreplies__replyReplyList__replyContainer__box-2">
													<c:if test="${loginedMemberId == replyReply.memberId }">
														<div class="floar-l flex flex-ai-c flex-jc-sb replyreplies__btns-2">
															<span>수정</span>
															<span>삭제</span>
														</div>
													</c:if>
												</div>
											</div>
										</div>
									</div>
								</c:if>
							</c:forEach>
							<!-- 대댓글 리스트 끝 -->
						</div>	
						<!-- 댓글 리스트 본문 PC버전 끝 -->
						
						<!-- 댓글 리스트 본문 모바일버전 시작 -->
						<div class="flex flex-di-c articleDetailBox__articleReplyList__reply-1-mb">
							<c:if test="${reply.status > 0 }">
								<div class="flex flex-ai-c flex-jc-sb articleDetailBox__articleReplyList__reply-1-mb__box1">
									<div>${reply.extra__writer }</div>
									<div class="flex flex-ai-c">
										<div class="flex flex-ai-c flex-jc-sa reply__btns-mb-1">
											<div class="reply__btns__like <c:if test="${isLogined }"> click</c:if>" <c:if test="${isLogined }">onclick="doLikeReplyBtn(this,${reply.id});"</c:if>>
												<i class="far fa-thumbs-up"></i>
												<span class="replyLikeCount">좋아요 ${reply.extra__likeCount }</span>
											</div>
											<div class="reply__btns__dislike <c:if test="${isLogined }"> click </c:if>" <c:if test="${isLogined }">onclick="doDisLikeReplyBtn(this,${reply.id});"</c:if>>
												<i class="far fa-thumbs-down"></i>
												<span class="replyDislikeCount">싫어요 ${reply.extra__dislikeCount }</span>
											</div>
										</div>
										<div>${reply.regDate }</div>
									</div>
								</div>
								<div class="articleDetailBox__articleReplyList__reply-1-mb__box2">
									<div class="flex-grow-1">${reply.body }</div>
									<c:if test="${loginedMemberId == reply.memberId }">
										<div class="flex flex-ai-c flex-jc-sa reply__btns-mb-2">
											<div class="reply__btns__modify" onclick="modifyFormOpen(this);">수정</div>
											<div class="reply__btns__delete">
												<form class="reply__btns__delete-form" action="${appUrl }/usr/reply/doDelete">
													<input type="submit" value="삭제">
													<input type="hidden" name="id" value="${reply.id }">
													<input type="hidden" name="afterWriteReplyUrl" value="${currentUrl }">
												</form>
											</div>
										</div>
									</c:if>
		
									<c:if test="${isLogined }">
										<div class="float-r flex flex-ai-c reply__reply-mb" onclick="replyReplyFormOpen(this);">
											<div>[답글]</div>
										</div>
									</c:if>
								</div>
							</c:if>
							
							<c:if test="${reply.status < 0 }">
								<div class="flex flex-ai-c articleDetailBox__articleReplyList__reply-1-mb__deletedReply">삭제된 댓글입니다.</div>
							</c:if>
							
							<!-- 대댓글 리스트 시작 -->
							<c:forEach var="replyReply" items="${replies }">
								<c:if test="${replyReply.relTypeCode eq 'reply' && replyReply.relId == reply.id}">
									<div class="flex replyreplies-mb">
										<div class="replyreplies__arrow"></div>
										<div class="flex flex-di-c replyreplies__replyReplyList">
											<div class="replyreplies__replyReplyList__replyContainer-mb">
												<div class="flex flex-ai-c replyreplies__replyReplyList__replyContainer__box-1">
													<span class="replyreplies__writer-mb">${replyReply.extra__writer }</span>
													<div class="flex-grow-1"></div>
													<span class="replyreplies__regDate-mb">${reply.regDate }</span>
												</div>
												<div class="flex flex-ai-c replyreplies__btns-1-mb">
													<span>
														<i class="far fa-thumbs-up"></i>좋아요 ${replyReply.extra__likeCount }
													</span>
													<span>
														<i class="far fa-thumbs-down"></i>싫어요 ${replyReply.extra__dislikeCount }
													</span>
												</div>
												<div class="replyreplies__body-mb">
													<span>${replyReply.body }</span>
												</div>
												<div class="replyreplies__replyReplyList__replyContainer__box-2">
													<c:if test="${loginedMemberId == replyReply.memberId }">
														<div class="floar-l flex flex-ai-c flex-jc-sb replyreplies__btns-2-mb">
															<span>수정</span>
															<span>삭제</span>
														</div>
													</c:if>
												</div>
											</div>
										</div>
									</div>
								</c:if>
							</c:forEach>
							<!-- 대댓글 리스트 끝 -->
						</div>
						<!-- 댓글 리스트 본문 모바일버전 끝 -->	
						
						<!-- 대댓글 작성 시작 -->
						<div class="articleDetailBox__reply-reply">
							<form name="writeReplyReplyForm" class="articleDetailBox__replyReplyForm" action="${appUrl }/usr/reply/doWrite"
							 method="POST" onsubmit="return replyReplyFormCheck(this);">
								<input type="hidden" name="body">
								<input type="hidden" name="memberId" value="${loginedMemberId }">
								<input type="hidden" name="replyId" value="${reply.id }">
								<input type="hidden" name="afterWriteReplyUrl" value="${Util.getNewUrl(currentUrl, 'focusReplyId', '[NEW_REPLY_ID]')}">
								<div class="writeReplyBodyInput">
									<script type="text/x-template"></script>
	  								<div class="toast-ui-editor"></div>
	  							</div>
	  							<div class="flex flex-ai-c flex-jc-e replyReply-btns">
	  								<button class="btn-square replyReply__submit">등록</button>
	  								<span class="btn-square replyReply__cancel"  onclick="replyReplyCancel(this);">취소</span>
	  							</div>
							</form>
						</div>
						<!-- 대댓글 작성 끝 -->
		
						<!-- 댓글 수정 시작 -->
						<div class="articleDetailBox__reply-modify">
							<form name="writeReplyModifyForm" class="articleDetailBox__reply-modifyform" action="${appUrl }/usr/reply/doModify"
							 method="POST" onsubmit="return modifyFormCheck(this);">
								<input type="hidden" name="body">
								<input type="hidden" name="id" value="${reply.id }">
								<input type="hidden" name="memberId" value="${sessionScope.loginedMemberId }">
								<input type="hidden" name="articleId" value="${article.id }">
								<input type="hidden" name="afterWriteReplyUrl" value="${Util.getNewUrl(currentUrl, 'focusReplyId', '[NEW_REPLY_ID]')}">
								<div class="writeReplyBodyInput">
									<script type="text/x-template"></script>
						  			<div class="toast-ui-editor"></div>
						  		</div>
						  		<div class="flex flex-ai-c flex-jc-e articleDetailBox__reply-modifyform__btns">
						  			<button class="btn-square submitReplyModify">수정</button>
						  			<span class="btn-square submitReplyModifyCancel" onclick="modifyReplyCancel(this);">취소</span>
						  		</div>  
						  	</form>
						</div>
						<!-- 댓글 수정 끝 -->	
					</div>
				</c:if>			
			</c:forEach>
		</div>
		<!-- 댓글 리스트 본문 끝 -->		
	</div>	
	<!-- 댓글 리스트 끝-->
</div>
<!-- 댓글 끝 -->

<%@ include file="../../part/foot.jspf"%>