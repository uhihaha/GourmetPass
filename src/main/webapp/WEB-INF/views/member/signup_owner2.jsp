<%-- WEB-INF/views/member/signup_owner2.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp"/>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title"><spring:message code="member.signup.owner.step2.title" text="?뜳 ?먯＜ 媛??- 2?④퀎 (媛寃??뺣낫)" /></div>
    <p class="text-center mb-20"><spring:message code="member.signup.owner.step2.sub" text="?댁쁺?섏떎 留ㅼ옣???뺣낫瑜??곸꽭???낅젰?댁＜?몄슂." /></p>

    <form action="${pageContext.request.contextPath}/member/signup/ownerFinal" method="post" id="ownerStep2Form">
        <spring:message code="common.unit.person" var="unitPerson" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <%-- 醫뚰몴 ?뺣낫 ??μ슜 ?④? ?꾨뱶: DB ?ㅽ궎留?NUMBER(10, 7) ???[cite: 2] --%>
        <input type="hidden" name="store_lat" id="store_lat" value="0.0">
        <input type="hidden" name="store_lon" id="store_lon" value="0.0">

        <table class="edit-table">
            <tr>
                <th><spring:message code="store.label.name" text="媛寃??대쫫" /></th>
                <td><input type="text" name="store_name" id="store_name" placeholder="<spring:message code='store.placeholder.name' text='?? 援щⅤ硫??앸떦' />" required></td>
            </tr>
            <tr>
                <th><spring:message code="store.label.category" text="移댄뀒怨좊━" /></th>
                <td>
                    <select name="store_category" required>
                        <option value=""><spring:message code="store.category.select" text="移댄뀒怨좊━ ?좏깮" /></option>
                        <option value="?쒖떇"><spring:message code="category.Korean" text="?쒖떇" /></option>
                        <option value="?쇱떇"><spring:message code="category.Japanese" text="?쇱떇" /></option>
                        <option value="以묒떇"><spring:message code="category.Chinese" text="以묒떇" /></option>
                        <option value="?묒떇"><spring:message code="category.Western" text="?묒떇" /></option>
                        <option value="移댄럹"><spring:message code="category.Cafe" text="移댄럹/?붿??? /></option>
                        <option value="湲고?"><spring:message code="category.Etc" text="湲고?" /></option>
                    </select>
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.tel" text="媛寃?踰덊샇" /></th>
                <td><input type="text" name="store_tel" required placeholder="<spring:message code='store.placeholder.tel' text='02-123-4567' />" oninput="autoHyphen(this)"
                           maxlength="13"></td>
            </tr>
            <tr>
                <th><spring:message code="store.label.addr" text="媛寃??꾩튂" /></th>
                <td>
                    <div class="input-row mb-10">
                        <input type="text" name="store_zip" id="store_zip" style="width:120px; flex:none;" readonly
                               placeholder="<spring:message code='member.zip_code' text='?고렪踰덊샇' />">
                        <button type="button" onclick="execDaumPostcode('store')" class="btn-wire"><spring:message code="member.btn.addr_search" text="二쇱냼寃?? /></button>
                    </div>
                    <input type="text" name="store_addr1" id="store_addr1" class="mb-10" readonly placeholder="<spring:message code='member.addr1' text='湲곕낯 二쇱냼' />">
                    <%-- [援먯젙] name ?띿꽦??user_addr2?먯꽌 store_addr2濡??섏젙?섏뿬 DB 而щ읆怨??쇱튂?쒗궡 [cite: 2] --%>
                    <input type="text" name="store_addr2" id="store_addr2" placeholder="<spring:message code='member.placeholder.addr2' text='?곸꽭 二쇱냼瑜??낅젰?섏꽭?? />">
                    <div id="coordStatus" class="msg-box msg-ok"><spring:message code="store.msg.coord_info" text="?뺥솗???꾩튂 ?뺣낫媛 ?꾩슂?⑸땲??" /></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.hours" text="?곸뾽 ?쒓컙" /></th>
                <td>
                    <div class="btn-group" style="margin-top:0; align-items:center; gap:8px;">
                        <select name="open_time" style="flex:1;">
                            <c:forEach var="i" begin="0" end="23">
                                <fmt:formatNumber var="hour" value="${i}" pattern="00"/>
                                <option value="${hour}:00" ${i==9 ? 'selected':''}>${hour}:00</option>
                                <option value="${hour}:30">${hour}:30</option>
                            </c:forEach>
                        </select>
                        <span style="font-weight:bold;">~</span>
                        <select name="close_time" style="flex:1;">
                            <c:forEach var="i" begin="0" end="23">
                                <fmt:formatNumber var="hour" value="${i}" pattern="00"/>
                                <option value="${hour}:00" ${i==22 ? 'selected':''}>${hour}:00</option>
                                <option value="${hour}:30">${hour}:30</option>
                            </c:forEach>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.res_unit" text="?덉빟 ?⑥쐞" /></th>
                <td>
                    <select name="res_unit">
                        <option value="30">30<spring:message code="store.unit.minute" text="遺??⑥쐞" /></option>
                        <option value="60">1<spring:message code="store.unit.hour" text="?쒓컙 ?⑥쐞" /></option>
                    </select>
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.capacity" text="理쒕? ?섏슜 ?몄썝" /></th>
                <td>
                    <input type="number" name="max_capacity" required placeholder="0 ${unitPerson}"
                           oninput="autoHyphen(this)" minlength="1">
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.desc" text="媛寃??뚭컻" /></th>
                <td><textarea name="store_desc" rows="5" style="resize:none;"
                              placeholder="<spring:message code='store.placeholder.desc' text='留ㅼ옣???뱀쭠??媛꾨떒???뚭컻??二쇱꽭??' />"></textarea></td>
            </tr>
        </table>

        <button type="submit" class="btn-submit" style="width:100%; margin-top:30px;"><spring:message code="store.btn.final_submit" text="媛???꾨즺 諛?媛寃??깅줉" /></button>
    </form>
</div>

<%-- ?몃? API 諛?怨듯넻 ?ㅽ겕由쏀듃 ?곕룞 --%>
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

<%-- [援먯젙] APP_CONFIG ?좎뼵 異붽? (AJAX 諛?寃쎈줈 李몄“?? [cite: 16, 33] --%>
<script type="text/javascript">
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>

<%-- [援먯젙] member.js瑜??쒓굅?섍퀬 ?듯빀??member-signup.js ?곌껐 --%>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>
