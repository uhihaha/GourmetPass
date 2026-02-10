<%-- WEB-INF/views/member/login.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<%-- 
    [교정] 알림 데이터 보관 영역 
    member-signup.js가 로드될 때 data-error와 data-logout을 읽어 다국어 alert을 띄웁니다.
--%>
<div id="auth-msg" data-error="${param.error}" data-logout="${param.logout}"></div>

<div class="login-wrapper">
    <div class="login-title">
        <spring:message code="member.login.title" text="GOURMET PASS" />
    </div>
    
    <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <div class="form-group">
            <label><spring:message code="member.login.id" text="아이디" /></label>
            <%-- id="username" 추가: JS에서 검증 메시지 주입을 위해 필요합니다. --%>
            <input type="text" name="username" id="username" class="login-input" required 
                   placeholder="<spring:message code='member.login.id.ph' text='아이디를 입력하세요' />">
        </div>

        <div class="form-group">
            <label><spring:message code="member.login.pw" text="비밀번호" /></label>
            <%-- id="password" 추가: JS에서 검증 메시지 주입을 위해 필요합니다. --%>
            <input type="password" name="password" id="password" class="login-input" required 
                   placeholder="<spring:message code='member.login.pw.ph' text='비밀번호를 입력하세요' />">
        </div>

        <div class="btn-group">
            <button type="submit" class="btn-login">
                <spring:message code="member.login.btn" text="로그인" />
            </button>
            <a href="<c:url value='/member/signup/select'/>" class="btn-signup">
                <spring:message code="member.login.signup" text="회원가입" />
            </a>
        </div>
    </form>
    
    <div class="social-login">
        <div class="social-title">
            <spring:message code="member.login.social.title" text="간편 로그인" />
        </div>
        <div class="social-buttons">
            <a class="social-btn kakao" href="<c:url value='/member/oauth/kakao'/>">
                <spring:message code="member.login.social.kakao" text="카카오로 로그인" />
            </a>
            <a class="social-btn google" href="<c:url value='/member/oauth/google'/>">
                <spring:message code="member.login.social.google" text="구글로 로그인" />
            </a>
        </div>
    </div>

    <div style="margin-top: 25px; font-size: 13px; color: #999;">
        <a href="<c:url value='/member/find'/>" style="text-decoration: underline;">
            <spring:message code="member.login.forgot" text="아이디/비밀번호를 잊으셨나요?" />
        </a>
    </div>
</div>

<%-- [교정] APP_CONFIG 선언: contextPath와 CSRF 데이터를 JS 엔진에 전달합니다. --%>
<script type="text/javascript">
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>

<%-- 통합된 가입/검증/알림 스크립트 로드 --%>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

<%-- [추가] 로그인 페이지 전용 브라우저 검증 메시지 다국어화 --%>
<script type="text/javascript">
    $(document).ready(function() {
        var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
            ? window.I18N_UTIL.t
            : function(key, fallback) { return fallback || key; };

        const applyMsg = (id, key, fallback) => {
            const el = document.getElementById(id);
            if (el) {
                el.addEventListener("invalid", function() {
                    this.setCustomValidity(t(key, fallback));
                });
                el.addEventListener("input", function() {
                    this.setCustomValidity("");
                });
            }
        };

        // 이미지에서 확인된 '작성하세요' 메시지를 프로젝트 프로퍼티로 치환합니다.
        applyMsg("username", "signup.idRequired", "아이디를 입력해주세요.");
        applyMsg("password", "signup.pwRequired", "비밀번호를 입력해주세요.");
    });
</script>

<jsp:include page="../common/footer.jsp" />