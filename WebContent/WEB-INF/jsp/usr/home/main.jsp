<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sbs.example.util.Util"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>개발자의 기술/일상 블로그</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<meta name="apple-mobile-web-app-title" content="chillax blog" />
<!-- 메타태그정보 //-->
<!-- META -->
<link rel="canonical" href="https://chillax.yadah.kr" />
<meta name="subject" content="개발자의 기술/일상 블로그"/>
<meta name="title" content="chillax blog" />
<meta name="keywords" content="HTML, CSS, JAVASCRIPT, JAVA, SPRING, MySQL, 리눅스, 리액트" />
<meta name="copyright" content="chillax blog" />
<meta name="pubdate" content="${Util.getNowDateStr()}" />
<meta name="lastmod" content="${Util.getNowDateStr()}" />
<!-- OPENGRAPH -->
<meta property="og:site_name" content="chillax blog" />
<meta property="og:type" content="website" />
<meta property="og:title" content="개발자의 기술/일상 블로그" />
<meta property="og:description" content="개발자의 기술/일상 관련 글들을 공유합니다." />
<meta property="og:locale" content="ko_KR" />
<meta property="og:image" content="https://storage.googleapis.com/test_bucket__data/site.PNG" />
<meta property="og:image:alt" content="chillax.yadah.kr" />
<meta property="og:image:width" content="486" />
<meta property="og:image:height" content="324" />
<meta property="og:updated_time" content="${Util.getNowDateStr()}"/>
<meta property="og:pubdate" content="${Util.getNowDateStr()}" />
<meta property="og:url" content="https://chillax.yadah.kr" />
<!-- TWITTER -->
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="개발자의 기술/일상 블로그" />
<meta name="twitter:site" content="@chillax blog" />
<meta name="twitter:creator" content="@chillax blog" />
<meta name="twitter:image" content="https://storage.googleapis.com/test_bucket__data/site.PNG">
<meta name="twitter:description" content="개발자의 기술/일상 관련 글들을 공유합니다." />
<!-- GOOGLE+ -->
<meta itemprop="headline" content="chillax blog" />
<meta itemprop="name" content="chillax blog" />
<meta itemprop="description" content="개발자의 기술/일상 관련 글들을 공유합니다." />
<meta itemprop="image" content="https://storage.googleapis.com/test_bucket__data/site.PNG" />

<!-- 유용한 링크 -->
<!-- cdnsj : https://cdnjs.com/ -->
<!-- 폰트어썸 아이콘 리스트 : https://fontawesome.com/icons?d=gallery&m=free -->

<!-- 구글 폰트 불러오기 -->
<!-- rotobo(400/700/900), notosanskr(400/600/900) -->
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700;900&family=Roboto:wght@400;700;900&display=swap" rel="stylesheet">

<!-- 폰트어썸 불러오기 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.1/css/all.min.css">

<!-- 제이쿼리 불러오기 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<link rel="shortcut icon" href="${pageContext.request.contextPath}/image/favicon.ico">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/home.css" />
<script src="${pageContext.request.contextPath}/static/home2.js" defer></script>

</head>

