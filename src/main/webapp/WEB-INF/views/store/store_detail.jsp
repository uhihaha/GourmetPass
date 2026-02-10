<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp"/>
<link rel="stylesheet" href="<c:url value='/resources/css/store_detail.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<script type="text/javascript">
    // ?쒕쾭?먯꽌 ?꾨떖??硫붿떆吏(?? 以묐났 ?덉빟 ?뚮┝) 泥섎━
    var msg = "${msg}";
    if (msg && msg !== "null" && msg !== "") {
        alert(msg);
    }

    // 寃곗젣 紐⑤뱢(Iamport) ?곕룞???꾩슂???ъ슜???뺣낫 諛붿씤??
    window.loginUserInfo = {
        loginUserId: "${loginUser.user_id}",
        email: "${loginUser.user_email}",
        name: "${loginUser.user_nm}",
        tel: "${loginUser.user_tel}",
        addr: "${loginUser.user_addr1} ${loginUser.user_addr2}",
        post: "${loginUser.user_zip}",
        portOneStoreId: "${portOneStoreId}",
        portOneChannelKey: "${portOneChannelKey}",
        isOwner: false
    };
</script>
<sec:authorize access="hasRole('ROLE_OWNER')">
    <script type="text/javascript">
        if (window.loginUserInfo) {
            window.loginUserInfo.isOwner = true;
        }
    </script>
</sec:authorize>

