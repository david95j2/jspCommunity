# JSP를 이용한 MVC Model 2 방식의 개발자 게시판 개발하기.
 
 JSP와 Servlet 동시에 사용하는 MVC모델(View는 JSP, Controller는 Servlet을 사용)
 
 Java Servlet + JSP 방식
 
 Gradle이 아닌 Maven으로 빌드하기
 
 <br>
 
   <img src="https://mblogthumb-phinf.pstatic.net/MjAxNzEwMzBfMjkw/MDAxNTA5MzQ1NDM0ODM2.40qv0x-SJdITWEUFVSw0qzCGM1ZISOxkaC5ClBYxOMIg.TrKmJH-Y7_IX0gwqNEQYqn9WS_GEh9Bk20jMEwSJzGgg.PNG.acornedu/jsp.png?type=w800" width="400" height="300" text-align="center"/>
   
---

# 완료리스트
- [x] 프레임워크 기초
- [x] 로그인/로그아웃
- [x] 회원가입
- [x] 게시글 CRUD
- [x] 인터셉터
- [x] 로그인/로그아웃 상태 관련 권한체크
- [x] 게시물 수정/삭제 관련 권한체크
- [x] 비밀번호 암호화
- [x] 아이디찾기
- [x] 비번찾기(임시패스워드 발송)
- [x] 게시물 페이징
- [x] 게시물 검색
- [x] 토스트 에디터 붙이기
- [x] 헤더/푸터 꾸미기
- [x] 좋아요, 싫어요
- [x] 한방배포
- [x] 댓글
- [x] 댓글, ajax화
- [x] 대댓글
- [x] 게시물 블라인드


# 당장 할일 리스트
- [ ] 내 글에 새 댓글 알림
- [ ] 내 댓글에 추가 댓글 알림
- [ ] 댓글멘션

# 추후 할일 리스트
- [ ] 태그
- [ ] 파일업로드
- [ ] 회원인증
- [ ] 관리자페이지
- [ ] 1:1 쪽지
- [ ] 신고

# 메이븐 settings.xml 템플릿
```
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
    <servers>
        <server>
            <id>devly__manager_text</id>
            <username>톰캣 웹 관리자의 계정명</username>
            <password>톰캣 웹 관리자의 계정비밀번호</password>
        </server>
    </servers>
</settings>
```

# 주요 명령어
- DB export
    - cmd 접속
    - c:\xampp\mysql\bin\mysqldump.exe --databases -u sbsst -p jspCommunity > C:\work\sts-4.9.0.RELEASE-workspace\jspCommunity\current.sql
