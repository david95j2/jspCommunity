<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="${board.name} 게시물 리스트" />
<%@ include file="../../part/head.jspf"%>

 <!-- 게시물 리스트 시작-->
    <div class="title-bar con-min-width">
      <h1 class="con">
        <span><i class="far fa-list-alt"></i></span>
        <span>${board.name}게시물 리스트</span>
      </h1>
    </div>
    
    <div class="con-min-width">
      <div class="con">
              <div>총 게시물 | ${totalCount}</div>
      </div>
    </div>

<div class="article-list-box con-min-width">
      <div class="con">
        <table>
          <colgroup>
            <col width="10%">
            <col width="56%">
            <col width="10%">
            <col width="10%">
            <col width="7%">
            <col width="7%">
          </colgroup>
          <thead>
            <tr>
              <th>번호</th>
              <th>제목</th>
              <th>작성자</th>
              <th>작성일</th>
              <th>조회수</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="article" items="${articles}">
            <tr>
              <td>
                <span class="article-list-box__id">${article.id}</span>
              </td>
              <td>
              	<a href="detail?id=${article.id}" class="article-list-box__title hover-link article-list-box__title--pc">${article.title}</a>
              </td>
              <td>
                <sapn class="article-list-box__writer">${article.extra__writer}</sapn>
              </td>
              <td>
                <sapn class="article-list-box__reg-date">${article.regDate}</sapn>
              </td>
              <td>
              	<sapn class="article-list-box__hit">${article.hitsCount}</sapn>
              </td>
              <td class="visible-md-down">
                <div class="flex">
                  <span class="article-list-box__id article-list-box__id--mobile">${article.id}</span>
                  <a href="#" class="article-list-box__title article-list-box__title--mobile flex-grow-1 hover-link">${article.title}</a>
                </div>
                <div class="flex">
                  <span class="article-list-box__writer article-list-box__writer--mobile">${article.extra__writer}</span>
                  <span>|</span>
                  <span class="article-list-box__reg-data article-list-box__reg-data--mobile">
                    ${article.regDate}
                  </span>
                </div>
              </td>
            </tr>
         	</c:forEach>
          </tbody>
        </table>
      </div>
    </div>
     <div class="article-btn-box con-min-width">
      <div class="con btn-wrap flex flex-jc-e">
        <c:if test="${sessionScope.loginedMemberId > 0}">
			<a href="write?boardId=${param.boardId}" class="btn btn-primary">게시물 작성</a>
		</c:if>
      </div>
    </div>
<div class="con-min-width">
	<div class="con article-page-menu">
		<ul class="flex flex-jc-c">
			<li>
				<c:if test="${pageBoxStartBeforeBtnNeedToShow}">
					<c:set var="aUrl" value="?page=${pageBoxStartBeforePage}&boardId=${param.boardId}&searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}" />
					<a href="${aUrl}" class="flex flex-ai-c">&lt;이전글</a>
				</c:if>		
			</li>
			<c:forEach var="i" begin="${pageBoxStartPage}" end="${pageBoxEndPage}" step="1">
				<c:set var="aClass" value="${page == i ? 'red' : ''}" />
				<c:set var="aUrl" value="?boardId=${param.boardId}&page=${i}&searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}" />
				<li>
					<a class="${aClass} flex flex-ai-c hov-red" href=${aUrl}>${i}</a>
				</li>
			</c:forEach>		
			<li>
				<c:if test="${pageBoxEndAfterBtnNeedToShow}">
					<c:set var="aUrl" value="?page=${pageBoxEndAfterPage}&boardId=${param.boardId}&searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}" />
					<a href="${aUrl}" class="flex flex-ai-c">다음글&gt;</a>
				</c:if>
			</li>
		</ul>
	</div>
</div>
<!-- 처음페이지/ 끝페이지  
	<c:if test="${pageBoxStartBeforeBtnNeedToShow}">
		<c:set var="aUrl" value="?page=1&boardId=${param.boardId}&searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}" />
		<a href="${aUrl}">◀◀</a>
	</c:if>
	

	<c:if test="${pageBoxEndAfterBtnNeedToShow}">
		<c:set var="aUrl" value="?page=${totalPage}&boardId=${param.boardId}&searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}" />
		<a href="${aUrl}">▶▶</a>
	</c:if>
-->

	<script>
		let DoSearchForm__submited = false;
		function DoSearchForm__submit(form){
			if( DoSearchForm__submited ){
					alert('처리중입니다.');
					return;
				}
			form.searchKeyword.value = form.searchKeyword.value.trim();
			
			if ( form.searchKeyword.value.length == 0){
				alert('검색어를 입력해주세요.');
				form.searchKEyword.focus();
				return;
			}
			
			form.submit();
			DoSearchForm__submited = true;
		}
	</script>
<div class="con-min-width article-search-box">
	<div class="con flex flex-jc-c">
		<form onsubmit="DoSearchForm__submit(this); return false;">
			<input type="hidden" name="boardId" value="${param.boardId}" />
			
			<select name="searchKeywordType">
				<option value="titleAndBody">제목+본문</option>
				<option value="title">제목</option>
				<option value="body">본문</option>
			</select>
			<script>
				const param__searchKeywordType = '${param.searchKeywordType}';
			
				if ( param__searchKeywordType ) {
					$('select[name="searchKeywordType"]').val(param__searchKeywordType);
				}
			</script>
			<input value="${param.searchKeyword}" type="text" name="searchKeyword" placeholder="검색어를 입력해주세요."/>
			<input type="submit" value="검색" />
		</form>
	</div>
</div>


<%@ include file="../../part/foot.jspf"%>