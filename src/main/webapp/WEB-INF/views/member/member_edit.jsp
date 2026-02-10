<%-- WEB-INF/views/member/member_edit.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title"><spring:message code="member.edit.title" text="?숋툘 ?뚯썝 ?뺣낫 ?섏젙" /></div>
    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>

    <form action="<c:url value='/member/edit'/>" method="post" id="joinForm">
        <%-- CSRF ?좏겙 諛??꾩튂 ?뺣낫 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="user_lat" id="user_lat" value="${member.user_lat}">
        <input type="hidden" name="user_lon" id="user_lon" value="${member.user_lon}">

        <table class="edit-table">
            <tr>
                <th><spring:message code="member.user_id" text="?꾩씠?? /></th>
                <td>
                    <%-- readonly ?띿꽦?쇰줈 ?명빐 member-signup.js?먯꽌 以묐났?뺤씤???먮룞 ?듦낵??--%>
                    <input type="text" name="user_id" id="user_id" value="${member.user_id}" readonly>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.edit.pw_change" text="??鍮꾨?踰덊샇" /></th>
                <td><input type="password" name="user_pw" id="user_pw" placeholder="<spring:message code='member.edit.pw_change.ph' text='蹂寃????곷Ц/?レ옄/?뱀닔臾몄옄 8~20?? />"></td>
            </tr>
            <tr>
                <th><spring:message code="member.user_pw_confirm" text="鍮꾨?踰덊샇 ?뺤씤" /></th>
                <td>
                    <input type="password" id="user_pw_confirm" placeholder="<spring:message code='member.placeholder.pw_confirm' text='鍮꾨?踰덊샇瑜???踰????낅젰?섏꽭?? />">
                    <div id="pwCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.user_nm" text="?깅챸" /></th>
                <td><input type="text" name="user_nm" value="${member.user_nm}" required placeholder="<spring:message code='member.placeholder.name' text='?깊븿???낅젰?섏꽭?? />"></td>
            </tr>
            <tr>
                <th><spring:message code="member.user_tel" text="?꾪솕踰덊샇" /></th>
                <td>
                    <input type="text" name="user_tel" value="${member.user_tel}" required 
                           oninput="autoHyphen(this)" maxlength="13" placeholder="<spring:message code='member.placeholder.tel' text='?レ옄留??낅젰' />">
                </td>
            </tr>

            <%-- ?대찓???몄쬆 ?뱀뀡 --%>
            <tr>
                <th><spring:message code="member.user_email" text="?대찓?? /></th>
                <td>
                    <div class="input-row">
                        <input type="email" name="user_email" id="user_email" value="${member.user_email}" required placeholder="<spring:message code='member.placeholder.email' text='example@mail.com' />">
                        <button type="button" id="btnEmailAuth" class="btn-wire"><spring:message code="member.btn.email_auth" text="?몄쬆肄붾뱶 諛쒖넚" /></button>
                    </div>
                    <div id="emailMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.auth_code" text="?몄쬆肄붾뱶" /></th>
                <td>
                    <div class="input-row">
                        <input type="text" id="auth_code" disabled placeholder="<spring:message code='member.placeholder.auth_code' text='?몄쬆肄붾뱶 6?먮━' />" maxlength="6">
                        <span id="timer" style="color:red; margin-left:10px; font-weight:bold;"></span>
                    </div>
                    <div id="authMsg" class="msg-box"></div>
                </td>
            </tr>

            <tr>
                <th><spring:message code="member.user_addr" text="二쇱냼" /></th>
                <td>
                    <div class="input-row mb-10">
                        <input type="text" name="user_zip" id="user_zip" value="${member.user_zip}" 
                               style="width: 120px; flex: none;" readonly placeholder="<spring:message code='member.zip_code' text='?고렪踰덊샇' />">
                        <button type="button" onclick="execDaumPostcode('user')" class="btn-wire"><spring:message code="member.btn.addr_search" text="二쇱냼寃?? /></button>
                    </div>
                    <input type="text" name="user_addr1" id="user_addr1" value="${member.user_addr1}" 
                           class="mb-10" readonly placeholder="<spring:message code='member.addr1' text='湲곕낯二쇱냼' />">
                    <input type="text" name="user_addr2" id="user_addr2" value="${member.user_addr2}" 
                           placeholder="<spring:message code='member.placeholder.addr2' text='?곸꽭 二쇱냼瑜??낅젰?섏꽭?? />">
                    <div id="coordStatus" class="msg-box msg-ok"><spring:message code="member.edit.msg.coord" text="二쇱냼 蹂寃????꾩튂 ?뺣낫媛 ?먮룞?쇰줈 媛깆떊?⑸땲??" /></div>
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit"><spring:message code="member.btn.update" text="?뺣낫 ?섏젙 ?꾨즺" /></button>
            <a href="<c:url value='/member/mypage'/>" class="btn-cancel"><spring:message code="common.btn.cancel" text="痍⑥냼" /></a>
        </div>
    </form>

    <div class="withdraw-section">
        <%-- dropUser ?⑥닔??member-signup.js???듯빀??--%>
        <button type="button" class="btn-link-withdraw" onclick="dropUser('${member.user_id}')">
            <spring:message code="member.btn.withdraw" text="?뚯썝 ?덊눜?섍린" />
        </button>
    </div>
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

<%-- [二쇱쓽] member.js??member-signup.js? 異⑸룎?섎?濡?濡쒕뱶?섏? ?딆쓬 --%>

<script type="text/javascript">
    [cite_start]<%-- ?꾩뿭 ?ㅼ젙 媛앹껜 [cite: 16] --%>
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>

<%-- 紐⑤뱺 寃利?諛??닿????덊눜 濡쒖쭅???ы븿?섎뒗 ?듯빀 ?ㅽ겕由쏀듃 --%>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