<div class="detail-wrapper" id="storeDetailApp"
     data-store-id="${store.store_id}" data-lat="${store.store_lat}"
     data-owner-id="${store.user_id}"
     data-lng="${store.store_lon}" data-name="${store.store_name}"
     data-open-time="${store.open_time}"
     data-close-time="${store.close_time}" data-res-unit="${store.res_unit}"
     data-context="${pageContext.request.contextPath}">

    <%-- 1. ?곷떒 ??댄? ?뱀뀡 --%>
    <div class="detail-header">
        <h1 class="store-main-title">?룧 ${store.store_name}</h1>
        <div class="store-meta-info">
            <span class="badge-cat">
                <c:choose>
                    <c:when test="${store.store_category eq '?쒖떇'}"><c:set var="catKey" value="category.Korean" /></c:when>
                    <c:when test="${store.store_category eq '?쇱떇'}"><c:set var="catKey" value="category.Japanese" /></c:when>
                    <c:when test="${store.store_category eq '以묒떇'}"><c:set var="catKey" value="category.Chinese" /></c:when>
                    <c:when test="${store.store_category eq '?묒떇'}"><c:set var="catKey" value="category.Western" /></c:when>
                    <c:when test="${store.store_category eq '移댄럹'}"><c:set var="catKey" value="category.Cafe" /></c:when>
                    <c:otherwise><c:set var="catKey" value="category.Etc" /></c:otherwise>
                </c:choose>
                <spring:message code="${catKey}" text="${store.store_category}" />
            </span>
            <span class="rating-box">
                <spring:message code="store.detail.rating.info" arguments="${store.avg_rating},${store.review_cnt}" text="狩?${store.avg_rating} (${store.review_cnt}媛쒖쓽 由щ럭)" />
            </span>
            <span class="favorite-count" id="favoriteCount"
                  data-count-prefix="<spring:message code='store.detail.favorite.count_prefix' text='?ㅿ툘' />">
                <spring:message code="store.detail.favorite.count_prefix" text="?ㅿ툘" /> 0
            </span>
            <span class="viewer-count" id="viewerCount"
                  data-viewer-prefix="<spring:message code='store.detail.viewer.prefix' text='?뫁' />"
                  data-viewer-suffix="<spring:message code='store.detail.viewer.suffix' text='紐? />">
                <spring:message code="store.detail.viewer.prefix" text="?뫁" /> 0<spring:message code="store.detail.viewer.suffix" text="紐? />
            </span>
            <button type="button" class="favorite-inline" id="favoriteBtn"
                    data-favorite-on="<spring:message code='store.detail.favorite.on' text='利먭꺼李얘린 ?댁젣' />"
                    data-favorite-off="<spring:message code='store.detail.favorite.off' text='利먭꺼李얘린' />">
                <spring:message code="store.detail.btn.favorite" text="?쨳 利먭꺼李얘린" />
            </button>
            <button type="button" class="share-inline" id="copyLinkBtn">
                <spring:message code="store.detail.btn.share" text="?뵕 留곹겕 蹂듭궗" />
            </button>
        </div>
    </div>

    <%-- 2. 硫붿씤 ?뺣낫 移대뱶 --%>
    <div class="info-main-card">
        <div class="store-img-section">
            <c:choose>
                <c:when test="${not empty photoList}">
                    <div class="photo-slider" id="photoSlider">
                        <c:forEach var="photo" items="${photoList}" varStatus="status">
                            <img src="<c:url value='/upload/${photo.file_path}'/>"
                                 class="photo-slide ${status.first ? 'active' : ''}"
                                 alt="${photo.original_name}">
                        </c:forEach>
                        <div class="photo-dots" id="photoDots"></div>
                    </div>
                </c:when>
                <c:when test="${not empty store.store_img}">
                    <img src="<c:url value='/upload/${store.store_img}'/>" class="main-thumb">
                </c:when>
                <c:otherwise>
                    <div class="no-img-box"><spring:message code="common.msg.no_image" text="NO IMAGE" /></div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="store-text-section">
            <p><b><spring:message code="store.detail.label.addr" text="?뱧 二쇱냼" /></b>
                <span class="badge-cat">
                    <c:choose>
                        <c:when test="${store.store_category eq '?쒖떇'}"><c:set var="catKey" value="category.Korean" /></c:when>
                        <c:when test="${store.store_category eq '?쇱떇'}"><c:set var="catKey" value="category.Japanese" /></c:when>
                        <c:when test="${store.store_category eq '以묒떇'}"><c:set var="catKey" value="category.Chinese" /></c:when>
                        <c:when test="${store.store_category eq '?묒떇'}"><c:set var="catKey" value="category.Western" /></c:when>
                        <c:when test="${store.store_category eq '移댄럹'}"><c:set var="catKey" value="category.Cafe" /></c:when>
                        <c:otherwise><c:set var="catKey" value="category.Etc" /></c:otherwise>
                    </c:choose>
                    <spring:message code="${catKey}" text="${store.store_category}" />
                </span>
                ${store.store_addr1} ${store.store_addr2}
            </p>
            <p><b><spring:message code="store.detail.label.tel" text="?뱸 ?꾪솕" /></b> ${store.store_tel}</p>
            <p><b><spring:message code="store.detail.label.hours" text="???곸뾽" /></b> ${store.open_time} ~ ${store.close_time}</p>
            <p><b><spring:message code="store.detail.label.wait" text="?슯 ?湲? /></b> <span class="wait-count-text"><spring:message code="store.detail.wait.status" arguments="${currentWaitCount}" text="?꾩옱 ${currentWaitCount}? ?湲?以? /></span></p>
            <p><b><spring:message code="store.detail.label.intro" text="?뱷 ?뚭컻" /></b> ${store.store_desc}</p>
        </div>
    </div>

    <%-- 2-1. 硫붾돱 由ъ뒪???뱀뀡 --%>
    <div class="menu-section">
        <div class="card-header">
            <h3 class="card-title"><spring:message code="store.menu.title" text="?띂截?硫붾돱" /></h3>
        </div>
        <div class="menu-grid">
            <c:choose>
                <c:when test="${not empty menuList}">
                    <c:forEach var="menu" items="${menuList}">
                        <div class="menu-card">
                            <c:choose>
                                <c:when test="${not empty menu.menu_img}">
                                    <img src="<c:url value='/upload/${menu.menu_img}'/>" class="menu-thumb" alt="${menu.menu_name}">
                                </c:when>
                                <c:otherwise>
                                    <div class="menu-thumb placeholder"><spring:message code="common.msg.no_image" text="NO IMAGE" /></div>
                                </c:otherwise>
                            </c:choose>
                            <div class="menu-info">
                                <span class="menu-name">
                                    <c:if test="${menu.menu_sign == 'Y'}">
                                        <span class="badge-best" style="background:#ff3d00; color:#fff; padding:2px 5px; border-radius:4px; font-size:11px; margin-right:6px;">
                                            <spring:message code="menu.label.best" text="??? />
                                        </span>
                                    </c:if>
                                    ${menu.menu_name}
                                </span>
                                <span class="menu-price"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/><spring:message code="common.unit.won" text="?? /></span>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-status-box"><spring:message code="store.menu.empty" text="?깅줉??硫붾돱媛 ?놁뒿?덈떎." /></div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- 3. ?명꽣?숈뀡 踰꾪듉 洹몃９ --%>
    <div class="detail-action-group">
        <button type="button" class="btn-main-wire btn-booking"
                onclick="showInteraction('booking')"><spring:message code="store.detail.btn.book" text="?뱟 ?덉빟?섍린" />
        </button>
        <button type="button" class="btn-main-wire btn-waiting"
                onclick="showInteraction('waiting')"><spring:message code="store.detail.btn.wait" text="?슯 ?⑥씠?낇븯湲? />
        </button>
    </div>

    <%-- 4. ?덉빟 ?좎껌 ?곸뿭 --%>
    <div id="booking-area" class="interaction-card">
        <h3 class="section-title"><spring:message code="store.form.book.title" text="?뱟 ?뱀씪 ?덉빟 ?좎껌" /></h3>
        <sec:authorize access="hasRole('ROLE_OWNER')">
            <div class="auth-guide-box">
                <spring:message code="store.form.owner.block.book" text="?먯＜ 怨꾩젙? ?덉빟???????놁뒿?덈떎." />
            </div>
        </sec:authorize>
        <sec:authorize access="hasRole('ROLE_USER')">
            <form id="bookForm" action="<c:url value='/book/register'/>" method="post">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <input type="hidden" id="payIdField" name="pay_id" value="">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <table class="edit-table">
                    <tr>
                        <th><spring:message code="store.form.label.people" text="?덉빟 ?몄썝" /></th>
                        <td>
                            <select name="people_cnt" class="login-input">
                                <c:forEach var="i" begin="1" end="${store.max_capacity}">
                                    <option value="${i}"><spring:message code="store.form.unit.person" arguments="${i}" text="${i}紐? /></option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="store.form.label.date" text="?덉빟 ?좎쭨" /></th>
                        <td>
                            <input type="date" name="book_date" id="bookDate"
                                   class="login-input" onchange="loadAvailableSlots()"
                                   min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
                            <p class="info-text"><spring:message code="store.form.info.date" text="* ?뱀씪 諛??댄썑 ?좎쭨留??좏깮 媛?ν빀?덈떎." /></p>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="store.form.label.time" text="?덉빟 ?쒓컙" /></th>
                        <td>
                            <div id="timeSlotContainer" class="time-grid">
                                    <%-- JS???섑빐 ???踰꾪듉???숈쟻?쇰줈 ?앹꽦??--%>
                            </div>
                            <input type="hidden" name="book_time" id="selectedTime" required>
                        </td>
                    </tr>
                </table>
                <button type="submit" class="btn-submit-wire"><spring:message code="store.form.btn.book" text="?? ?덉빟 ?뺤젙?섍린" /></button>
            </form>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
            <div class="auth-guide-box">
                <spring:message code="store.form.auth.prefix.book" text="?덉빟?" />
                <a href="<c:url value='/member/login'/>"><spring:message code="store.form.auth.login" text="濡쒓렇?? /></a>
                <spring:message code="store.form.auth.suffix" text="???댁슜 媛?ν빀?덈떎." />
            </div>
        </sec:authorize>
    </div>

    <%-- 5. ?⑥씠???좎껌 ?곸뿭 --%>
    <div id="waiting-area" class="interaction-card">
        <h3 class="section-title"><spring:message code="store.form.wait.title" text="?슯 ?ㅼ떆媛??⑥씠???좎껌" /></h3>
        <sec:authorize access="hasRole('ROLE_OWNER')">
            <div class="auth-guide-box">
                <spring:message code="store.form.owner.block.wait" text="?먯＜ 怨꾩젙? ?⑥씠?낆쓣 ?????놁뒿?덈떎." />
            </div>
        </sec:authorize>
        <sec:authorize access="hasRole('ROLE_USER')">
            <form id="waitForm" action="<c:url value='/wait/register'/>" method="post">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <table class="edit-table">
                    <tr>
                        <th><spring:message code="store.form.label.people" text="諛⑸Ц ?몄썝" /></th>
                        <td>
                            <select name="people_cnt" class="login-input">
                                <c:forEach var="i" begin="1" end="${store.max_capacity}">
                                    <option value="${i}"><spring:message code="store.form.unit.person" arguments="${i}" text="${i}紐? /></option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </table>
                <button type="submit" class="btn-submit-wire dark-btn"><spring:message code="store.form.btn.wait" text="以꾩꽌湲??좎껌?섍린" /></button>
            </form>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
            <div class="auth-guide-box">
                <spring:message code="store.form.auth.prefix.wait" text="?⑥씠?낆?" />
                <a href="<c:url value='/member/login'/>"><spring:message code="store.form.auth.login" text="濡쒓렇?? /></a>
                <spring:message code="store.form.auth.suffix" text="???댁슜 媛?ν빀?덈떎." />
            </div>
        </sec:authorize>
    </div>

    <%-- 6. 吏??諛?由щ럭 ?뱀뀡 --%>
    <div id="map"></div>

    <div class="review-summary-section">
        <div class="card-header">
            <h3 class="card-title"><spring:message code="store.review.recent" text="?뮠 理쒓렐 由щ럭" /></h3>
            <%-- [?섏젙] 由щ럭 ?꾨찓??遺꾨━???곕Ⅸ 寃쎈줈 理쒖떊??(/store/reviews -> /review/list) --%>
            <a href="<c:url value='/review/list?store_id=${store.store_id}'/>"
               class="btn-wire-small"><spring:message code="store.review.viewall" text="?꾩껜蹂닿린" /> ??/a>
        </div>
        <div class="review-grid">
            <c:choose>
                <c:when test="${not empty reviewList}">
                    <c:forEach var="rev" items="${reviewList}">
                        <div class="item-card">
                            <div class="review-item-header">
                                <span class="user-nm-text">${rev.user_nm}</span>
                                <span class="stars-text">
									<c:forEach begin="1" end="${rev.rating}">狩?/c:forEach>
								</span>
                            </div>
                            <p class="review-content-text">${rev.content}</p>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-status-box"><spring:message code="store.review.empty" text="?묒꽦??由щ럭媛 ?놁뒿?덈떎." /></div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%-- ?꾩닔 ?쇱씠釉뚮윭由?諛??ㅽ겕由쏀듃 ?곕룞 --%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script>
    window.I18N = window.I18N || {};
    window.I18N.storeDetail = {
        loading: "<spring:message code='store.detail.loading' text='Loading...' javaScriptEscape='true' />",
        reasonClosed: "<spring:message code='store.detail.reason.closed' text='Closed' javaScriptEscape='true' />",
        reasonBooked: "<spring:message code='store.detail.reason.booked' text='Booked' javaScriptEscape='true' />",
        noHours: "<spring:message code='store.detail.no_hours' text='No business hours set.' javaScriptEscape='true' />",
        loadFail: "<spring:message code='store.detail.load_fail' text='Failed to load.' javaScriptEscape='true' />",
        ownerBlock: "<spring:message code='store.detail.owner.block' text='Owners cannot book or wait.' javaScriptEscape='true' />",
        selfBlock: "<spring:message code='store.detail.self.block' text='Cannot book or wait at your own store.' javaScriptEscape='true' />",
        favoriteOn: "<spring:message code='store.detail.favorite.on' text='Remove favorite' javaScriptEscape='true' />",
        favoriteOff: "<spring:message code='store.detail.favorite.off' text='Add favorite' javaScriptEscape='true' />",
        favoriteCountPrefix: "<spring:message code='store.detail.favorite.count_prefix' text='Total' javaScriptEscape='true' />",
        paySuccessBooking: "<spring:message code='store.detail.pay.success_booking' text='Payment complete. Booking proceeds.' javaScriptEscape='true' />",
        payFail: "<spring:message code='store.detail.pay.fail' text='Payment failed.' javaScriptEscape='true' />",
        selectVisitTime: "<spring:message code='store.detail.visit_time.select' text='Select a visit time.' javaScriptEscape='true' />",
        confirmPaymentSuffix: "<spring:message code='store.detail.confirm_payment_suffix' text='Proceed to payment for booking?' javaScriptEscape='true' />",
        orderName: "<spring:message code='store.detail.order_name' text='Reservation deposit' javaScriptEscape='true' />",
        paySuccess: "<spring:message code='store.detail.pay.success' text='Payment completed.' javaScriptEscape='true' />",
        payVerifyFail: "<spring:message code='store.detail.pay.verify_fail' text='Payment verification failed.' javaScriptEscape='true' />",
        payCancelledPrefix: "<spring:message code='store.detail.pay.cancelled_prefix' text='Payment cancelled.' javaScriptEscape='true' />",
        payPopupError: "<spring:message code='store.detail.pay.popup_error' text='Payment popup error.' javaScriptEscape='true' />",
        bookUnavailablePrefix: "<spring:message code='store.detail.book.unavailable_prefix' text='Booking unavailable. (Reason:' javaScriptEscape='true' />",
        bookUnavailableSuffix: "<spring:message code='store.detail.book.unavailable_suffix' text=')' javaScriptEscape='true' />",
        viewerPrefix: "<spring:message code='store.detail.viewer.prefix' text='Now' javaScriptEscape='true' />",
        viewerSuffix: "<spring:message code='store.detail.viewer.suffix' text='people' javaScriptEscape='true' />"
    };
</script>
<script src="<c:url value='/resources/js/store_detail.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>
