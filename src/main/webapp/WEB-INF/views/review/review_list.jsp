<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- 1. ?ㅽ??쇱떆??遺꾨━ (?몃? ?뚯씪 ?몄텧) --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/store_list.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/review_list.css'/>">

<%-- 2. 而⑦뀒?대꼫??JS媛 李몄“???곗씠???띿꽦(data-) 二쇱엯 --%>
<div class="review-list-wrapper" 
     data-store-id="${store.store_id}" 
     data-context-path="${pageContext.request.contextPath}">
    
    <%-- ?곷떒 ?붿빟 ?ㅻ뜑: ?몃씪???ㅽ????쒓굅 諛??대옒?ㅽ솕 --%>
    <div class="review-dashboard-card">
        <div class="review-header-flex">
            <div class="header-left">
                <span class="badge-wire"><spring:message code="review.board.label" text="REVIEW BOARD" /></span>
                <h2 class="store-title">${store.store_name} <small><spring:message code="review.list.all" text="?꾩껜 由щ럭" /></small></h2>
            </div>
            <div class="header-right">
                <div class="rating-display">
                    狩?${store.avg_rating} <span class="total-count"><spring:message code="review.list.total" arguments="${pageMaker.total}" text="({0}嫄?" /></span>
                </div>
            </div>
        </div>
    </div>

    <%-- 由щ럭 紐⑸줉 ?뱀뀡 --%>
    <div class="review-container">
        <c:choose>
            <c:when test="${not empty allReviews}">
                <c:forEach var="rev" items="${allReviews}">
                    <div class="item-card">
						<div class="item-header">
							<div class="user-meta">
								<strong class="user-name"><spring:message code="review.list.customer" arguments="${rev.user_nm}" text="{0} 怨좉컼?? /></strong>
								<span class="stars"> <c:forEach begin="1"
										end="${rev.rating}">狩?/c:forEach>
								</span>
							</div>
							<div class="action-meta">
								<span class="date"> <fmt:formatDate
										value="${rev.review_date}" pattern="yyyy.MM.dd" />
								</span>
								<sec:authorize access="isAuthenticated()">
									<c:if
										test="${rev.user_id == pageContext.request.userPrincipal.name}">
										<button type="button" class="btn-delete-review"
											data-review-id="${rev.review_id}"
											data-store-id="${rev.store_id}"
											data-return-url="/review/list?store_id=${rev.store_id}"><spring:message code="common.btn.delete" text="??젣" /></button>
									</c:if>
								</sec:authorize>

							</div>
						</div>

						<div class="item-body">
                            <c:if test="${not empty rev.img_url}">
                                <div class="img-box">
                                    <img src="<c:url value='/upload/${rev.img_url}'/>">
                                </div>
                            </c:if>
                            <div class="content-box">
                                <p>${rev.content}</p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="review-empty-status"><spring:message code="store.review.empty" text="?꾩쭅 ?깅줉??由щ럭媛 ?놁뒿?덈떎." /></div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 3. ?섎떒 ?섏씠吏??뱀뀡: onclick ?쒓굅 諛?data-page ?띿꽦 異붽? --%>
    <div class="pagination-box">
        <ul class="pagination">
            <c:if test="${pageMaker.hasPreviousPage}">
                <li class="page-item">
                    <c:url var="prevUrl" value="/review/list">
                        <c:param name="store_id" value="${store.store_id}" />
                        <c:param name="pageNum" value="${pageMaker.prePage}" />
                        <c:param name="pageSize" value="${pageMaker.pageSize}" />
                    </c:url>
                    <a class="page-link" href="${prevUrl}" data-page="${pageMaker.prePage}"><spring:message code="store.list.paging.prev" text="PREV" /></a>
                </li>
            </c:if>

            <c:forEach var="num" items="${pageMaker.navigatepageNums}">
                <li class="page-item ${pageMaker.pageNum == num ? 'active' : ''}">
                    <c:url var="pageUrl" value="/review/list">
                        <c:param name="store_id" value="${store.store_id}" />
                        <c:param name="pageNum" value="${num}" />
                        <c:param name="pageSize" value="${pageMaker.pageSize}" />
                    </c:url>
                    <a class="page-link" href="${pageUrl}" data-page="${num}">${num}</a>
                </li>
            </c:forEach>

            <c:if test="${pageMaker.hasNextPage}">
                <li class="page-item">
                    <c:url var="nextUrl" value="/review/list">
                        <c:param name="store_id" value="${store.store_id}" />
                        <c:param name="pageNum" value="${pageMaker.nextPage}" />
                        <c:param name="pageSize" value="${pageMaker.pageSize}" />
                    </c:url>
                    <a class="page-link" href="${nextUrl}" data-page="${pageMaker.nextPage}"><spring:message code="store.list.paging.next" text="NEXT" /></a>
                </li>
            </c:if>
        </ul>
    </div>

    <%-- ?섎떒 ?ㅻ퉬寃뚯씠??踰꾪듉 --%>
    <div class="review-footer-nav">
        <button type="button" class="btn-wire-nav" id="btn-go-store"><spring:message code="review.list.btn.store" text="媛寃??곸꽭濡? /></button>
        <button type="button" class="btn-wire-nav" id="btn-go-back"><spring:message code="review.list.btn.back" text="?댁쟾 ?섏씠吏濡? /></button>
    </div>
</div>

<%-- 4. ?ㅽ겕由쏀듃 遺꾨━ (濡쒖쭅 ?쒓굅 ???몃? ?뚯씪 ?몄텧) --%>
<script>
    window.I18N = window.I18N || {};
    window.I18N.mypage = {
        menuDeleteConfirm: "<spring:message code='mypage.menu.delete.confirm' text='Delete this menu?' javaScriptEscape='true' />",
        menuDeleteConfirmStrong: "<spring:message code='mypage.menu.delete.confirm_strong' text='Delete this menu? This cannot be undone.' javaScriptEscape='true' />",
        waitCancelConfirm: "<spring:message code='mypage.wait.cancel.confirm' text='Cancel waiting?' javaScriptEscape='true' />",
        reviewDeleteConfirm: "<spring:message code='mypage.review.delete.confirm' text='Delete this review?' javaScriptEscape='true' />",
        userDropConfirm: "<spring:message code='mypage.user.drop.confirm' text='Delete your account? All data will be removed.' javaScriptEscape='true' />",
        userDropSuccess: "<spring:message code='mypage.user.drop.success' text='Account deleted.' javaScriptEscape='true' />",
        historyClose: "<spring:message code='mypage.history.close' text='Hide history' javaScriptEscape='true' />",
        historyCollapse: "<spring:message code='mypage.history.collapse' text='Collapse history' javaScriptEscape='true' />",
        historyOpen: "<spring:message code='mypage.history.open' text='Show all history' javaScriptEscape='true' />",
        notificationPrefix: "<spring:message code='mypage.notification.prefix' text='Notice:' javaScriptEscape='true' />"
    };
</script>
<script src="<c:url value='/resources/js/member_mypage.js'/>"></script>
<script src="<c:url value='/resources/js/review_list.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
