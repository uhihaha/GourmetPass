<%-- WEB-INF/views/member/signup_general.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title"><spring:message code="member.signup.general.title" text="?뫀 ?쇰컲 ?뚯썝媛?? /></div>
    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>
    <c:if test="${socialSignup}">
        <div class="alert-msg"><spring:message code="member.signup.social.autofill.basic" text="?뚯뀥 濡쒓렇???뺣낫濡?湲곕낯 ??ぉ???먮룞 ?낅젰?⑸땲??" /></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/member/joinProcess" method="post" id="joinForm">
        <%-- CSRF 蹂댁븞 諛?醫뚰몴 ??μ슜 ?④? ?꾨뱶 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="user_lat" id="user_lat" value="0.0">
        <input type="hidden" name="user_lon" id="user_lon" value="0.0">
        <input type="hidden" name="skip_email_auth" value="true">
        <c:if test="${socialSignup}">
            <input type="hidden" name="social_signup" value="true">
        </c:if>

        <table class="edit-table">
            <tr>
                <th><spring:message code="member.user_id" text="?꾩씠?? /></th>
                <td>
                    <div class="input-row">
                        <%-- 媛???섏씠吏??readonly媛 ?꾨땲誘濡?member-signup.js?먯꽌 以묐났?뺤씤??媛뺤젣??[cite: 19] --%>
                        <input type="text" name="user_id" id="user_id" required placeholder="<spring:message code='member.placeholder.id_min' text='?곷Ц/?レ옄/?몃뜑諛?4~20?? />"
                               value="${socialUserId}" <c:if test="${socialSignup}">readonly</c:if>>
                        <c:if test="${not socialSignup}">
                            <button type="button" id="btnIdCheck" class="btn-wire"><spring:message code="member.btn.id_check" text="以묐났?뺤씤" /></button>
                        </c:if>
                    </div>
                    <div id="idCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.user_pw" text="鍮꾨?踰덊샇" /></th>
                <td>
                    <input type="password" name="user_pw" id="user_pw" required placeholder="<spring:message code='member.placeholder.pw' text='?곷Ц/?レ옄/?뱀닔臾몄옄 ?ы븿 8~20?? />"
                           value="${socialPassword}" <c:if test="${socialSignup}">readonly</c:if>>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.user_pw_confirm" text="鍮꾨?踰덊샇 ?뺤씤" /></th>
                <td>
                    <input type="password" id="user_pw_confirm" required placeholder="<spring:message code='member.placeholder.pw_confirm' text='鍮꾨?踰덊샇 ?ъ엯?? />"
                           value="${socialPassword}" <c:if test="${socialSignup}">readonly</c:if>>
                    <div id="pwCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.user_nm" text="?대쫫" /></th>
                <td><input type="text" name="user_nm" required placeholder="<spring:message code='member.placeholder.name' text='?깊븿???낅젰?섏꽭?? />" value="${socialName}"></td>
            </tr>
            <tr>
                <th><spring:message code="member.user_tel" text="?꾪솕踰덊샇" /></th>
                <td>
                    <input type="text" name="user_tel" <c:if test="${not socialSignup}">required</c:if>
                           placeholder="<spring:message code='member.placeholder.tel' text='?レ옄留??낅젰' />" maxlength="13" oninput="autoHyphen(this)">
                </td>
            </tr>
            
            <%-- ?대찓???몄쬆 ?뱀뀡 --%>
            <tr>
                <th><spring:message code="member.user_email" text="?대찓?? /></th>
                <td>
                    <div class="input-row">
                        <input type="email" name="user_email" id="user_email"
                               <c:if test="${not socialSignup}">required</c:if> placeholder="<spring:message code='member.placeholder.email' text='example@mail.com' />"
                               value="${socialEmail}" <c:if test="${socialSignup and not empty socialEmail}">readonly</c:if>>
                        <button type="button" id="btnEmailAuth" class="btn-wire"
                                <c:if test="${socialSignup}">disabled</c:if>><spring:message code="member.btn.email_auth" text="?몄쬆肄붾뱶 諛쒖넚" /></button>
                    </div>
                    <div id="emailMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.auth_code" text="?몄쬆肄붾뱶" /></th>
                <td>
                    <div class="input-row">
                        <input type="text" id="auth_code" disabled placeholder="<spring:message code='member.placeholder.auth_code' text='?몄쬆肄붾뱶 6?먮━' />" maxlength="6"
                               <c:if test="${socialSignup}">value="SOCIAL"</c:if>>
                        <span id="timer" style="color:red; margin-left:10px; font-weight:bold;"></span>
                    </div>
                    <div id="authMsg" class="msg-box"></div>
                </td>
            </tr>

            <tr>
                <th><spring:message code="member.user_addr" text="二쇱냼" /></th>
                <td>
                    <div class="input-row mb-10">
                        <input type="text" name="user_zip" id="user_zip" style="width: 120px; flex: none;" placeholder="<spring:message code='member.zip_code' text='?고렪踰덊샇' />" readonly>
                        <button type="button" onclick="execDaumPostcode('user')" class="btn-wire"><spring:message code="member.btn.addr_search" text="二쇱냼寃?? /></button>
                    </div>
                    <input type="text" name="user_addr1" id="user_addr1" class="mb-10" placeholder="<spring:message code='member.addr1' text='湲곕낯二쇱냼' />" readonly>
                    <input type="text" name="user_addr2" id="user_addr2" placeholder="<spring:message code='member.placeholder.addr2' text='?곸꽭二쇱냼瑜??낅젰?섏꽭?? />">
                    <div id="coordStatus" class="msg-box msg-ok"><spring:message code="member.msg.coord_auto" text="二쇱냼 寃????醫뚰몴媛 ?먮룞 ?ㅼ젙?⑸땲??" /></div>
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit" id="btnSubmit"><spring:message code="member.btn.signup" text="媛?낇븯湲? /></button>
            <a href="${pageContext.request.contextPath}/" class="btn-cancel"><spring:message code="common.btn.cancel" text="痍⑥냼" /></a>
        </div>
    </form>
</div>

<%-- ?몃? API 諛?怨듯넻 ?ㅽ겕由쏀듃 --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    window.I18N = window.I18N || {};
    window.I18N.address = {
        coordSuccess: "<spring:message code='address.coord.success' text='Coordinates saved.' javaScriptEscape='true' />",
        coordFail: "<spring:message code='address.coord.fail' text='Failed to get coordinates.' javaScriptEscape='true' />"
    };
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
<script src="<c:url value='/resources/js/address-api.js'/>"></script>
<script src="<c:url value='/resources/js/common.js'/>"></script>

<script type="text/javascript">
    <%-- ?꾩뿭 ?ㅼ젙 媛앹껜 --%>
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>

<%-- ?듯빀??媛??寃利??ㅽ겕由쏀듃 (member.js 以묐났 ?몄텧 湲덉?) --%>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
