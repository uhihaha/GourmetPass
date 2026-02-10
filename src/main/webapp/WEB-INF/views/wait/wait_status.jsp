<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- 怨듭슜 ?ㅽ??쇱떆???곌껐 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/wait_status.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/review_list.css'/>">

<%-- ?ㅼ떆媛??뚮┝ ?쇱씠釉뚮윭由?--%>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<div class="edit-wrapper wait-status-wrapper" style="max-width: 1100px; margin: 40px auto;"
	data-user-id="<sec:authentication property='principal.username'/>"
	data-active-store-id="${not empty activeWait ? activeWait.store_id : (not empty activeBook ? activeBook.store_id : '')}">
	<div class="edit-title"><spring:message code="wait.status.title" text="?뱟 ?섏쓽 ?ㅼ떆媛??댁슜 ?꾪솴" /></div>

	<%-- 1. 吏꾪뻾 以묒씤 ?쒕퉬??(?ㅼ떆媛?移대뱶) --%>
	<div class="dashboard-card">
		<div class="card-header">
			<h3 class="card-title"><spring:message code="wait.active.title" text="?뵦 吏꾪뻾 以묒씤 ?쒕퉬?? /></h3>
			<span class="badge-wire"><spring:message code="wait.active.badge" text="?꾩옱 ?쒕룞 以? /></span>
		</div>

		<c:choose>
			<c:when test="${not empty activeWait or not empty activeBook}">
				<%-- ?⑥씠??移대뱶 --%>
				<c:if test="${not empty activeWait}">
					<div
						class="item-card status-card ${activeWait.wait_status == 'ING' ? 'dining-mode' : ''}">
						<div class="status-card-row">
							<div class="history-info">
								<c:choose>
									<c:when test="${activeWait.wait_status == 'ING'}">
										<span class="badge-wire badge-ing"><spring:message code="wait.badge.dining" text="?띂截??앹궗 以? /></span>
									</c:when>
									<c:when test="${activeWait.wait_status == 'CALLED'}">
										<span class="badge-wire badge-call"><spring:message code="wait.badge.called" text="?뱼 ?낆옣 ?몄텧!" /></span>
									</c:when>

									<c:when
										test="${activeWait.wait_status == 'WAITING' and aheadCount == 0}">
										<span class="badge-wire badge-call"><spring:message code="wait.badge.soon" text="?? 怨??낆옣!" /></span>
									</c:when>


									<c:otherwise>
										<span class="badge-wire"><spring:message code="wait.badge.waiting" text="?슯 ?⑥씠??以? /></span>
									</c:otherwise>
								</c:choose>
								<h3 class="status-store-name">${activeWait.store_name}</h3>
								<p class="status-subtext">
									<c:choose>
									<c:when test="${activeWait.wait_status == 'ING'}">
										<span class="dining-msg"><spring:message code="wait.msg.enjoy" text="留쏆엳???앹궗 ?섏꽭??" /></span>
									</c:when>
									<c:otherwise>
										<spring:message code="wait.msg.info" arguments="${activeWait.wait_num},${activeWait.people_cnt}" text="?湲?踰덊샇: {0}踰?/ {1}紐? />
										<c:if test="${not empty aheadCount}">
											<spring:message code="wait.msg.ahead" arguments="${aheadCount}" text="(????{0}?)" />
										</c:if>
									</c:otherwise>
								</c:choose>
								</p>
							</div>
							<div class="history-actions">
								<c:if test="${activeWait.wait_status == 'WAITING'}">
									<button type="button"
										class="btn-wire btn-danger-outline wait-cancel-btn"
										data-wait-id="${activeWait.wait_id}"><spring:message code="wait.btn.cancel" text="?⑥씠??痍⑥냼" /></button>
								</c:if>
								<c:if test="${activeWait.wait_status == 'ING'}">
                                    <button class="btn-small btn-payment js-alert"
                                        data-message="<spring:message code='wait.msg.preparing' text='寃곗젣 ?곸꽭 湲곕뒫 以鍮?以묒엯?덈떎.' />"><spring:message code="wait.btn.order_check" text="二쇰Ц ?뺤씤" /></button>
								</c:if>
							</div>
						</div>
					</div>
				</c:if>

				<%-- ?덉빟 移대뱶 --%>
				<%-- ?덉빟 移대뱶 ?대? --%>
				<c:if test="${not empty activeBook}">
					<div class="item-card status-card">
						<div class="status-card-row">
							<div class="history-info">
								<span class="badge-wire"><spring:message code="wait.badge.reserved" text="?뱟 ?덉빟 ?뺤젙" /></span>
								<h3 class="status-store-name">${activeBook.store_name}</h3>
								<p class="status-subtext">
									<fmt:formatDate var="bookDateText" value="${activeBook.book_date}" pattern="MM??dd??HH:mm" />
									<spring:message code="wait.msg.visit_time" arguments="${bookDateText}" text="諛⑸Ц ?쇱떆: {0}" />
								</p>
							</div>

							<div class="history-actions history-actions-right">
								<div class="status-visit-label"><spring:message code="wait.msg.upcoming" text="諛⑸Ц ?덉젙" /></div>

								<%-- ?덉빟 痍⑥냼 ??--%>
								<form action="<c:url value='/book/updateStatus'/>" method="post"
									id="userCancelForm">
									<input type="hidden" name="book_id"
										value="${activeBook.book_id}"> <input type="hidden"
										name="_csrf" value="${_csrf.token}" />

									<%-- 痍⑥냼 踰꾪듉 --%>
									<button type="button"
										class="btn-step btn-step-danger user-cancel-btn btn-cancel"
										data-payid="${activeBook.pay_id}"><spring:message code="wait.history.status.book_cancelled" text="?덉빟 痍⑥냼" /></button>
								</form>
							</div>
						</div>
					</div>
				</c:if>
			</c:when>
			<c:otherwise>
				<div class="status-empty"><spring:message code="wait.msg.empty" text="?꾩옱 ?댁슜 以묒씤 ?쒕퉬?ㅺ? ?놁뒿?덈떎." /></div>
			</c:otherwise>
		</c:choose>
	</div>


	<%-- 2. ?댁슜 ?덉뒪?좊━ (寃곗젣 諛?由щ럭 ?듯빀) --%>
