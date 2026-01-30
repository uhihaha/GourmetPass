<%-- 
    GourmetPass 프로젝트: 로그인 페이지
    - [해결] 500 에러 방지를 위해 spring:message에 text 속성(Fallback) 추가
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="login-container">
    <div class="login-wrapper">
        <%-- text 속성은 키를 찾지 못했을 때 보여줄 기본값입니다 --%>
        <h1 class="login-title"><spring:message code="common.logo" text="GOURMET PASS" /></h1>
        <p class="login-subtitle"><spring:message code="member.login.subtitle" text="미식의 시작, 고메패스" /></p>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <div class="form-group">
                <label for="username"><spring:message code="member.login.id" text="아이디" /></label>
                <input type="text" id="username" name="username" class="login-input" 
                       required placeholder="<spring:message code='member.login.id.ph' text='아이디를 입력하세요' />" autofocus>
            </div>

            <div class="form-group">
                <label for="password"><spring:message code="member.login.pw" text="비밀번호" /></label>
                <input type="password" id="password" name="password" class="login-input" 
                       required placeholder="<spring:message code='member.login.pw.ph' text='비밀번호를 입력하세요' />">
            </div>

            <div class="auth-options">
                <label class="remember-me">
                    <input type="checkbox" name="remember-me"> <spring:message code="member.login.remember_me" text="로그인 상태 유지" />
                </label>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-login"><spring:message code="member.login.btn" text="로그인" /></button>
                <a href="<c:url value='/member/signup/select'/>" class="btn-signup">
                    <spring:message code="member.signup.btn" text="회원가입" />
                </a>
            </div>
        </form>

        <div class="find-account">
            <a href="#"><spring:message code="member.login.find_id" text="아이디 찾기" /></a>
            <span class="divider">|</span>
            <a href="#"><spring:message code="member.login.reset_pw" text="비밀번호 재설정" /></a>
        </div>
    </div>
</div>

<div id="auth-msg" 
     data-error="${param.error}" 
     data-logout="${param.logout}" 
     style="display:none;"></div>

<script type="text/javascript">
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };

    window.addEventListener('load', function() {
        const msgDiv = document.getElementById('auth-msg');
        if (msgDiv.dataset.error === "true") {
            alert("<spring:message code='member.login.msg.error' text='아이디 또는 비밀번호가 일치하지 않습니다.' />");
        } else if (msgDiv.dataset.logout === "true") {
            alert("<spring:message code='member.login.msg.logout' text='정상적으로 로그아웃되었습니다.' />");
        }
    });
</script>

<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

<jsp:include page="../common/footer.jsp" />