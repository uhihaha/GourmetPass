<%-- WEB-INF/views/member/login.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<%-- ?뚮┝ ?곗씠??蹂닿?: ?듯빀 ?ㅽ겕由쏀듃媛 ???곗씠?곕? ?쎌뼱 alert???꾩썎?덈떎 --%>
<div id="auth-msg" data-error="${param.error}" data-logout="${param.logout}"></div>

<div class="login-wrapper">
    <div class="login-title"><spring:message code="member.login.title" text="GOURMET PASS" /></div>
    
    <form action="${pageContext.request.contextPath}/login" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <div class="form-group">
            <label><spring:message code="member.login.id" text="?꾩씠?? /></label>
            <input type="text" name="username" class="login-input" required placeholder="<spring:message code='member.login.id.ph' text='?꾩씠?붾? ?낅젰?섏꽭?? />">
        </div>

        <div class="form-group">
            <label><spring:message code="member.login.pw" text="鍮꾨?踰덊샇" /></label>
            <input type="password" name="password" class="login-input" required placeholder="<spring:message code='member.login.pw.ph' text='鍮꾨?踰덊샇瑜??낅젰?섏꽭?? />">
        </div>

    <div class="btn-group">
        <button type="submit" class="btn-login"><spring:message code="member.login.btn" text="濡쒓렇?? /></button>
        <a href="<c:url value='/member/signup/select'/>" class="btn-signup"><spring:message code="member.login.signup" text="?뚯썝媛?? /></a>
    </div>
    </form>
    
    <div class="social-login">
        <div class="social-title"><spring:message code="member.login.social.title" text="媛꾪렪 濡쒓렇?? /></div>
        <div class="social-buttons">
            <a class="social-btn kakao" href="<c:url value='/member/oauth/kakao'/>"><spring:message code="member.login.social.kakao" text="移댁뭅?ㅻ줈 濡쒓렇?? /></a>
            <a class="social-btn google" href="<c:url value='/member/oauth/google'/>"><spring:message code="member.login.social.google" text="援ш?濡?濡쒓렇?? /></a>
        </div>
    </div>

    <div style="margin-top: 25px; font-size: 13px; color: #999;">
        <a href="<c:url value='/member/find'/>" style="text-decoration: underline;"><spring:message code="member.login.forgot" text="?꾩씠??鍮꾨?踰덊샇瑜??딆쑝?⑤굹??" /></a>
    </div>
</div>

<script>
    window.I18N = window.I18N || {};
    window.I18N.member = {
        loginError: "<spring:message code='member.login.msg.error' text='Invalid username or password.' javaScriptEscape='true' />",
        logoutSuccess: "<spring:message code='member.login.msg.logout' text='Logged out successfully.' javaScriptEscape='true' />",
        idRule: "<spring:message code='member.js.id_rule' text='ID must be 4-20 letters/numbers/_.' javaScriptEscape='true' />",
        idAvailable: "<spring:message code='member.js.id_available' text='ID is available.' javaScriptEscape='true' />",
        idInvalid: "<spring:message code='member.js.id_invalid' text='Invalid ID format.' javaScriptEscape='true' />",
        idInUse: "<spring:message code='member.js.id_in_use' text='ID is already in use.' javaScriptEscape='true' />",
        serverError: "<spring:message code='member.js.server_error' text='Server communication error.' javaScriptEscape='true' />",
        pwRule: "<spring:message code='member.js.pw_rule' text='Password must be 8-20 chars with letters/numbers/symbols.' javaScriptEscape='true' />",
        pwMatch: "<spring:message code='member.js.pw_match' text='Passwords match.' javaScriptEscape='true' />",
        pwMismatch: "<spring:message code='member.js.pw_mismatch' text='Passwords do not match.' javaScriptEscape='true' />",
        emailChangeAuth: "<spring:message code='member.js.email_change_auth' text='Email change requires verification.' javaScriptEscape='true' />",
        emailRequired: "<spring:message code='member.js.email_required' text='Please enter email.' javaScriptEscape='true' />",
        emailAuthSent: "<spring:message code='member.js.email_auth_sent' text='Verification code sent.' javaScriptEscape='true' />",
        emailSendFail: "<spring:message code='member.js.email_send_fail' text='Failed to send email.' javaScriptEscape='true' />",
        authSuccess: "<spring:message code='member.js.auth_success' text='Verification successful.' javaScriptEscape='true' />",
        authMismatch: "<spring:message code='member.js.auth_mismatch' text='Verification code mismatch.' javaScriptEscape='true' />",
        timerExpired: "<spring:message code='member.js.timer_expired' text='Time expired.' javaScriptEscape='true' />",
        idCheckRequired: "<spring:message code='member.js.id_check_required' text='Please check ID availability.' javaScriptEscape='true' />",
        pwCheckRequired: "<spring:message code='member.js.pw_check_required' text='Please confirm password.' javaScriptEscape='true' />",
        emailAuthRequired: "<spring:message code='member.js.email_auth_required' text='Please complete email verification.' javaScriptEscape='true' />",
        storeCoordRequired: "<spring:message code='member.js.store_coord_required' text='Please set store coordinates after address search.' javaScriptEscape='true' />",
        withdrawConfirm: "<spring:message code='member.js.withdraw_confirm' text='Withdraw? All bookings and waits will be removed.' javaScriptEscape='true' />",
        idMinLength: "<spring:message code='member.js.id_min_length' text='ID must be at least 3 characters.' javaScriptEscape='true' />",
        idCheckPrompt: "<spring:message code='member.js.id_check_prompt' text='Please run ID check.' javaScriptEscape='true' />",
        pwMismatchAlert: "<spring:message code='member.js.pw_mismatch_alert' text='Password confirmation does not match.' javaScriptEscape='true' />",
        storeLocationRequired: "<spring:message code='member.js.store_location_required' text='Please confirm store location after address search.' javaScriptEscape='true' />",
        withdrawConfirmSimple: "<spring:message code='member.js.withdraw_confirm_simple' text='Withdraw? All bookings and waits will be removed.' javaScriptEscape='true' />"
    };
</script>
<%-- [援먯젙] APP_CONFIG ?좎뼵: member-signup.js ?댁쓽 李몄“ ?먮윭 諛⑹? --%>
<script type="text/javascript">
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>

<%-- [援먯젙] member.js ????듯빀??member-signup.js ?곌껐 --%>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
