<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.sbs.example.util.Util"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="${article.title }" />
<%@ include file="../../part/head.jspf"%>

<script>
setInterval(timeBefore,1000);
function timeBefore(){
	//현재시간
	var now = new Date(); 
		        
	//글쓴 시간 
	var writeDay = new Date('2021-04-02 03:04:59');
		        
	var minus;
	if(now.getFullYear() > writeDay.getFullYear()){
		minus= now.getFullYear()-writeDay.getFullYear();
		document.getElementsByClassName("sub")[0].innerHTML = minus+"년 전";
	} else if(now.getMonth() > writeDay.getMonth()){
		minus= now.getMonth()-writeDay.getMonth();
		document.getElementsByClassName("sub")[0].innerHTML = minus+"달 전";
	} else if(now.getDate() > writeDay.getDate()){
		minus= now.getDate()-writeDay.getDate();
		document.getElementsByClassName("sub")[0].innerHTML = minus+"일 전";
	} else if(now.getDate() == writeDay.getDate()){
		var nowTime = now.getTime();
		var writeTime = writeDay.getTime();
		
		if(nowTime>writeTime){
			sec =parseInt(nowTime - writeTime) / 1000;
		    day  = parseInt(sec/60/60/24);
		    sec = (sec - (day * 60 * 60 * 24));
		    hour = parseInt(sec/60/60);
		    sec = (sec - (hour*60*60));
		    min = parseInt(sec/60);
		    sec = parseInt(sec-(min*60));
		    if(hour>0) {
		         document.getElementsByClassName("sub")[0].innerHTML = hour+"시간 전";
		    } else if(min>0) {
		         document.getElementsByClassName("sub")[0].innerHTML = min+"분 전";
		    } else if(sec>0) {
		         document.getElementsByClassName("sub")[0].innerHTML = "방금 전";
		    }
		}
	}
}
</script>	

<script>
function increaseHit(){
	
	let memberId = 0;
	const articleId = ${article.id};
	
	if(${loginedMemberId}){
	  memberId = ${loginedMemberId};
	}
	
	const date = new Date();
	
	const year = date.getFullYear();
	const month = new String(date.getMonth());
	const day = new String(date.getDate());
	
	const currentDate = new Date(year,month , day);
	
	if( JSON.parse(localStorage.getItem('member_'+ memberId + '_' + 'article_' + articleId))){
		
		const setYear = JSON.parse(localStorage.getItem('member_'+ memberId + '_' + 'article_' + articleId)).date.substr(0,4);
        const setMonth = JSON.parse(localStorage.getItem('member_'+ memberId + '_' + 'article_' + articleId)).date.substr(5,2);
		const setDay = JSON.parse(localStorage.getItem('member_'+ memberId + '_' + 'article_' + articleId)).date.substr(8,2);
		const setDate = new Date(setYear,setMonth,setDay);
		
		if(currentDate.getTime() - setDate.getTime() > 86400000 ){
			localStorage.removeItem('member_'+ memberId + '_' + 'article_' + articleId);
		}
		
	}
	
	if( localStorage.getItem('member_'+ memberId + '_' + 'article_' + articleId)) {
		return;
	}
	
	$.post(
		"doIncreaseArticleHit",
		{
			memberId,
			articleId
		},
		function(data) {
			if(data.success){
				$('.articleDetailHitCount').text(data.body.hitCount);
			} else{
				alert('경고.');
			}
		},
		"json"
	);
	
	const setMonth = new String(date.getMonth() -1);
	const setDay = new String(date.getDate() +1);
	
	const setData = {
		'memberId' : memberId,
		'articleId' : ${article.id},
		'date' : new Date(year,setMonth,setDay)
	};
	
	localStorage.setItem('member_'+ memberId + '_' + 'article_' + articleId , JSON.stringify(setData));
	
}
function countTime(){
	setTimeout(increaseHit, 10000);
}
countTime();
</script>

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
			"${appUrl}/usr/reply/doWriteReplyReply",
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

<div class="title-bar con-min-width">
	<h1 class="con">
		<span>${article.title}</span>
	</h1>
</div>

