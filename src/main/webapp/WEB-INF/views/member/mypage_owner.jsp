<%-- 
    GourmetPass 프로젝트: 점주 마이페이지 (대시보드)
    - 점주 프로필, 매장 요약, 메뉴 리스트, 리뷰 요약을 제공합니다.
    - Spring Message Tag (text 속성)를 사용하여 안전한 다국어를 지원합니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<script src="<c:url value='/resources/js/mypage.js'/>"></script>

<div class="edit-wrapper" style="max-width: 1200px;">
    <%-- [1] 점주 프로필 섹션 --%>
    <div class="profile-card">
        <div class="profile-info">
            <span class="profile-label" style="color: #2f855a;">
                <%-- [수정] OWNER PROFILE 하드코딩 제거 --%>
                <spring:message code="mypage.owner.profile.label" text="OWNER PROFILE" />
            </span>
            <h2 class="user-name">
                ${member.user_nm} 
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

    <c:choose>
        <%-- [2] 가게 정보가 존재하는 경우 --%>
        <c:when test="${not empty store}">
            <a href="<c:url value='/book/manage?store_id=${store.store_id}'/>" class="status-btn-full">
                <spring:message code="mypage.owner.manage.center" text="⚙️ Reservation & Waiting Center" />
            </a>

            <div class="dashboard-grid">
                <%-- 가게 요약 정보 카드 --%>
                <aside class="dashboard-card">
                    <div class="card-header">
                        <h3 class="card-title">🏨 <spring:message code="mypage.owner.manage.store" text="Store Info" /></h3>
                        <button class="btn-wire" style="height: 32px; padding: 0 10px; font-size: 12px;" 
                                onclick="location.href='<c:url value='/store/update?store_id=${store.store_id}'/>'">
                            <spring:message code="common.btn.edit" text="Edit" />
                        </button>
                    </div>
                    <div style="text-align: center; margin-bottom: 25px;">
                        <div style="border: 2px solid #333; border-radius: 12px; overflow: hidden; height: 210px; background: #f9f9f9; margin-bottom: 15px;">
                            <c:choose>
                                <c:when test="${not empty store.store_img}">
                                    <img src="<c:url value='/upload/${store.store_img}'/>" style="width:100%; height:100%; object-fit:cover;">
                                </c:when>
                                <c:otherwise><div style="line-height:210px; color:#ccc; font-weight:900;">NO IMAGE</div></c:otherwise>
                            </c:choose>
                        </div>
                        <h4 style="font-size: 22px; font-weight: 900; margin-bottom: 8px;">${store.store_name}</h4>
                        <span class="badge-wire">${store.store_category}</span>
                    </div>
                    <table class="edit-table" style="font-size: 14px;">
                        <tr>
                            <th style="width: 40%;"><spring:message code="store.label.hours" text="Hours" /></th>
                            <td>${store.open_time} ~ ${store.close_time}</td>
                        </tr>
                        <tr>
                            <th><spring:message code="store.label.res_unit" text="Unit" /></th>
                            <td>${store.res_unit}<spring:message code="store.unit.minute" text="Mins" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="store.label.tel" text="Phone" /></th>
                            <td>${store.store_tel}</td>
                        </tr>
                    </table>
                </aside>

                <%-- 메뉴 관리 리스트 섹션 --%>
                <section class="dashboard-card">
                    <div class="card-header">
                        <h3 class="card-title">📋 <spring:message code="mypage.owner.manage.menu" text="Menu" /> (${menuList.size()})</h3>
                        <button class="btn-submit" style="width: auto; height: 38px; padding: 0 15px; font-size: 14px;" 
                                onclick="location.href='<c:url value='/store/menu/register?store_id=${store.store_id}'/>'">
                            <spring:message code="menu.btn.register" text="+ Add Menu" />
                        </button>
                    </div>
                    <table class="edit-table">
                        <thead>
                            <tr style="border-bottom: 2px solid #333;">
                                <th style="text-align: center; width: 80px;"><spring:message code="menu.label.image" text="Image" /></th>
                                <th><spring:message code="menu.label.name" text="Name" /></th>
                                <th style="text-align: right; width: 140px;"><spring:message code="menu.label.price" text="Price" /></th>
                                <th style="text-align: center; width: 150px;"><spring:message code="menu.label.manage" text="Manage" /></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="menu" items="${menuList}">
                                <tr>
                                    <td align="center">
                                        <c:if test="${not empty menu.menu_img}">
                                            <img src="<c:url value='/upload/${menu.menu_img}'/>" class="item-img-thumb" style="width:60px; height:60px;">
                                        </c:if>
                                    </td>
                                    <td>
                                        <div style="font-weight: 800; font-size: 16px;">
                                            ${menu.menu_name}
                                            <c:if test="${menu.menu_sign == 'Y'}">
                                                <span class="badge-best" style="background:#ff3d00; color:#fff; padding:2px 5px; border-radius:4px; font-size:11px; margin-left:5px;">
                                                    <spring:message code="menu.label.best" text="BEST" />
                                                </span>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td align="right" style="font-weight: 900; color: #ff3d00;">
                                        <fmt:formatNumber value="${menu.menu_price}" pattern="#,###" />
                                        <spring:message code="common.unit.won" text="Won" />
                                    </td>
                                    <td align="center">
                                        <div style="display: flex; gap: 6px; justify-content: center;">
                                            <button class="btn-wire" style="height: 32px; padding: 0 10px; font-size: 12px;" 
                                                    onclick="location.href='<c:url value='/store/menu/update?menu_id=${menu.menu_id}'/>'">
                                                <spring:message code="common.btn.edit" text="Edit" />
                                            </button>
                                            <button class="btn-wire" style="height: 32px; padding: 0 10px; font-size: 12px; color: #dc3545; border-color: #dc3545;" 
                                                    onclick="deleteMenu(${menu.menu_id})">
                                                <spring:message code="menu.btn.delete" text="Delete" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </section>
            </div>

            <%-- 리뷰 목록 섹션 --%>
            <div class="review-container">
                <h3 class="section-title">💬 <spring:message code="mypage.owner.manage.review" text="Reviews" /> (${store_review_list.size()})</h3>
                <div class="store-review-list">
                    <c:forEach var="review" items="${store_review_list}">
                        <div class="item-card">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 15px; border-bottom: 1px dashed #ddd; padding-bottom: 10px;">
                                <div>
                                    <strong style="font-size: 16px;">
                                        ${review.user_nm} <spring:message code="store.form.auth.login" text="" />
                                    </strong>
                                    <span style="color: #f1c40f; margin-left: 10px;"><c:forEach begin="1" end="${review.rating}">⭐</c:forEach></span>
                                </div>
                                <span style="color: #999; font-size: 13px;"><fmt:formatDate value="${review.review_date}" pattern="yyyy.MM.dd" /></span>
                            </div>
                            <div style="display: flex; gap: 20px;">
                                <c:if test="${not empty review.img_url}">
                                    <img src="<c:url value='/upload/${review.img_url}'/>" class="item-img-thumb" style="width:120px; height:120px;">
                                </c:if>
                                <p style="line-height: 1.6; font-size: 15px;">${review.content}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:when>

        <%-- [3] 가게 정보가 없는 경우 (Empty State) --%>
        <c:otherwise>
            <div class="dashboard-card" style="text-align: center; padding: 100px 0;">
                <h3 style="font-size: 26px; font-weight: 900;">
                    <%-- [수정] 누락된 키 적용 --%>
                    <spring:message code="mypage.owner.empty.title" text="No store linked." />
                </h3>
                <p style="color: #666; margin-top: 15px;">
                    <%-- [수정] 누락된 키 적용 --%>
                    <spring:message code="mypage.owner.empty.sub" text="Register your store to start Gourmet Pass services!" />
                </p>
                <button class="btn-submit" style="width: 300px; height: 55px; margin-top: 30px;" 
                        onclick="location.href='<c:url value='/member/signup/owner2'/>'">
                    <spring:message code="store.btn.final_submit" text="Register Store" />
                </button>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp" />