<body>

	<c:if test="${waringPw}">
		<div class="pwWaringBox">
			<div class="pwWaringBox-context">
				<span>현재 임시비밀번호를 사용중입니다. <a href="${appUrl }/usr/member/modify" class="pwWaringBox-context__text">비밀번호</a>를 변경해주세요</span>
			</div>
		</div>
	</c:if>

	<!-- 모바일 탑바 시작 -->
	<div
		class="mobile-top-bar visible-sm-down flex flex-jc-sb  con-min-width">
		<a href="${appUrl }/usr/home/main" class="logo flex flex-ai-c"> <img
			src="${pageContext.request.contextPath}/image/logo.png"
			alt="">
		</a> <a class="btn-toggle-menu-box-1 flex-as-c"></a>

		<nav class="menu-box-1">
			<ul>
				<c:if test="${ isLogined == false }">
					<li><a href="${appUrl }/usr/member/login">로그인하기</a></li>
				</c:if>
				<c:if test="${isLogined}">
					<li><a>회원정보</a>
						<ul>
							<li><a href="${appUrl }/usr/member/showMine">회원정보</a></li>
							<li><a href="${appUrl }/usr/member/modify">회원정보수정</a></li>						
						</ul>
					</li>
				</c:if>
				<li><a>게시판모아모아</a>
					<ul>
						<li><a href="${appUrl }/usr/article/list?boardId=1">MySQL</a></li>
						<li><a href="${appUrl }/usr/article/list?boardId=2">JAVA</a></li>
						<li><a href="${appUrl }/usr/article/list?boardId=3">JavaScript</a></li>
						<li><a href="${appUrl }/usr/article/list?boardId=4">VUE</a></li>
						<li><a href="${appUrl }/usr/article/list?boardId=5">Spring</a></li>
					</ul></li>
				<li><a>About Me</a>
					<ul>
						<li><a href="https://github.com/david95j2">Github</a></li>
						<li><a href="https://david95j2.tistory.com">Tistory</a></li>
					</ul></li>
				<li><a>이슈</a>
					<ul>
						<li><a href="${appUrl }/usr/article/list?boardId=7">빅데이터</a></li>
						<li><a href="${appUrl }/usr/article/list?boardId=8">안드로이드 & iOS</a></li>
					</ul></li>
				<c:if test="${isLogined}">
					<li><a href="${appUrl }/usr/member/doLogout">로그아웃하기</a></li>
				</c:if>
			</ul>
		</nav>
	</div>
	<!-- 모바일 탑바 끝 -->

	<!-- 탑바 시작 -->
	<div class="top-bar visible-md-up">
		<div class="menu-box-1-sub-menu-bg"></div>
		<div class="con height-100p flex flex-jc-sb">
			<a href="#" class="logo flex flex-ai-c"> <img
				src="${pageContext.request.contextPath}/image/logo.png"
				alt="">
			</a>

			<nav class="menu-box-1">
				<ul class="flex height-100p">
					<li><a class="flex flex-ai-c height-100p" href="${appUrl }/usr/home/main">HOME</a>
					</li>
					<li><a class="flex flex-ai-c height-100p"
						href="${appUrl }/usr/article/write?boardId=1">Write</a></li>
					<li><a class="flex flex-ai-c height-100p">Articles</a>
						<ul>
							<li><a href="${appUrl }/usr/article/list?boardId=1">MySQL</a></li>
							<li><a href="${appUrl }/usr/article/list?boardId=2">JAVA</a></li>
							<li><a href="${appUrl }/usr/article/list?boardId=3">JavaScript</a></li>
							<li><a href="${appUrl }/usr/article/list?boardId=4">Vue</a></li>
							<li><a href="${appUrl }/usr/article/list?boardId=5">Spring</a></li>
						</ul></li>
					<li><a class="flex flex-ai-c height-100p">About Me</a>
						<ul>
							<li><a href="https://github.com/david95j2">Github</a></li>
							<li><a href="https://david95j2.tistory.com/">Tistory</a></li>
						</ul></li>
					<li><a class="flex flex-ai-c height-100p">IT Issue</a>
						<ul>
							<li><a href="${appUrl }/usr/article/list?boardId=7">BigData</a></li>
							<li><a href="${appUrl }/usr/article/list?boardId=8">Android & iOS</a></li>
						</ul></li>
				</ul>
			</nav>

			<div class="status-bar flex">
				<div class="flex flex-ai-c">
					<ul class="flex flex-ai-c">
						<c:if test="${isLogined == false}">
							<li class="login">
								<a href="${appUrl }/usr/member/login">
									<i class="far fa-user"></i>
								</a>
							</li>
							<li class="status-bar__msg">
								<a href="${appUrl }/usr/member/login">
								<span>로그인</span>
								</a>
							</li>
						</c:if>
						<c:if test="${isLogined}">
							<li class="modify">
								<a href="${appUrl }/usr/member/showMine">
									<i class="fas fa-user"></i>
								</a>
							</li>
							<li class="status-bar__msg nickname">
								<a href="${appUrl }/usr/member/showMine">
									<span>${loginedMember.getNickname()}님</span>
								</a>
							</li>
							<li class="logout">
								<a href="${appUrl }/usr/member/doLogout"> 
									<i class="fas fa-sign-out-alt"></i>
									<span>로그아웃</span>
								</a>
							</li>
						</c:if>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<!-- 탑바 끝 -->

	<!-- 상단배너박스 시작 -->
	<div class="top-banner-box active-on-visible">
		<div class="txt-box-group">
			<div class="txt-box-1">
				<h1>나의 이야기로</h1>
				<h1>시작되어</h1>
				<h2>새로운 지식를 향해 나아갑니다.</h2>
			</div>

			<div class="txt-box-2">
				<span>CHILLAX</span><br> <span>BLOG</span>
			</div>
		</div>

		<div class="img-box">
			<img src="${pageContext.request.contextPath}/image/firstImage.jpg" alt="">
		</div>
	</div>
	<!-- 상단배너박스 끝 -->


	<!-- 블로그소개배너박스 시작 -->
	<div class="blog-info-banner-box active-on-visible">
		<div class="con flex flex-jc-sb">
			<div class="txt-box flex flex-ai-c">
				<div>
					<h1 class="nowrap blog-info-banner-box__slogan">차분하게 기록하다</h1>
					<div class="des nowrap">
						완벽하게 출발하지 않고 무엇을 쓰려고 하며 <br> 어떻게 이야기 하고 싶은지 왜 이야기하고 싶은지<br>
						생각을 통해 새로운 지식으로 발견합니다.
					</div>
					<div class="btn-box">
						<a href="${appUrl }/usr/article/list?boardId=1" class="btn-go-to-blog-info">게시판 바로가기</a>
					</div>
				</div>
			</div>
			<div class="img-box">
				<img src="${pageContext.request.contextPath}/image/relax.png" alt="">
			</div>
		</div>
	</div>
	<!-- 블로그소개배너박스 끝 -->


	<!-- 이슈배너박스 시작 -->
	<div class="issue-banner-box active-on-visible relative">
		<div class="txt-box absolute-middle absolute-center text-align-center">
			<div class="title">
				IT Issue <strong>확인하기</strong>
			</div>
			<a href="${appUrl }/usr/article/list?boardId=7" class="btn-go-recruit">이슈 정보</a>
		</div>
	</div>
	<!-- 이슈모집배너박스 끝 -->

	<!-- 하단 바 시작 -->
	<footer class="bottom-bar con-min-width flex flex-jc-c">
		<div>
			<span>명칭: CHILLAX Blog</span>
		</div>
		<div>
			<span>대표자: Ju young, developer</span>
		</div>
		<div>
			<span>주소: 대한민국 대전광역시 유성구</span>
		</div>
		<div>
			<span>연락처 : glory20220j@gmail.com</span>
		</div>
	</footer>
	<!-- 하단 바 끝 -->

</body>

</html>