<div class="dashboard-card status-history-card">
    <div class="card-header"
        style="display: flex; justify-content: space-between; align-items: center;">
        <h3 class="card-title"><spring:message code="wait.history.title" text="?뱶 理쒓렐 ?댁슜 ?댁뿭" /></h3>&nbsp;&nbsp;
        <a href="<c:url value='/member/history'/>" class="btn-wire"
            style="height: 32px; line-height: 30px; padding: 0 12px; font-size: 12px; text-decoration: none; color: #333;">
            <spring:message code="store.review.viewall" text="?꾩껜蹂닿린" /> ??</a>
    </div>

    <div class="history-container">
        <%-- ?⑥씠???뱀뀡 --%>
        <c:if test="${not empty finishedWaits}">
            <div class="history-section">
                <h4 class="history-section-title"><spring:message code="wait.history.wait.title" text="웨이팅 내역" /></h4>
                <c:forEach var="w" items="${finishedWaits}">
                    <div class="history-item">
                        <div class="history-info">
                            <div class="history-meta">
                                <span class="history-tag"><spring:message code="wait.history.type_wait" text="[웨이팅]" /></span>
                                <%-- ???쒓컙 ?쒖떆 ?섏젙: ?쒕텇 ?ы븿 --%>
                                <span class="history-date">
                                    <fmt:formatDate value="${w.wait_date}" pattern="yy.MM.dd HH:mm" />
                                </span>
                            </div>
                            <h4 class="history-store">${w.store_name}</h4>
                        </div>

                        <div class="history-actions">
                            <c:if test="${w.wait_status == 'FINISH'}">
                                <c:choose>
                                    <c:when test="${empty w.review_id}">
                                        <button class="btn-small btn-review js-review-link"
                                            data-url="<c:url value='/review/write?store_id=${w.store_id}&wait_id=${w.wait_id}'/>"><spring:message code="wait.history.btn.review" text="由щ럭 ?묒꽦" /></button>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-done"><spring:message code="wait.history.status.done" text="由щ럭?꾨즺" /></span>
                                        <button type="button" class="btn-delete-review"
                                            data-review-id="${w.review_id}" data-store-id="${w.store_id}"
                                            data-return-url="/member/wait_status"><spring:message code="common.btn.delete" text="??젣" /></button>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${w.wait_status == 'CANCELLED'}">
                                <span class="text-done text-done--danger"><spring:message code="wait.history.status.cancelled" text="痍⑥냼?? /></span>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <%-- ?덉빟 ?뱀뀡 --%>
        <c:if test="${not empty finishedBooks}">
            <div class="history-section">
                <h4 class="history-section-title"><spring:message code="wait.history.wait.title" text="웨이팅 내역" /></h4>
                <c:forEach var="b" items="${finishedBooks}">
                    <div class="history-item">
                        <div class="history-info">
                            <div class="history-meta">
                                <span class="history-tag"><spring:message code="wait.history.type_wait" text="[웨이팅]" /></span>
                                <%-- ???쒓컙 ?쒖떆 ?섏젙: ?쒕텇 ?ы븿 --%>
                                <span class="history-date">
                                    <fmt:formatDate value="${b.book_date}" pattern="yy.MM.dd HH:mm" />
                                </span>
                            </div>
                            <h4 class="history-store">${b.store_name}</h4>
                        </div>

                        <div class="history-actions">
                            <c:if test="${b.book_status == 'FINISH'}">
                                <!-- <button class="btn-small btn-payment js-alert"
                                    data-message="寃곗젣 ?곸꽭 ?뺣낫瑜??뺤씤?⑸땲??">寃곗젣?댁뿭</button> -->
                                <c:choose>
                                    <c:when test="${empty b.review_id}">
                                        <button class="btn-small btn-review js-review-link"
                                            data-url="<c:url value='/review/write?store_id=${b.store_id}&book_id=${b.book_id}'/>"><spring:message code="wait.history.btn.review" text="由щ럭 ?묒꽦" /></button>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-done"><spring:message code="wait.history.status.done" text="由щ럭?꾨즺" /></span>
                                        <button type="button" class="btn-delete-review"
                                            data-review-id="${b.review_id}" data-store-id="${b.store_id}"
                                            data-return-url="/member/wait_status"><spring:message code="common.btn.delete" text="??젣" /></button>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${b.book_status == 'RESERVED'}">
                                <span class="text-done text-done--success"><spring:message code="wait.history.status.reserved" text="諛⑸Ц?덉젙" /></span>
                            </c:if>
                            <c:if test="${b.book_status == 'CANCELED'}">
                                <span class="text-done text-done--cancel"><spring:message code="wait.history.status.book_cancelled" text="?덉빟痍⑥냼" /></span>
                            </c:if>
                            <c:if test="${b.book_status == 'NOSHOW'}">
                                <span class="text-done text-done--noshow"><spring:message code="wait.history.status.noshow" text="NO-SHOW" /></span>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <%-- ?댁뿭???놁쓣 ??--%>
        <c:if test="${empty finishedWaits and empty finishedBooks}">
            <div class="status-empty"><spring:message code="wait.history.empty" text="理쒓렐 ?댁슜 ?댁뿭???놁뒿?덈떎." /></div>
        </c:if>
    </div>
