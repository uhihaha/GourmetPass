<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<jsp:include page="../common/header.jsp"/>
<link rel="stylesheet" href="<c:url value='/resources/css/store_detail.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<script type="text/javascript">
    // 서버에서 전달된 메시지(예: 중복 예약 알림) 처리
    var msg = "${msg}";
    if (msg && msg !== "null" && msg !== "") {
        alert(msg);
    }

    // 결제 모듈(Iamport) 연동에 필요한 사용자 정보 바인딩
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

    <%-- 1. 상단 타이틀 섹션 --%>
    <div class="detail-header">
        <h1 class="store-main-title">🏠 ${store.store_name}</h1>
        <div class="store-meta-info">
            <span class="badge-cat">${store.store_category}</span>
            <span class="rating-box">⭐ <b>${store.avg_rating}</b> (${store.review_cnt}개의 리뷰)</span>
            <span class="favorite-count" id="favoriteCount">❤️ 0</span>
            <span class="viewer-count" id="viewerCount">👥 0명</span>
            <button type="button" class="favorite-inline" id="favoriteBtn">🤍 즐겨찾기</button>
            <button type="button" class="share-inline" id="copyLinkBtn">🔗 링크 복사</button>
        </div>
    </div>

    <%-- 2. 메인 정보 카드 --%>
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
                    <div class="no-img-box">NO IMAGE</div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="store-text-section">
            <p><b>📍 주소</b> <span class="badge-cat">${store.store_category}</span> ${store.store_addr1} ${store.store_addr2}</p>
            <p><b>📞 전화</b> ${store.store_tel}</p>
            <p><b>⏰ 영업</b> ${store.open_time} ~ ${store.close_time}</p>
            <p><b>🚶 대기</b> <span class="wait-count-text">현재 ${currentWaitCount}팀 대기 중</span></p>
            <p><b>📝 소개</b> ${store.store_desc}</p>
        </div>
    </div>

    <%-- 2-1. 메뉴 리스트 섹션 --%>
    <div class="menu-section">
        <div class="card-header">
            <h3 class="card-title">🍽️ 메뉴</h3>
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
                                    <div class="menu-thumb placeholder">NO IMAGE</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="menu-info">
                                <span class="menu-name">
                                    <c:if test="${menu.menu_sign == 'Y'}">
                                        <span class="badge-best" style="background:#ff3d00; color:#fff; padding:2px 5px; border-radius:4px; font-size:11px; margin-right:6px;">대표</span>
                                    </c:if>
                                    ${menu.menu_name}
                                </span>
                                <span class="menu-price"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/>원</span>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-status-box">등록된 메뉴가 없습니다.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- 3. 인터랙션 버튼 그룹 --%>
    <div class="detail-action-group">
        <button type="button" class="btn-main-wire btn-booking"
                onclick="showInteraction('booking')">📅 예약하기
        </button>
        <button type="button" class="btn-main-wire btn-waiting"
                onclick="showInteraction('waiting')">🚶 웨이팅하기
        </button>
    </div>

    <%-- 4. 예약 신청 영역 --%>
    <div id="booking-area" class="interaction-card">
        <h3 class="section-title">📅 당일 예약 신청</h3>
        <sec:authorize access="isAuthenticated()">
            <form id="bookForm" action="<c:url value='/book/register'/>" method="post">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <input type="hidden" id="payIdField" name="pay_id" value="">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <table class="edit-table">
                    <tr>
                        <th>예약 인원</th>
                        <td>
                            <select name="people_cnt" class="login-input">
                                <c:forEach var="i" begin="1" end="${store.max_capacity}">
                                    <option value="${i}">${i}명</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>예약 날짜</th>
                        <td>
                            <input type="date" name="book_date" id="bookDate"
                                   class="login-input" onchange="loadAvailableSlots()"
                                   min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
                            <p class="info-text">* 당일 및 이후 날짜만 선택 가능합니다.</p>
                        </td>
                    </tr>
                    <tr>
                        <th>예약 시간</th>
                        <td>
                            <div id="timeSlotContainer" class="time-grid">
                                    <%-- JS에 의해 타임 버튼이 동적으로 생성됨 --%>
                            </div>
                            <input type="hidden" name="book_time" id="selectedTime" required>
                        </td>
                    </tr>
                </table>
                <button type="submit" class="btn-submit-wire">🚀 예약 확정하기</button>
            </form>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
            <div class="auth-guide-box">
                예약은 <a href="<c:url value='/member/login'/>">로그인</a> 후 이용 가능합니다.
            </div>
        </sec:authorize>
    </div>

    <%-- 5. 웨이팅 신청 영역 --%>
    <div id="waiting-area" class="interaction-card">
        <h3 class="section-title">🚶 실시간 웨이팅 신청</h3>
        <sec:authorize access="isAuthenticated()">
            <form id="waitForm" action="<c:url value='/wait/register'/>" method="post">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <table class="edit-table">
                    <tr>
                        <th>방문 인원</th>
                        <td>
                            <select name="people_cnt" class="login-input">
                                <c:forEach var="i" begin="1" end="${store.max_capacity}">
                                    <option value="${i}">${i}명</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </table>
                <button type="submit" class="btn-submit-wire dark-btn">줄서기 신청하기</button>
            </form>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
            <div class="auth-guide-box">
                웨이팅은 <a href="<c:url value='/member/login'/>">로그인</a> 후 이용 가능합니다.
            </div>
        </sec:authorize>
    </div>

    <%-- 6. 지도 및 리뷰 섹션 --%>
    <div id="map"></div>

    <div class="review-summary-section">
        <div class="card-header">
            <h3 class="card-title">💬 최근 리뷰</h3>
            <%-- [수정] 리뷰 도메인 분리에 따른 경로 최신화 (/store/reviews -> /review/list) --%>
            <a href="<c:url value='/review/list?store_id=${store.store_id}'/>"
               class="btn-wire-small">전체보기 ❯</a>
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
                    <div class="empty-status-box">작성된 리뷰가 없습니다.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%-- 필수 라이브러리 및 스크립트 연동 --%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="<c:url value='/resources/js/store_detail.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>
