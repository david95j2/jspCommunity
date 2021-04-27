<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="회원정보수정" />
<%@ include file="../../part/head.jspf"%>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>

<div class="title-bar padding-0-10 con-min-width">
	<h1 class="con">
		<span>
			<i class="fas fa-user"></i>
		</span>
		<span>${pageTitle}</span>
	</h1>
</div>

<div class="modify-form-box form-box padding-0-10 con-min-width">
	<script>
	let DoModifyForm__submited = false;
	let DoModifyForm__checkedLoginId = "";
	
	// 폼 발송전 체크
	function DoModifyForm__submit(form) {
		if ( DoModifyForm__submited ) {
			alert('처리중입니다.');
			return;
		}
		
		form.loginPw.value = form.loginPw.value.trim();
	
		if ( form.loginPw.value.length > 0 ) {
			form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
		
			if ( form.loginPwConfirm.value.length == 0 ) {
				alert('로그인 비밀번호 확인을 입력해주세요.');
				form.loginPwConfirm.focus();
				
				return;
			}
			
			if ( form.loginPw.value != form.loginPwConfirm.value ) {
				alert('로그인 비밀번호가 일치하지 않습니다.');
				form.loginPwConfirm.focus();
				
				return;
			}
		}
		
		form.name.value = form.name.value.trim();
	
		if ( form.name.value.length == 0 ) {
			alert('이름을 입력해주세요.');
			form.name.focus();
			
			return;
		}
		
		form.nickname.value = form.nickname.value.trim();
	
		if ( form.nickname.value.length == 0 ) {
			alert('별명을 입력해주세요.');
			form.nickname.focus();
			
			return;
		}
		
		form.email.value = form.email.value.trim();
	
		if ( form.email.value.length == 0 ) {
			alert('이메일을 입력해주세요.');
			form.email.focus();
			
			return;
		}
		
		form.cellphoneNo.value = form.cellphoneNo.value.trim();
	
		if ( form.cellphoneNo.value.length == 0 ) {
			alert('전화번호를 입력해주세요.');
			form.cellphoneNo.focus();
			
			return;
		}
		
		if ( form.loginPw.value.length > 0 ) {
			form.loginPwReal.value = sha256(form.loginPw.value);
			form.loginPw.value = "";
			form.loginPwConfirm.value = "";
		}
		
		form.submit();
		DoModifyForm__submited = true;
	}
	</script>
	<script>
	function doMailAuth(){
		const memberId = ${loginedMemberId};
		const authCode = "${param.authCode}";
		$.post(
			"${appUrl}/usr/member/doMailAuth",
			{
				memberId,
				authCode
			},
			function(data) {
				if(data.success){
					alert("메일이 발송되었습니다.");
					$('.btn-mail').contents().unwrap().wrap('<span class="examined-text" style="color:red">메일을 확인해주세요.</span>');
    				$('span').remove('.temp-text');
				} else {
					alert("메일 발송이 실패하였습니다.");
				}
			},
			"json"
		);
	}
	
    $(function () {
    	const memberId = ${loginedMemberId};
    	const memberEmail = "${loginedMember.getEmail()}";
    	
    	$("#email-input-box").on("change", function () {
        	msg = "변경된 이메일로 인증메일이 발송됩니다.";
            if (confirm(msg)!=0) {
                // Yes click
                const email = $("#email-input-box").val();
            	$.post(
            		"${appUrl}/usr/member/doReissuanceAuthCode",
            		{
            			memberId,
            			email
            		},
            		function(data) {
            			if(data.success){
            				alert('메일이 발송되었습니다.');
            				$('.btn-mail').contents().unwrap().wrap('<span class="examined-text" style="color:red">메일을 확인해주세요.</span>');
            				$('span').remove('.temp-text');
            			} else {
            				alert('메일 발송이 실패하였습니다.');
            			}
            		},
            		"json"
            	);
            } else {
                // no click
            	$("#email-input-box").val(memberEmail);
    		}
        });
    });
	</script>
	<form class="con" action="doModify" method="POST"
		onsubmit="DoModifyForm__submit(this); return false;">
		<input type="hidden" name="loginPwReal" />
		<input type="hidden" name="authCode" />
		<table>
			<colgroup>
				<col width="150">
			</colgroup>
			<tbody>
				<tr>
					<th>
						<span>로그인 아이디</span>
					</th>
					<td>
						<div>${loginedMember.loginId}</div>
					</td>
				</tr>

				<tr>
					<th>
						<span>로그인 비번</span>
					</th>
					<td>
						<div>
							<input name="loginPw" type="password" maxlength="50"
								placeholder="로그인 비밀번호를 입력해주세요." />
						</div>
					</td>
				</tr>

				<tr>
					<th>
						<span>로그인 비밀번호 확인</span>
					</th>
					<td>
						<div>
							<input name="loginPwConfirm" type="password" maxlength="50"
								placeholder="로그인 비밀번호 확인을 입력해주세요." />
						</div>
					</td>
				</tr>

				<tr>
					<th>
						<span>이름</span>
					</th>
					<td>
						<div>
							<input name="name" type="text" maxlength="50"
								placeholder="이름을 입력해주세요." value="${loginedMember.name}" />
						</div>
					</td>
				</tr>

				<tr>
					<th>
						<span>별명</span>
					</th>
					<td>
						<div>
							<input name="nickname" type="text" maxlength="50"
								placeholder="별명을 입력해주세요." value="${loginedMember.nickname}" />
						</div>
					</td>
				</tr>

				<tr>
					<th>
						<span>이메일</span>
					</th>
					<td>
						<div>
							<input id="email-input-box" name="email" type="email" maxlength="100"
								placeholder="이메일을 입력해주세요." value="${loginedMember.email}" />
							<c:if test="${isExamined == 0}">
								<button class="btn btn-mail" onclick="doMailAuth()"
										name="authCode" type="button" value=""><span class="temp-text">이메일 인증</span></button>
							</c:if>
							<c:if test="${isExamined == 1}">
								<span class="examined-text">인증된 메일</span>
							</c:if>
						</div>
					</td>
				</tr>

				<tr>
					<th>
						<span>전화번호</span>
					</th>
					<td>
						<div>
							<input name="cellphoneNo" type="tel" maxlength="100"
								placeholder="전화번호를 입력해주세요." value="${loginedMember.cellphoneNo}" />
						</div>
					</td>
				</tr>

				<tr>
					<th>
						<span>회원정보수정</span>
					</th>
					<td>
						<div>
							<div class="btn-wrap">
								<div style="flex : auto;">
									<input class="btn btn-primary" type="submit" value="수정" />
									<button class="btn btn-info" type="button" onclick="history.back();">뒤로가기</button>
								</div>
								<a class="btn btn-delete-myAccount" href="${appUrl }/usr/member/showCheckLoginPw?listUrl=${currentUrl}"
								 onclick="return confirm('계정을 삭제하시겠습니까?');">계정 삭제</a>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>
<%@ include file="../../part/foot.jspf"%>