</div>
</div>

<script>
    window.I18N = window.I18N || {};
    window.I18N.wait = {
        bookCancelConfirm: "<spring:message code='wait.book.cancel.confirm' text='Cancel booking? Full refund will be processed.' javaScriptEscape='true' />",
        bookCancelConfirmRefund: "<spring:message code='wait.book.cancel.confirm_refund' text='Cancel booking and refund payment?' javaScriptEscape='true' />",
        payMissing: "<spring:message code='wait.pay.missing' text='Payment info missing. Refund not possible. Contact support.' javaScriptEscape='true' />",
        refundSuccess: "<spring:message code='wait.refund.success' text='Refund successful.' javaScriptEscape='true' />",
        refundFail: "<spring:message code='wait.refund.fail' text='Refund failed.' javaScriptEscape='true' />",
        refundDone: "<spring:message code='wait.refund.done' text='Refund completed.' javaScriptEscape='true' />",
        refundFailPrefix: "<spring:message code='wait.refund.fail_prefix' text='Refund failed:' javaScriptEscape='true' />",
        refundFailFallback: "<spring:message code='wait.refund.fail_fallback' text='Please contact admin.' javaScriptEscape='true' />",
        cancelConfirm: "<spring:message code='wait.cancel.confirm' text='Cancel waiting?' javaScriptEscape='true' />",
        cancelSuccess: "<spring:message code='wait.cancel.success' text='Waiting cancelled.' javaScriptEscape='true' />",
        cancelFail: "<spring:message code='wait.cancel.fail' text='Cancel failed.' javaScriptEscape='true' />",
        failPrefix: "<spring:message code='wait.fail.prefix' text='Failed:' javaScriptEscape='true' />"
    };
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
<script src="<c:url value='/resources/js/mypage.js'/>"></script>
<script src="<c:url value='/resources/js/member_mypage.js'/>"></script>
<script src="<c:url value='/resources/js/wait_status.js'/>"></script>

<script>
	// 由щ럭 ??젣 踰꾪듉 ?대깽??泥섎━
	document.addEventListener('click', function(e) {
		if (e.target.classList.contains('btn-delete-review')) {
			const reviewId = e.target.dataset.reviewId;
			const storeId = e.target.dataset.storeId;
			const returnUrl = e.target.dataset.returnUrl;

			if (typeof confirmDeleteReview === 'function') {
				confirmDeleteReview(reviewId, storeId, returnUrl);
			}
		}
	});
</script>

<jsp:include page="../common/footer.jsp" />



