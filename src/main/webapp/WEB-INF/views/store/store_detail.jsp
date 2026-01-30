<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%-- [필수] 다국어 처리를 위한 Spring 태그 라이브러리 --%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/store_detail.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<script type="text/javascript">
    var msg = "${msg}";
    if (msg && msg !== "null" && msg !== "") {
        alert(msg);
    }
    
    window.loginUserInfo = {
        email: "${loginUser.user_email}",
        name:  "${loginUser.user_nm}",
        tel:   "${loginUser.user_tel}",
        addr:  "${loginUser.user_addr1} ${loginUser.user_addr2}",
        post:  "${loginUser.user_zip}",
        impInit: "${impInit}",      
        pg: "${pg}"
    };
</script>

<div class="detail-wrapper" id="storeDetailApp"
    data-store-id="${store.store_id}" data-lat="${store.store_lat}"
    data-lng="${store.store_lon}" data-name="${store.store_name}"
    data-open-time="${store.open_time}"
    data-close-time="${store.close_time}" data-res-unit="${store.res_unit}"
    data-context="${pageContext.request.contextPath}">

    <%-- 1. 상단 타이틀 섹션 --%>
    <div class="detail-header">
        <h1 class="store-main-title">🏠 ${store.store_name}</h1>
        <div class="store-meta-info">
            <span class="badge-cat">
                <spring:message code="category.${store.store_category}" text="${store.store_category}"/>
            </span> 
            <span class="rating-box">
                <spring:message code="store.detail.rating.info" arguments="${store.avg_rating}, ${store.review_cnt}" />
            </span>
        </div>
    </div>

    <%-- 2. 메인 정보 카드 --%>
    <div class="info-main-card">
        <div class="store-img-section">
            <c:choose>
                <c:when test="${not empty store.store_img}">
                    <img src="<c:url value='/upload/${store.store_img}'/>" class="main-thumb">
                </c:when>
                <c:otherwise>
                    <div class="no-img-box">NO IMAGE</div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="store-text-section">
            <p><b><spring:message code="store.detail.label.addr" /></b> ${store.store_addr1} ${store.store_addr2}</p>
            <p><b><spring:message code="store.detail.label.tel" /></b> ${store.store_tel}</p>
            <p><b><spring:message code="store.detail.label.hours" /></b> ${store.open_time} ~ ${store.close_time}</p>
            <p><b><spring:message code="store.detail.label.wait" /></b> 
                <span class="wait-count-text">
                    <spring:message code="store.detail.wait.status" arguments="${currentWaitCount}" />
                </span>
            </p>
            <p><b><spring:message code="store.detail.label.intro" /></b> ${store.store_desc}</p>
        </div>
    </div>

    <%-- 3. 인터랙션 버튼 그룹 --%>
    <div class="detail-action-group">
        <button type="button" class="btn-main-wire btn-booking" onclick="showInteraction('booking')">
            <spring:message code="store.detail.btn.book" />
        </button>
        <button type="button" class="btn-main-wire btn-waiting" onclick="showInteraction('waiting')">
            <spring:message code="store.detail.btn.wait" />
        </button>
    </div>

    <%-- 4. 예약 신청 영역 --%>
    <div id="booking-area" class="interaction-card">
        <h3 class="section-title"><spring:message code="store.form.book.title" /></h3>
        <sec:authorize access="isAuthenticated()">
            <form id="bookForm" action="<c:url value='/book/register'/>" method="post">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <input type="hidden" id="payIdField" name="pay_id" value="">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <table class="edit-table">
                    <tr>
                        <th><spring:message code="store.form.label.people" /></th>
                        <td>
                            <select name="people_cnt" class="login-input">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}"><spring:message code="store.form.unit.person" arguments="${i}" /></option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="store.form.label.date" /></th>
                        <td>
                            <input type="date" name="book_date" id="bookDate"
                            class="login-input" onchange="loadAvailableSlots()"
                            min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
                            <p class="info-text"><spring:message code="store.form.info.date" /></p>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="store.form.label.time" /></th>
                        <td>
                            <div id="timeSlotContainer" class="time-grid"></div> 
                            <input type="hidden" name="book_time" id="selectedTime" required>
                        </td>
                    </tr>
                </table>
                <button type="submit" class="btn-submit-wire"><spring:message code="store.form.btn.book" /></button>
            </form>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
            <div class="auth-guide-box">
                <spring:url value="/member/login" var="loginUrl"/>
                <%-- [오류 수정 핵심] EL 함수 대신 var 속성을 사용해 메시지 변수 추출 --%>
                <spring:message code="store.detail.btn.book" var="serviceBookLabel" />
                <spring:message code="store.form.auth.login" var="authLoginLabel" />
                <spring:message code="store.form.auth.guide" 
                    arguments="${serviceBookLabel}, <a href='${loginUrl}'>${authLoginLabel}</a>" />
            </div>
        </sec:authorize>
    </div>

    <%-- 5. 웨이팅 신청 영역 --%>
    <div id="waiting-area" class="interaction-card">
        <h3 class="section-title"><spring:message code="store.form.wait.title" /></h3>
        <sec:authorize access="isAuthenticated()">
            <form action="<c:url value='/wait/register'/>" method="post">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <table class="edit-table">
                    <tr>
                        <th><spring:message code="store.form.label.people" /></th>
                        <td>
                            <select name="people_cnt" class="login-input">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}"><spring:message code="store.form.unit.person" arguments="${i}" /></option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </table>
                <button type="submit" class="btn-submit-wire dark-btn"><spring:message code="store.form.btn.wait" /></button>
            </form>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
            <div class="auth-guide-box">
                <spring:url value="/member/login" var="loginUrl"/>
                <%-- [오류 수정 핵심] EL 함수 대신 var 속성을 사용해 메시지 변수 추출 --%>
                <spring:message code="store.detail.btn.wait" var="serviceWaitLabel" />
                <spring:message code="store.form.auth.login" var="authLoginLabel" />
                <spring:message code="store.form.auth.guide" 
                    arguments="${serviceWaitLabel}, <a href='${loginUrl}'>${authLoginLabel}</a>" />
            </div>
        </sec:authorize>
    </div>

    <%-- 6. 지도 및 리뷰 섹션 --%>
    <div id="map"></div>

    <div class="review-summary-section">
        <div class="card-header">
            <h3 class="card-title"><spring:message code="store.review.recent" /></h3>
            <a href="<c:url value='/store/reviews?store_id=${store.store_id}'/>" class="btn-wire-small">
                <spring:message code="store.review.viewall" />
            </a>
        </div>
        <div class="review-grid">
            <c:choose>
                <c:when test="${not empty reviewList}">
                    <c:forEach var="rev" items="${reviewList}">
                        <div class="item-card">
                            <div class="review-item-header">
                                <span class="user-nm-text">${rev.user_nm}</span> 
                                <span class="stars-text"> 
                                    <c:forEach begin="1" end="${rev.rating}">⭐</c:forEach>
                                </span>
                            </div>
                            <p class="review-content-text">${rev.content}</p>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-status-box"><spring:message code="store.review.empty" /></div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="<c:url value='/resources/js/store_detail.js'/>"></script>

<jsp:include page="../common/footer.jsp" />