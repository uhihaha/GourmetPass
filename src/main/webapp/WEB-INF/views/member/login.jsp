<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- [1] 공통 헤더 삽입 --%>
<jsp:include page="../common/header.jsp" />

<%-- [2] 공통 스타일 적용 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<style>
    /* 로그인 전용 추가 정렬 스타일 */
    .login-wrapper {
        width: 80%;
        max-width: 450px;
        margin: 80px auto;
        padding: 40px;
        border: 2px solid #333;
        border-radius: 15px;
        background: #fff;
        text-align: center;
    }

    .login-title {
        margin-bottom: 30px;
        font-size: 24px;
        font-weight: bold;
    }

    .form-group {
        text-align: left;
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-size: 14px;
        font-weight: bold;
        margin-bottom: 8px;
    }

    .login-input {
        width: 100%;
        padding: 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-sizing: border-box;
        font-size: 16px;
    }

    .login-input:focus {
        border-color: #333;
        outline: none;
    }

    /* [교정] 버튼 그룹: 가로 정렬 및 간격 설정 */
    .btn-group {
        display: flex;
        flex-direction: row;
        gap: 12px;
        margin-top: 30px;
        width: 100%;
    }

    /* [교정] 버튼 공통: flex: 1을 부여하여 동일한 너비 확보 */
    .btn-login, .btn-signup {
        flex: 1;
        padding: 15px 0;
        border-radius: 8px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        box-sizing: border-box;
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
        height: 50px; /* 높이 고정으로 완벽한 대칭 */
    }

    .btn-login {
        background: #333;
        color: #fff;
        border: none;
    }

    .btn-login:hover {
        background: #000;
    }

    .btn-signup {
        background: #fff;
        color: #333;
        border: 1px solid #333;
        text-decoration: none;
    }

    .btn-signup:hover {
        background: #f8f8f8;
    }
</style>

<%-- [3] 로그인 메시지 처리 --%>
<c:if test="${not empty param.error}">
    <script>alert("아이디 또는 비밀번호가 잘못되었습니다.");</script>
</c:if>

<c:if test="${not empty param.logout}">
    <script>alert("성공적으로 로그아웃되었습니다. 이용해 주셔서 감사합니다.");</script>
</c:if>

<%-- [4] 로그인 폼 섹션 --%>
<div class="login-wrapper">
    <div class="login-title">🏠 Gourmet Pass 로그인</div>
    
    <form action="${pageContext.request.contextPath}/login" method="post">
        <%-- CSRF 토큰 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <div class="form-group">
            <label>아이디</label>
            <input type="text" name="username" class="login-input" required placeholder="아이디를 입력하세요">
        </div>

        <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="password" class="login-input" required placeholder="비밀번호를 입력하세요">
        </div>

        <div class="btn-group">
            <button type="submit" class="btn-login">로그인</button>
            
            <%-- 회원가입 버튼 (URL 오타 수정: select} -> select) --%>
            <a href="${pageContext.request.contextPath}/member/signup/select" class="btn-signup">
                회원가입
            </a>
        </div>
    </form>
</div>

<%-- [5] 공통 푸터 삽입 --%>
<jsp:include page="../common/footer.jsp" />