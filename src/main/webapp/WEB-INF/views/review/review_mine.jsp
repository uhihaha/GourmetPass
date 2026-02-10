<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- 湲곗〈 ?ㅽ????쒗듃 ?ъ궗??--%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/store_list.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/review_list.css'/>">

<%-- 而⑦뀒?대꼫: JS媛 ?대룞 寃쎈줈瑜??뚯븙?????덈룄濡??곗씠??二쇱엯 --%>
<div class="review-mine-wrapper"
	data-context-path="${pageContext.request.contextPath}">

	<%-- ?곷떒 ?붿빟 ?ㅻ뜑: ?섏쓽 ?쒕룞 以묒떖 --%>
	<div class="review-dashboard-card">
		<div class="review-header-flex">
			<div class="header-left">
				<span class="badge-wire"><spring:message code="review.mine.badge" text="MY ACTIVITY" /></span>
				<h2 class="store-title">
					<spring:message code="review.mine.title" text="?섏쓽 由щ럭 ?대젰" /> <small><spring:message code="review.mine.total" arguments="${pageMaker.total}" text="珥?{0}嫄? /></small>
				</h2>
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
								<%-- 媛寃??곸꽭?섏씠吏濡?諛붾줈媛??留곹겕 異붽? --%>
								<a href="<c:url value='/store/detail?storeId=${rev.store_id}'/>"
									class="user-name"
									style="text-decoration: none; color: inherit;"> ?룳
									${rev.store_name} <small style="color: #999;">??/small>
								</a> <span class="stars"> <c:forEach begin="1"
										end="${rev.rating}">狩?/c:forEach>
								</span>
							</div>
							<div class="action-meta">
								<span class="date"> <fmt:formatDate
										value="${rev.review_date}" pattern="yyyy.MM.dd" />
								</span>
								<%-- ??젣 濡쒖쭅 ?좎? --%>
								<button type="button" class="btn-delete-review"
									data-review-id="${rev.review_id}"
									data-store-id="${rev.store_id}"
									data-return-url="/member/review/mine"><spring:message code="common.btn.delete" text="??젣" /></button>
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
				<div class="review-empty-status"><spring:message code="review.mine.empty" text="?꾩쭅 ?묒꽦?섏떊 由щ럭媛 ?놁뒿?덈떎." /></div>
			</c:otherwise>
		</c:choose>
	</div>

	<%-- ?섎떒 ?섏씠吏??뱀뀡 --%>
	<div class="pagination-box">
		<ul class="pagination">
			<c:if test="${pageMaker.hasPreviousPage}">
				<li class="page-item"><a class="page-link"
					href="<c:url value='/member/review/mine?pageNum=${pageMaker.prePage}'/>"
					data-page="${pageMaker.prePage}"><spring:message code="store.list.paging.prev" text="PREV" /></a></li>
			</c:if>

			<c:forEach var="num" items="${pageMaker.navigatepageNums}">
				<li class="page-item ${pageMaker.pageNum == num ? 'active' : ''}">
					<a class="page-link"
					href="<c:url value='/member/review/mine?pageNum=${num}'/>"
					data-page="${num}">${num}</a>
				</li>
			</c:forEach>

			<c:if test="${pageMaker.hasNextPage}">
				<li class="page-item"><a class="page-link"
					href="<c:url value='/member/review/mine?pageNum=${pageMaker.nextPage}'/>"
					data-page="${pageMaker.nextPage}"><spring:message code="store.list.paging.next" text="NEXT" /></a></li>
			</c:if>
		</ul>
	</div>

	<%-- ?섎떒 ?ㅻ퉬寃뚯씠??踰꾪듉 --%>
	<div class="review-footer-nav">
		<button type="button" class="btn-wire-nav"
			onclick="location.href='<c:url value='/member/mypage'/>'"><spring:message code="review.mine.btn.mypage" text="留덉씠?섏씠吏濡? /></button>
	</div>
</div>

<%-- ?ㅽ겕由쏀듃 遺꾨━ --%>
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
<script src="<c:url value='/resources/js/review_mine.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
