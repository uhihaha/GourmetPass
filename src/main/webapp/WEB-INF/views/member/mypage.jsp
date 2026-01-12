<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<%-- 마이페이지 전용 스타일 및 리뷰 스크립트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<script src="<c:url value='/resources/js/review.js'/>"></script>

<div class="mypage-wrapper">
    <div class="profile-card">
        <div class="profile-info">
            <span class="profile-label">Member Profile</span>
            <h2 class="user-name">${member.user_nm} <small>님</small></h2>
            <p class="user-meta">${member.user_id} | ${member.user_tel}</p>
        </div>
        <div class="profile-icon">👤</div>
    </div>

    <div class="menu-container">
        <div class="button-row">
            <a href="<c:url value='/member/edit'/>" class="btn-wire">🛠️ 정보 수정</a>
            <form action="<c:url value='/logout'/>" method="post" class="logout-form">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button type="submit" class="btn-wire btn-logout">🚪 로그아웃</button>
            </form>
        </div>
        <a href="<c:url value='/wait/myStatus'/>" class="btn-wire btn-full">📅 나 의 이 용 현 황</a>
    </div>

    <hr class="section-divider">

    <div class="review-section">
        <h3 class="review-title">💬 나의 리뷰 기록 (${my_review_list.size()})</h3>
        
        <c:choose>
            <c:when test="${not empty my_review_list}">
                <c:forEach var="review" items="${my_review_list}">
                    <div class="review-card">
                        <div class="review-header">
                            <div class="store-link-box">
                                <a href="<c:url value='/store/detail?storeId=${review.store_id}'/>" class="store-link">
                                   🏨 ${review.store_name} ❯
                                </a>
                                <div class="star-rating">
                                    <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                </div>
                            </div>
                            <button type="button" class="btn-delete-small" 
                                    onclick="confirmDeleteReview('${review.review_id}', '${review.store_id}')">삭제</button>
                        </div>
                        <p class="review-content">${review.content}</p>
                        <div class="review-date">
                            <fmt:formatDate value="${review.review_date}" pattern="yyyy.MM.dd" />
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-review">아직 작성된 리뷰가 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />