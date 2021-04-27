<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="마이페이지" />
<%@ include file="../../part/head.jspf"%>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<div class="title-bar padding-0-10 con-min-width">
	<h1 class="con">
		<span> <i class="fas fa-user"></i>
		</span> <span>${pageTitle}</span>
	</h1>
</div>

<div class="form-box padding-0-10 con-min-width">
	<form class="con">
		<table>
			<colgroup>
				<col width="150">
			</colgroup>
			<tbody>
				<tr>
					<th><span>로그인 아이디</span></th>
					<td>
						<div>${loginedMember.loginId}</div>
					</td>
				</tr>
				<tr>
					<th><span>이름</span></th>
					<td>
						<div>${loginedMember.name }</div>
					</td>
				</tr>
				<tr>
					<th><span>별명</span></th>
					<td>
						<div>${loginedMember.nickname }</div>
					</td>
				</tr>
				<tr>
					<th><span>이메일</span></th>
					<td>
						<div>${loginedMember.email }</div>
					</td>
				</tr>
				<tr>
					<th><span>전화번호</span></th>
					<td>
						<div>${loginedMember.cellphoneNo }</div>
					</td>
				</tr>

				<tr>
					<th><span>회원정보수정</span></th>
					<td>
						<div>
							<div class="btn-wrap">
								<a href="${appUrl }/usr/member/showCheckLoginPw?listUrl=${currentUrl}" class="btn">회원정보수정</a>
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
<%@ include file="../../part/foot.jspf"%>