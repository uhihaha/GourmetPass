<%-- WEB-INF/views/member/find_account.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title"><spring:message code="member.find.title" text="?뵊 ?꾩씠??鍮꾨?踰덊샇 李얘린" /></div>

    <div class="find-section">
        <h3><spring:message code="member.find.id.title" text="?꾩씠??李얘린" /></h3>
        <form action="<c:url value='/member/find/id'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="form-group">
                <label><spring:message code="member.user_nm" text="?대쫫" /></label>
                <input type="text" name="user_nm" required placeholder="<spring:message code='member.find.placeholder.name' text='媛?????낅젰???대쫫' />">
            </div>
            <div class="form-group">
                <label><spring:message code="member.user_email" text="?대찓?? /></label>
                <input type="email" name="user_email" required placeholder="<spring:message code='member.placeholder.email' text='example@mail.com' />">
            </div>
            <div class="btn-group">
                <button type="submit" class="btn-submit"><spring:message code="member.find.btn.id" text="?꾩씠??李얘린" /></button>
            </div>
        </form>
        <c:if test="${not empty idResult}">
            <div class="find-result msg-ok">
                <spring:message code="member.find.id.result" arguments="${idResult}" text="?뚯썝?섏쓽 ?꾩씠?붾뒗 {0} ?낅땲??" />
            </div>
        </c:if>
        <c:if test="${not empty idError}">
            <div class="find-result msg-no">${idError}</div>
        </c:if>
    </div>

    <div class="find-section">
        <h3><spring:message code="member.find.pw.title" text="鍮꾨?踰덊샇 ?ъ꽕?? /></h3>
        <form action="<c:url value='/member/find/password'/>" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="form-group">
                <label><spring:message code="member.user_id" text="?꾩씠?? /></label>
                <input type="text" name="user_id" id="pw_user_id" required placeholder="<spring:message code='member.find.placeholder.id' text='?꾩씠???낅젰' />">
            </div>
            <div class="form-group">
                <label><spring:message code="member.user_email" text="?대찓?? /></label>
                <input type="email" name="user_email" id="pw_user_email" required placeholder="<spring:message code='member.placeholder.email' text='example@mail.com' />">
            </div>
            <div class="form-group">
                <button type="button" id="btnPwAuth" class="btn-wire"><spring:message code="member.btn.email_auth" text="?몄쬆肄붾뱶 諛쒖넚" /></button>
                <div id="pwAuthMsg" class="msg-box"></div>
            </div>
            <div class="form-group">
                <label><spring:message code="member.auth_code" text="?몄쬆肄붾뱶" /></label>
                <input type="text" name="auth_code" id="pw_auth_code" required placeholder="<spring:message code='member.find.placeholder.auth' text='?대찓?쇰줈 諛쏆? ?몄쬆肄붾뱶' />">
            </div>
            <div class="btn-group">
                <button type="submit" class="btn-submit"><spring:message code="member.find.btn.temp_pw" text="?꾩떆 鍮꾨?踰덊샇 諛쒓툒" /></button>
            </div>
        </form>
        <c:if test="${not empty pwResult}">
            <div class="find-result msg-ok">
                ${pwResult}
                <div class="mt-10"><spring:message code="member.find.pw.after" text="濡쒓렇????諛섎뱶??鍮꾨?踰덊샇瑜?蹂寃쏀빐二쇱꽭??" /></div>
            </div>
        </c:if>
        <c:if test="${not empty pwError}">
            <div class="find-result msg-no">${pwError}</div>
        </c:if>
    </div>

    <div class="btn-group">
        <a href="<c:url value='/member/login'/>" class="btn-cancel"><spring:message code="member.find.btn.back_login" text="濡쒓렇?몄쑝濡??뚯븘媛湲? /></a>
    </div>
</div>

<script type="text/javascript">
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>
<script>
    window.I18N = window.I18N || {};
    window.I18N.memberFind = {
        authMissing: "<spring:message code='member.find.auth.missing' text='Please enter ID or email.' javaScriptEscape='true' />",
        authSent: "<spring:message code='member.find.auth.sent' text='Verification code sent.' javaScriptEscape='true' />",
        authNotFound: "<spring:message code='member.find.auth.not_found' text='Account not found.' javaScriptEscape='true' />",
        authUnavailable: "<spring:message code='member.find.auth.unavailable' text='Request cannot be processed.' javaScriptEscape='true' />",
        authServerError: "<spring:message code='member.find.auth.server_error' text='Server communication error.' javaScriptEscape='true' />"
    };
</script>
<script src="<c:url value='/resources/js/member-find.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