<!-- 게시물 상세 박스 시작 -->
<div class="article-detail-box detail-box con-min-width">
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
						<div>
							<div>
								<span>조회수</span>
								<div class="articleDetailHitCount">${article.hitCount}</div>
							</div>
							<div>
								<i class="fas fa-thumbs-up"></i>
								<div>${article.extra__likeCount}</div>
							</div>
							<div>
								<i class="fas fa-thumbs-down"></i>
								<div>${article.extra__dislikeCount}</div>
							</div>
						</div>						
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
				$('.articleDetailInfo-box2__likeCount').text(data.body.likeCount);				
			} else{
				$('.articleDetailBody__likeBtn > i').attr('class','far fa-thumbs-up');
				$('.articleDetailInfo-box2__likeCount').text(data.body.likeCount);				
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
				$('.articleDetailInfo-box2__dislikeCount').text(data.body.dislikeCount);
			} else{
				$('.articleDetailBody__dislikeBtn > i').attr('class','far fa-thumbs-down');
				$('.articleDetailInfo-box2__dislikeCount').text(data.body.dislikeCount);
			  }
			},
			"json"
		);
}
</script>

<!-- 게시물 버튼 박스 시작 -->
<div class="con article-btn-box con-min-width">
		<c:if test="${isLogined }">
		<div class="btn articleDetailBody__likeBtn" onclick="doLikeBtn();">
			<c:if test="${isLikedArticle == true }">
		  		<i class="fas fa-thumbs-up"></i>
		  		<span class="articleDetailInfo-box2__likeCount">${article.extra__likeCount }</span>
		  	</c:if>
			<c:if test="${isLikedArticle == false }">  
		  		<i class="far fa-thumbs-up"></i>
		  		<span class="articleDetailInfo-box2__likeCount">${article.extra__likeCount }</span>
		  	</c:if>
	  	</div>
	  	<div class="btn articleDetailBody__dislikeBtn" onclick="doDislikeBtn();">
		  	<c:if test="${isLikedArticle == true }">
		  		<i class="fas fa-thumbs-down"></i>
		  		<span class="articleDetailInfo-box2__dislikeCount">${article.extra__dislikeCount }</span>
		  	</c:if>
		  	<c:if test="${isLikedArticle == false }">  
		  		<i class="far fa-thumbs-down"></i>
		  		<span class="articleDetailInfo-box2__dislikeCount">${article.extra__dislikeCount }</span>
		  	</c:if>
	  	</div>
	  	</c:if>
  	<a class="btn btn-info hov-red" href="${param.listUrl}">리스트</a>
	<a class="btn btn-info hov-red" href="modify?id=${article.id}">수정</a>
	<a class="btn btn-danger hov-red" onclick="if ( confirm('정말 삭제하시겠습니까?') == false ) { return false; }"
		href="doDelete?id=${article.id}">삭제</a>
</div>
<!-- 게시물 버튼 박스 끝 -->

