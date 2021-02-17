<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="Main page" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/home.css" />
<script src="${pageContext.request.contextPath}/static/home.js" defer></script>


<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&family=Sunflower:wght@500&display=swap" rel="stylesheet">


<section class="fullsize-video-bg">
  <div class="logo"><img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fbx4AOS%2FbtqVFASicFP%2Fxnvs4oKK3lAwK15u3GAfp0%2Fimg.png" alt=""></div>
	<div class="inner">
		<div>
			<h1>Youtube Creators community</h1>
      <p>함께 만들어가는
      	<c:if test="${isLogined == false}">
	      	<a href="../member/login"> 커뮤니티🤸‍♂</a>
      	</c:if>
  		<c:if test="${isLogined}">
  			<a href="../article/list?boardId=1"> 커뮤니티🤸‍♂</a>
  		</c:if>  	
      </p>
		</div>
	</div>
	<div id="video-viewport">
		<video width="1920" height="1280" autoplay muted loop>
			<source src="https://storage.googleapis.com/test_bucket__data/youtube.mp4" type="video/mp4" />
			<source src="https://storage.googleapis.com/test_bucket__data/youtube.mp4" type="video/webm" />
		</video>
	</div>
</section>