<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="../common/header.jsp" />

<%-- 점주 전용 스타일 및 마이페이지 공통 스타일 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/mypage_owner.css'/>">

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div class="mypage-wrapper">
    
    <div class="profile-card">
        <div class="profile-info">
            <span class="profile-label">Owner Profile</span>
            <h2 class="user-name">${member.user_nm} <small>점주님</small></h2>
            <p class="user-meta">${member.user_id} | ${member.user_tel}</p>
        </div>
        <div class="profile-icon">👨‍🍳</div>
    </div>

    <div class="menu-container">
        <div class="button-row">
            <a href="<c:url value='/member/edit'/>" class="btn-wire">🛠️ 정보 수정</a>
            <form action="<c:url value='/logout'/>" method="post" class="logout-form">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button type="submit" class="btn-wire btn-logout">🚪 로그아웃</button>
            </form>
        </div>

        <c:if test="${not empty store}">
            <a href="<c:url value='/book/manage?store_id=${store.store_id}'/>" class="btn-wire btn-full">
                ⚙️ 실시간 예약 / 웨이팅 관리
            </a>
        </c:if>
    </div>

    <hr class="section-divider">

    <c:choose>
        <c:when test="${not empty store}">
            <div class="owner-main-grid">
                <div class="owner-side-card">
                    <div class="card-header">
                        <h3 class="card-title">🏨 가게 정보</h3>
                        <button class="btn-edit-small" onclick="location.href='<c:url value='/store/update?store_id=${store.store_id}'/>'">수정</button>
                    </div>
                    
                    <div class="store-summary">
                        <div class="store-img-box">
                            <c:choose>
                                <c:when test="${not empty store.store_img}">
                                    <img src="<c:url value='/upload/${store.store_img}'/>" class="img-fit">
                                </c:when>
                                <c:otherwise><div class="no-img-box">이미지 없음</div></c:otherwise>
                            </c:choose>
                        </div>
                        <h4 class="store-title-name">${store.store_name}</h4>
                        <span class="badge-wire">${store.store_category}</span>
                    </div>

                    <ul class="store-detail-list">
                        <li><span>영업</span> <b>${store.open_time} ~ ${store.close_time}</b></li>
                        <li><span>단위</span> <b>${store.res_unit}분</b></li>
                        <li><span>번호</span> <b>${store.store_tel}</b></li>
                    </ul>
                </div>

                <div class="owner-content-card">
                    <div class="card-header">
                        <h3 class="card-title">📋 메뉴 관리 (${menuList.size()})</h3>
                        <button class="btn-add-menu" onclick="location.href='<c:url value='/store/menu/register?store_id=${store.store_id}'/>'">+ 추가</button>
                    </div>

                    <table class="owner-menu-table">
                        <thead>
                            <tr><th>이미지</th><th>메뉴명</th><th>가격</th><th>관리</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="menu" items="${menuList}">
                                <tr>
                                    <td align="center">
                                        <c:if test="${not empty menu.menu_img}">
                                            <img src="<c:url value='/upload/${menu.menu_img}'/>" class="img-small">
                                        </c:if>
                                    </td>
                                    <td align="left">
                                        <b>${menu.menu_name}</b>
                                        <c:if test="${menu.menu_sign == 'Y'}"><span class="badge-best">대표</span></c:if>
                                    </td>
                                    <td align="right" class="price-text"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###" />원</td>
                                    <td align="center">
                                        <button class="btn-tool" onclick="location.href='<c:url value='/store/menu/update?menu_id=${menu.menu_id}'/>'">수정</button>
                                        <button class="btn-tool btn-del" onclick="deleteMenu(${menu.menu_id})">삭제</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="review-section-box">
                <h3 class="review-title">💬 우리 가게 리뷰 (${store_review_list.size()})</h3>
                <div class="owner-review-list">
                    <c:forEach var="review" items="${store_review_list}">
                        <div class="owner-review-item">
                            <div class="review-top">
                                <strong>${review.user_nm} 고객님</strong>
                                <span class="review-stars">
                                    <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                </span>
                                <span class="review-date-text"><fmt:formatDate value="${review.review_date}" pattern="yyyy.MM.dd" /></span>
                            </div>
                            <div class="review-body">
                                <c:if test="${not empty review.img_url}">
                                    <img src="<c:url value='/upload/${review.img_url}'/>" class="review-img-thumb">
                                </c:if>
                                <p class="review-text-content">${review.content}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div class="empty-store-card">
                <h3>연결된 매장 정보가 없습니다.</h3>
                <p>가게 정보를 등록하여 Gourmet Pass 서비스를 시작하세요.</p>
                <button class="btn-wire btn-full" style="max-width: 300px; margin: 20px auto;" 
                        onclick="location.href='<c:url value='/member/signup/owner2'/>'">가게 등록하기</button>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp" />