<div class="title-bar con-min-width font-size-12p">
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
				$(el).children('span').text(data.body.replyLikeCount);
				}
			else{
				$(el).children('i').attr('class','far fa-thumbs-up');
				$(el).children('span').text(data.body.replyLikeCount);
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
				$(el).children('span').text(data.body.replyDislikeCount);
				}
			else{
				$(el).children('i').attr('class','far fa-thumbs-down');
				$(el).children('span').text(data.body.replyDislikeCount);
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
			<form name="writeReplyForm" class="articleDetailBox__reply-form" action=""
			 method="POST" onsubmit="return writeFormCheck(this); return false;">
				<input type="hidden" name="body">
				<input type="hidden" name="memberId" value="${sessionScope.loginedMemberId }">
				<input type="hidden" name="articleId" value="${article.id }">
				<input type="hidden" name="afterWriteReplyUrl" value="${Util.getNewUrl(currentUrl, 'focusReplyId', '[NEW_REPLY_ID]')}">
				<div class="writeReplyBodyInput">
					 <script type="text/x-template"></script>
			  		 <div class="toast-ui-editor"></div>
			  	</div>
			  	<button class="btn-square submitWriteReply">등록</button>
		  	</form>
		</div>
	</c:if>
	<!-- 댓글 입력 창(로그인 했을 때) 끝-->
	
	<!-- 댓글 리스트 시작-->
	<div class="articleDetailBox__articleReplyList">
		<c:if test="">
		
		</c:if>
		<!-- 전체 댓글 수 정보 시작 -->
		<div class="articleDetailBox__articleReplyList__info">
			<span>전체 댓글 수</span>
			<span>${article.replyCount }</span>
		</div>
		<!-- 전체 댓글 수 정보 끝 -->

		<script type="text/javascript">
		var newHtml;
		
		function loadRepliesList(){	
			$.get('${appUrl}/usr/reply/getReplies',
				{
			
				}, function(data){
					if(data != null) {
						data.body = data.body.reverse();
						newHtml.html('');
					
						for (var i = 0; i < data.body.length ; i++) {
							var reply = data.body[i];
							var tmpBox1 = "";
							var tmpBox2 = "";
							
							function replaceAll(str, searchStr, replaceStr) {
								return str.split(searchStr).join(replaceStr);
							}
							
							if (reply.relTypeCode == 'article' && reply.relId == ${article.id }) {
								tmpBox1 = $('.template-box').html();
								
								if (reply.status > 0) {
									tmpBox1 = replaceAll(tmpBox1 , "{$statusTrue}", "");
									tmpBox1 = replaceAll(tmpBox1 , "{$statusFalse}","dp-none");
								} else if ( reply.status < 0 ) {
									tmpBox1 = replaceAll(tmpBox1 , "{$statusTrue}","dp-none");
									tmpBox1 = replaceAll(tmpBox1 , "{$statusFalse}","");
								}
							
								if ( ${isLogined} ) {
									tmpBox1 = replaceAll(tmpBox1 , "{$click}","click");
									tmpBox1 = replaceAll(tmpBox1 , "{$onClick1}","doLikeReplyBtn(this,"+reply.id+");");
									tmpBox1 = replaceAll(tmpBox1 , "{$onClick2}","doDisLikeReplyBtn(this,"+reply.id+");");
									tmpBox1 = replaceAll(tmpBox1 , "{$loginStatus}","");
								} else {
									tmpBox1 = replaceAll(tmpBox1 , "{$loginStatus}","dp-none");
								}
							
								if ( reply.memberId == ${loginedMemberId} ) {
									tmpBox1 = replaceAll(tmpBox1 , "{$myReply}","");
								} else {
									tmpBox1 = replaceAll(tmpBox1 , "{$myReply}","dp-none");
								}
							
								tmpBox1 = replaceAll(tmpBox1 , "{$Rid}" , reply.id);
								tmpBox1 = replaceAll(tmpBox1 , "{$Rwriter}" , reply.extra__writer);
								tmpBox1 = replaceAll(tmpBox1 , "{$RregDate}" , reply.regDate);
								tmpBox1 = replaceAll(tmpBox1 , "{$Rbody}" , reply.body);
								tmpBox1 = replaceAll(tmpBox1 , "{$RlikeCount}" , reply.extra__likeCount);
								tmpBox1 = replaceAll(tmpBox1 , "{$RdislikeCount}" , reply.extra__dislikeCount);
								
								var isExistsRR = false;
								
								for ( var j = data.body.length-1 ; j >= 0; j -- ) {
									var replyReply = data.body[j];
						
									if ( replyReply.relTypeCode == 'reply' && replyReply.relId == reply.id ) {
										isExistsRR = true;
										tmpBox2Html = $('.template-box-2').html();
							
										if ( replyReply.status > 0 ) {
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRstatusTrue}","");
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRstatusFalse}","dp-none");
										} else {
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRstatusTrue}","dp-none");
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRstatusFalse}","");
										}
							
										if ( ${isLogined} ) {
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRclick}","click");
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRonClick1}","doLikeReplyBtn(this,"+replyReply.id+");");
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRonClick2}","doDisLikeReplyBtn(this,"+replyReply.id+");");
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRloginStatus}","");
										} else {
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRloginStatus}","dp-none");
										}
							
										if ( replyReply.memberId == ${loginedMemberId} ) {
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRmyReply}","");
										} else {
											tmpBox2Html = replaceAll(tmpBox2Html , "{$RRmyReply}","dp-none");
										}
							
										tmpBox2Html = replaceAll(tmpBox2Html , "{$RRid}" , replyReply.id);
										tmpBox2Html = replaceAll(tmpBox2Html , "{$RRwriter}" , replyReply.extra__writer);
										tmpBox2Html = replaceAll(tmpBox2Html , "{$RRregDate}" , replyReply.regDate);
										tmpBox2Html = replaceAll(tmpBox2Html , "{$RRbody}" , replyReply.body);
										tmpBox2Html = replaceAll(tmpBox2Html , "{$RRlikeCount}" , replyReply.extra__likeCount);
										tmpBox2Html = replaceAll(tmpBox2Html , "{$RRdislikeCount}" , replyReply.extra__dislikeCount);
									
										tmpBox2 += tmpBox2Html;				
									}
								}
								
								if ( isExistsRR ) {
									tmpBox1 = replaceAll(tmpBox1 , "{$RRreplyList}" , tmpBox2 );
								} else {
									tmpBox1 = replaceAll(tmpBox1 , "{$RRreplyList}" , "" );
								}
								newHtml.prepend(tmpBox1);
							}
						}
				
						$('.toast-ui-editor').html('');
						EditorViewer__init();
						Editor__init();	
						
						if ( param.focusReplyId ) {
							const $target = $('.real .targetReply[data-id="' + param.focusReplyId + '"]');
							$target.addClass('focus');
							setTimeout(function() {
								const targetOffset = $target.offset();
								$(window).scrollTop(targetOffset.top);
								setTimeout(function() {
									$target.removeClass('focus');
								}, 1000);
							}, 1000);
						}
					} else {
						$('.toast-ui-editor').html('');
						EditorViewer__init();
						Editor__init();			
					}	
				},
				'json'
			);		
		}
		
		$(function() {
			newHtml = $('.articleDetailBox__articleReplyList__replies.real');
			loadRepliesList();
		});
		</script>		
		
		<!-- 댓글 리스트 본문 시작 --> 
		<div class="template-box articleDetailBox__articleReplyList__replies">
			<div data-id="{$Rid}" class="template-box-1 flex flex-di-c targetReply articleDetailBox__articleReplyList__reply">
						
				<!-- 댓글 리스트 본문 PC버전 -->
				<div class="template-box-replyList-pc flex flex-di-c articleDetailBox__articleReplyList__reply-1-pc">
					<div class="{$statusTrue}">
						<div class="flex flex-ai-c articleDetailBox__articleReplyList__reply-1-pc__box-1">
							<div class="reply__writer">{$Rwriter}</div>
							<div class="flex-grow-1 reply__body">{$Rbody}</div>
							<div class="flex flex-ai-c flex-jc-sa reply__btns-2">
								<div class="reply__btns__like {$click}" onclick="{$onClick1}"> 
									<i class="far fa-thumbs-up"></i>
									<span class="replyLikeCount">{$RlikeCount}</span>
								</div>
								<div class="reply__btns__dislike {$click}" onclick="{$onClick2}">
									<i class="far fa-thumbs-down"></i>
									<span class="replyDislikeCount">{$RdislikeCount}</span>
								</div>
							</div>
							<div class="reply__regDate sub">{$RregDate}</div>
						</div>
								
						<script>
						function replyReplyFormOpen(el){
							const form = $(el).parents().parents().siblings('.articleDetailBox__reply-reply');
							$(form).css({
								'display':'block',
								'margin-top':'15px'
							});
						}
						
						function replyReplyCancel(el){
							const form = $(el).parents().parents('.articleDetailBox__reply-reply');
							$(form).css('display','none');
						}
						</script>
									
						<div class="articleDetailBox__articleReplyList__reply-1-pc__box-2">
							<div class="{$myReply}">
								<div class="float-l reply__btns-1 flex flex-ai-c flex-jc-sb">
									<div class="reply__btns__modify click" onclick="modifyFormOpen(this);">수정</div>
									<div class="reply__btns__delete click">
										<form class="reply__btns__delete-form" action="" onsubmit="if ( confirm('정말 삭제하시겠습니까?') ) {doDeleteArticleReply(this);} return false;">														<input type="submit" value="삭제">
											<input type="hidden" name="id" value="{$Rid}">
											<input type="hidden" name="articleId" value="${article.id }">
											<input type="hidden" name="afterWriteReplyUrl" value="${currentUrl }">
										</form>
									</div>
								</div>
							</div>
									
							<script>
							function doDeleteArticleReply(el){
								$.get(
									"${appUrl}/usr/reply/doDelete",
									{ id : $(el).closest('form').get(0).id.value,
										  articleId: $(el).closest('form').get(0).articleId.value
									},  function(data) {
										loadRepliesList();
									},
								"json"
								);
							}
							</script>						
										
							<div class="{$loginStatus}">
								<div class="float-r flex flex-ai-c reply__reply" onclick="replyReplyFormOpen(this);">
									<div class="click">[답글]</div>
								</div>
							</div>
						</div>
					</div>
							
					<div class="{$statusFalse}">
						<div class="flex flex-ai-c articleDetailBox__articleReplyList__reply-1-pc__deletedReply">삭제된 댓글입니다.</div>
					</div>
				</div>	
				<!-- 댓글 리스트 본문 PC버전 끝 -->
						
				<!-- 댓글 리스트 본문 모바일버전 시작 -->
				<div class="flex flex-di-c articleDetailBox__articleReplyList__reply-1-mb">
					<div class="{$statusTrue}">
						<div class="flex flex-ai-c flex-jc-sb articleDetailBox__articleReplyList__reply-1-mb__box1">
							<div>{$Rwriter}</div>
							<div class="flex flex-ai-c">
								<div class="flex flex-ai-c flex-jc-sa reply__btns-mb-1">
									<div class="reply__btns__like {$click}" onclick="{$onClick1}">
										<i class="far fa-thumbs-up"></i>
										<span class="replyLikeCount"> {$RlikeCount}</span>
									</div>
									<div class="reply__btns__dislike {$click}" onclick="{$onClick2}">
										<i class="far fa-thumbs-down"></i>
										<span class="replyDislikeCount"> {$RdislikeCount}</span>
									</div>
								</div>
								<div>{$RregDate}</div>
							</div>
						</div>
										
						<div class="flex flex-ai-c articleDetailBox__articleReplyList__reply-1-mb__box2">
							<div class="flex-grow-1">{$Rbody}</div>
							<div class="{$myReply}">
								<div class="flex flex-ai-c flex-jc-sa reply__btns-mb-2">
									<div class="reply__btns__modify" onclick="modifyFormOpen(this);">수정</div>
									<div class="reply__btns__delete">
										<form class="reply__btns__delete-form" action=""  onsubmit="if ( confirm('정말 삭제하시겠습니까?') ) {doDeleteArticleReply(this);} return false;">
											<input type="submit" value="삭제">
											<input type="hidden" name="id" value="{$Rid}">
											<input type="hidden" name="articleId" value="${article.id }">
											<input type="hidden" name="afterWriteReplyUrl" value="${currentUrl }">
										</form>
									</div>
								</div>
							</div>
		
							<div class="{$loginStatus}">
								<div class="float-r flex flex-ai-c reply__reply-mb" onclick="replyReplyFormOpen(this);">
									<div>[답글]</div>
								</div>
							</div>
						</div>
					</div>
							
					<div class="{$RstatusFalse}">
						<div class="flex flex-ai-c articleDetailBox__articleReplyList__reply-1-mb__deletedReply">삭제된 댓글입니다.</div>
					</div>
				</div>
				<!-- 댓글 리스트 본문 모바일버전 끝 -->	

				<!-- 댓글 수정 시작 -->
				<script>
					function modifyFormOpen(el){
						const form = $(el).parents().parents().siblings('.articleDetailBox__reply-modify');
						$(form).css({
							'display':'block',
							'margin-top':'15px'
						});
					}
					
					function modifyReplyCancel(el){
						const form = $(el).parents().parents('.articleDetailBox__reply-modify');
							$(form).css('display','none');
					}					
					
					DoModifyForm__submited = false;
							
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

						$.get(
							"${appUrl}/usr/reply/doModifyArticleReply",
							{
								body,
								replyId : $(el).closest('form').get(0).replyId.value,
								memberId : $(el).closest('form').get(0).memberId.value,
								articleId : $(el).closest('form').get(0).articleId.value,
								afterWriteReplyUrl : $(el).closest('form').get(0).afterWriteReplyUrl.value
							},  function(data) {
								loadRepliesList();
							},
							"json"
						);					
						
						return true;
					}
				</script>		
						
				<div class="articleDetailBox__reply-modify">
					<form name="writeReplyModifyForm" class="articleDetailBox__reply-modifyform" action="" method="POST" onsubmit="modifyFormCheck(this); return false;">
						<input type="hidden" name="body">
						<input type="hidden" name="id" value="{$Rid}">
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
				{$RRreplyList}
						
				<!-- 대댓글 작성 시작 -->
				<div class="articleDetailBox__reply-reply">
					<form name="writeReplyReplyForm" class="articleDetailBox__replyReplyForm" action="" method="POST" onsubmit="replyReplyFormCheck(this); return false;">
						<input type="hidden" name="body">
						<input type="hidden" name="memberId" value="${loginedMemberId }">
						<input type="hidden" name="replyId" value="{$Rid}">
						<input type="hidden" name="articleId" value="${article.id }">
						<input type="hidden" name="afterWriteReplyUrl" value="${Util.getNewUrl(currentUrl, 'focusReplyId', '[NEW_REPLY_ID]')}">
						<div class="writeReplyBodyInput">
							<script type="text/x-template"></script>
	  						<div class="toast-ui-editor"></div>
	  					</div>
	  					<div class="flex flex-ai-c flex-jc-e replyReply-btns">
	  						<button class="btn-square replyReply__submit">등록</button>
	  						<span class="btn-square replyReply__cancel" onclick="replyReplyCancel(this);">취소</span>
	  					</div>
					</form>
				</div>
				<!-- 대댓글 작성 끝 -->
						
				<div class="template-box template-box-2">
					<!-- 대댓글 리스트 시작 -->
					<div class="flex replyReply-container">
						<div class="replyreplies__arrow"></div>
						<div class="flex flex-di-c replyreplies__replyReplyList">
							<div data-id="{$RRid}" class="targetReply block replyreplies">
											
								<!-- 대댓글 리스트 PC버전 시작 -->
								<div class="flex replyreplies-pc">
									<div class="width-100p">
										<div class="replyreplies__replyReplyList__replyContainer">
											<div class="{$RRstatusTrue}">
												<div class="flex flex-ai-c replyreplies__replyReplyList__replyContainer__box-1">
													<span class="replyreplies__writer">{$RRwriter}</span>
													<span class="flex-grow-1 replyreplies__body">{$RRbody}</span>
													<div class="flex flex-ai-c flex-jc-sa replyreplies__btns-1">
														<div class="{$RRclick}" onclick="{$RRonClick1}">
															<i class="far fa-thumbs-up"></i>{$RRlikeCount}
														</div>
														<div class="{$RRclick}" onclick="{$RRonClick2}">
															<i class="far fa-thumbs-down"></i>{$RRdislikeCount}
														</div>
													</div>
													<span class="replyreplies__regDate">{$RRregDate}</span>
												</div>
												<div class="replyreplies__replyReplyList__replyContainer__box-2">
													<div class="{$RRmyReply}">
														<div class="float-r flex flex-ai-c flex-jc-sb replyreplies__btns-2">
															<span class="click" onclick="modifyReplyReplyFormOpen(this);">수정</span>
															<form class="click replyreplies__btns-2__deleteForm" action="" onsubmit="if ( confirm('정말 삭제하시겠습니까?') ) {doDeleteReplyReply(this);} return false;">
																<input class="click" type="submit" value="삭제">
																<input type="hidden" name="id" value="{$RRid}">
																<input type="hidden" name="articleId" value="${article.id }">
																<input type="hidden" name="afterWriteReplyUrl" value="${currentUrl }">
															</form>
														</div>
													</div>
												</div>													
											</div>
											<div class="{$RRstatusFalse}">
												<div class="flex flex-ai-c articleDetailBox__articleReplyList__reply-1-pc__deletedReply">삭제된 댓글입니다.</div>
											</div>
										</div>
									</div>
								</div>	
								<!-- 대댓글 리스트 PC버전 끝 -->
												
								<!-- 대댓글 삭제 -->
								<script>
									function doDeleteReplyReply(el){												
										$.get(
											"${appUrl}/usr/reply/doDeleteReplyReply",
											{
												id : $(el).closest('form').get(0).id.value,
												articleId: $(el).closest('form').get(0).articleId.value
											},
											function(data) {
												loadRepliesList();
											},
											"json"
										);
									}
								</script>											
												
								<!-- 대댓글 리스트 Mobile버전 시작 -->
								<div class="targetReply flex replyreplies-mb">
									<div class="width-100p">
										<div class="replyreplies__replyReplyList__replyContainer-mb">
											<div class="{$RRstatusTrue}">	
												<div class="flex flex-ai-c replyreplies__replyReplyList__replyContainer__box-1">
													<span class="replyreplies__writer-mb">{$RRwriter}</span>
													<div class="flex-grow-1"></div>
													<span class="replyreplies__regDate-mb">{$RRregDate}</span>
												</div>
												<div class="flex flex-ai-c replyreplies__btns-1-mb">
													<div class="{$RRclick}" onclick="{$RRonClick1}">
														<i class="far fa-thumbs-up"></i> {$RRlikeCount}
													</div>
													<div class="{$RRclick}" onclick="{$RRonClick2}">
														<i class="far fa-thumbs-down"></i> {$RRdislikeCount}
													</div>
												</div>
												<div class="replyreplies__body-mb">
													<span>{$RRbody}</span>
												</div>
												<div class="replyreplies__replyReplyList__replyContainer__box-2">
													<div class="{$RRmyReply}">
														<div class="float-r flex flex-ai-c flex-jc-sb replyreplies__btns-2-mb">
															<span class="click" onclick="modifyReplyReplyFormOpen(this);">수정</span>
															<form class="click replyreplies__btns-2__deleteForm" action="" onsubmit="if ( confirm('정말 삭제하시겠습니까?') ) {doDeleteReplyReply(this);} return false;">
																<input class="click" type="submit" value="삭제">
																<input type="hidden" name="id" value="${replyReply.id }">
																<input type="hidden" name="articleId" value="${article.id }">
																<input type="hidden" name="afterWriteReplyUrl" value="${currentUrl }">
															</form>
														</div>
													</div>
												</div>
											</div>
													
											<c:if test="${replyReply.status < 0 }">
												<div class="flex flex-ai-c articleDetailBox__articleReplyList__reply-1-pc__deletedReply">삭제된 댓글입니다.</div>
											</c:if>
										</div>
									</div>				
								</div>
								<!-- 대댓글 리스트 Mobile버전 끝 -->
										
								<!-- 대댓글 수정 시작 -->
								<script>
									function modifyReplyReplyFormOpen(el){
										const form = $(el).parents().parents().parents().parents().parents().parents().parents().siblings('.articleDetailBox__replyReply-modify');
										$(form).css({
											'display':'block',
											'margin-top':'15px'
										});
									}
												
									function modifyReplyReplyCancel(el){
										const form = $(el).parents().parents().parents('.articleDetailBox__replyReply-modify');
										$(form).css('display','none');
									}
										
									DoModifyForm__submited = false;
										
									function modifyReplyReplyFormCheck(el){
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
												
										$.get(
											"${appUrl}/usr/reply/doModifyReplyReply",
											{
												body,
												replyId : $(el).closest('form').get(0).replyId.value,
												memberId : $(el).closest('form').get(0).memberId.value,
												afterWriteReplyUrl : $(el).closest('form').get(0).afterWriteReplyUrl.value
											},
											function(data) {
												loadRepliesList();
											},
											"json"
										);
									}		
								</script>
													
								<div class="articleDetailBox__replyReply-modify">
									<form name="writeReplyReplyModifyForm" class="articleDetailBox__replyReply-modifyform" action="" method="POST" onsubmit="modifyReplyReplyFormCheck(this); return false;">
										<input type="hidden" name="body">
										<input type="hidden" name="replyId" value="{$RRid}">
										<input type="hidden" name="memberId" value="${sessionScope.loginedMemberId }">
										<input type="hidden" name="afterWriteReplyUrl" value="${Util.getNewUrl(currentUrl, 'focusReplyId', '[NEW_REPLY_ID]')}">
										<div class="writeReplyBodyInput">
											<script type="text/x-template"></script>
							  				<div class="toast-ui-editor"></div>
							 			</div>
									 	<div class="flex flex-ai-c flex-jc-e articleDetailBox__reply-modifyform__btns">
											<button class="btn-square submitReplyModify">수정</button>
							 				<span class="btn-square submitReplyModifyCancel" onclick="modifyReplyReplyCancel(this);">취소</span>
							 			</div>  
									</form>
								</div>											
								<!-- 대댓글 수정 끝 -->											
							</div>
						</div> 
					</div>
					<!-- 대댓글 리스트 끝 -->	
				</div>						
			</div>
		</div>
		<!-- 댓글 실제 -->
		<div class="articleDetailBox__articleReplyList__replies real">
		</div>
		<!-- 댓글 실제 -->	
		<!-- 댓글 리스트 본문 끝 -->
	</div>	
	<!-- 댓글 리스트 끝-->
</div>
<!-- 댓글 끝 -->

<%@ include file="../../part/foot.jspf"%>