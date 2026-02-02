<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%-- [필수 추가] 다국어 처리를 위한 Spring 태그 라이브러리 --%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- [관심사 분리] 공용 마이페이지 스타일 및 통합 스크립트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<script src="<c:url value='/resources/js/mypage.js'/>"></script>

<div class="mypage-wrapper">
    <div class="profile-card">
        <div class="profile-info">
            <%-- MEMBER PROFILE 텍스트 다국어화 (키가 없으면 텍스트 출력) --%>
            <span class="profile-label">
                <spring:message code="mypage.user.profile.label" text="MEMBER PROFILE" />
            </span>
            <h2 class="user-name">
                ${member.user_nm}
                <%-- '님' 호칭 처리 (영어일 경우 빈값) --%>
                <small><spring:message code="common.user.suffix" text="" /></small>
            </h2>
            <p class="user-meta">
                <spring:message code="member.user_id" text="ID" />: ${member.user_id} | 
                <spring:message code="member.user_tel" text="TEL" />: ${member.user_tel}
            </p>
        </div>
        <div class="btn-group" style="margin: 0; width: auto;">
            <a href="<c:url value='/member/edit'/>" class="btn-wire" style="height: 45px; padding: 0 20px; font-size: 14px;">
                <spring:message code="member.edit.title" text="Edit Profile" />
            </a>
            <form action="<c:url value='/logout'/>" method="post" style="display: inline;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button type="submit" class="btn-wire btn-logout" style="height: 45px; padding: 0 20px; font-size: 14px; margin-left: 10px;">
                    <spring:message code="common.nav.logout" text="Logout" />
                </button>
            </form>
        </div>
    </div>

    <%-- mypage.jsp 내부 핵심 버튼 링크 수정 --%>
    <div class="menu-container">
        <a href="<c:url value='/member/wait_status'/>" class="status-btn-full">
            <spring:message code="wait.status.title" text="📅 My Real-time Status" />
        </a>
    </div>
    <hr class="section-divider">

    <div class="dashboard-card">
        <div class="card-header">
            <h3 class="card-title">
                💬 <spring:message code="review.title" text="My Reviews" /> (${my_review_list.size()})
            </h3>
        </div>

        <div class="review-list">
            <c:choose>
                <c:when test="${not empty my_review_list}">
                    <c:forEach var="review" items="${my_review_list}">
                        <div class="item-card">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                                <div class="store-link-box">
                                    <a href="<c:url value='/store/detail?storeId=${review.store_id}'/>"
                                       style="font-size: 18px; font-weight: 900; color: #333; text-decoration: none;">
                                        🏨 ${review.store_name} 
                                        <small style="font-weight: normal; color: #999;">❯</small>
                                    </a>
                                    <div style="margin-top: 5px; color: #f1c40f;">
                                        <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                    </div>
                                </div>
                                <button type="button" class="btn-wire"
                                    style="height: 32px; padding: 0 12px; font-size: 12px; color: #dc3545; border-color: #dc3545;"
                                    onclick="confirmDeleteReview('${review.review_id}', '${review.store_id}')">
                                    <spring:message code="menu.btn.delete" text="Delete" />
                                </button>
                            </div>
                            <p style="line-height: 1.6; font-size: 15px; color: #444; margin-bottom: 15px;">${review.content}</p>
                            <div style="font-size: 13px; color: #aaa; font-weight: 800;">
                                <fmt:formatDate value="${review.review_date}" pattern="yyyy.MM.dd" />
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 60px 0; color: #ccc; font-weight: 900;">
                        <spring:message code="review.msg.empty" text="No reviews yet." />
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />