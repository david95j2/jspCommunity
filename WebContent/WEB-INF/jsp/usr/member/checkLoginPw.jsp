<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="비밀번호 확인" />
<%@ include file="../../part/head.jspf"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<div class="title-bar padding-0-10 con-min-width">
	<h1 class="con">
		<span>
			<i class="far fa-user-circle"></i>
		</span>
		<span>${pageTitle}</span>
	</h1>
</div>

<div class="find-login-pw-form-box form-box padding-0-10 con-min-width">
	<script>
	let DoCheckLoginPw__submited = false;
	function DoCheckLoginPw__submit(form) {
		if ( DoCheckLoginPw__submited ) {
			alert('처리중입니다.');
			return;
		}
		
		form.loginPw.value = form.loginPw.value.trim();
		
		if ( form.loginPw.value.length == 0 ) {
			alert('로그인 비밀번호를 입력해주세요.');
			form.loginPw.focus();
			
			return;
		}
		
		form.loginPwReal.value = sha256(form.loginPw.value);
		form.url.value = "${param.listUrl}";
		
		form.loginPw.value = "";
		
		form.submit();
		DoCheckLoginPw__submited = true;
	}
	</script>
	<form class="con" action="doCheckLoginPw" method="POST"
		onsubmit="DoCheckLoginPw__submit(this); return false;">
		<input type="hidden" name="loginPwReal" />
		<input type="hidden" name="url"> 
		<table>
			<colgroup>
				<col width="150">
			</colgroup>
			<tbody>
				<tr>
					<th>
						<span>비밀번호</span>
					</th>
					<td>
						<div>
							<input name="loginPw" type="password" maxlength="50"
								placeholder="비밀번호를 입력해주세요." />
						</div>
					</td>
				</tr>

				<tr>
					<th>
						<span></span>
					</th>
					<td>
						<div>
							<div class="btn-wrap">
								<input class="btn btn-primary hov-red" type="submit" value="확인" />
								<button class="btn btn-info hov-red" type="button"
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