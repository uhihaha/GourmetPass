<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/wait_status.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/review_list.css'/>">


<div class="edit-wrapper wait-status-wrapper" style="max-width: 1100px; margin: 40px auto;">
    <div class="edit-title"><spring:message code="wait.history.all.title" text="?뱶 ?꾩껜 ?댁슜 ?댁뿭" /></div>

    <%-- ?⑥씠???댁뿭 ?뱀뀡 --%>
    <div class="dashboard-card status-history-card">
        <div class="card-header">
            <h3 class="card-title"><spring:message code="wait.history.wait.title" text="?슯 ?⑥씠???댁뿭" /></h3>
            <span class="badge-wire"><spring:message code="wait.history.total" arguments="${waitPageInfo.total}" text="珥?{0}嫄? /></span>
        </div>

        <div class="history-container">
            <c:choose>
                <c:when test="${not empty my_wait_list}">
                    <c:forEach var="w" items="${my_wait_list}">
                        <div class="history-item">
                            <div class="history-info">
                                <div class="history-meta">
                                    <span class="history-tag"><spring:message code="wait.history.type_wait" text="[?⑥씠??" /></span>
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
                                                data-review-id="${w.review_id}" 
                                                data-store-id="${w.store_id}"
                                                data-return-url="/member/history?waitPage=${waitPageInfo.pageNum}&bookPage=${bookPageInfo.pageNum}"><spring:message code="common.btn.delete" text="??젣" /></button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:if test="${w.wait_status == 'CANCELLED'}">
                                    <span class="text-done text-done--danger"><spring:message code="wait.history.status.cancelled" text="痍⑥냼?? /></span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="status-empty"><spring:message code="wait.history.wait.empty" text="?⑥씠???댁뿭???놁뒿?덈떎." /></div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- ?⑥씠???섏씠吏?--%>
        <c:if test="${waitPageInfo.pages > 1}">
            <div class="pagination-container">
                <c:if test="${waitPageInfo.hasPreviousPage}">
                    <a href="?waitPage=${waitPageInfo.pageNum - 1}&bookPage=${bookPageInfo.pageNum}" class="btn-wire"><spring:message code="common.btn.back" text="?댁쟾" /></a>
                </c:if>
                
                <%-- ???섏젙: fn:length() ?ъ슜 --%>
                <c:set var="navLength" value="${fn:length(waitPageInfo.navigatepageNums)}" />
                <c:forEach begin="0" end="${navLength - 1}" var="i">
                    <c:set var="num" value="${waitPageInfo.navigatepageNums[i]}" />
                    <a href="?waitPage=${num}&bookPage=${bookPageInfo.pageNum}" 
                       class="btn-wire ${num == waitPageInfo.pageNum ? 'active' : ''}">${num}</a>
                </c:forEach>
                
                <c:if test="${waitPageInfo.hasNextPage}">
                    <a href="?waitPage=${waitPageInfo.pageNum + 1}&bookPage=${bookPageInfo.pageNum}" class="btn-wire"><spring:message code="common.btn.next" text="?ㅼ쓬" /></a>
                </c:if>
            </div>
        </c:if>
    </div>

    <%-- ?덉빟 ?댁뿭 ?뱀뀡 --%>
    <div class="dashboard-card status-history-card" style="margin-top: 40px;">
        <div class="card-header">
            <h3 class="card-title"><spring:message code="wait.history.book.title" text="?뱟 ?덉빟 ?댁뿭" /></h3>
            <span class="badge-wire"><spring:message code="wait.history.total" arguments="${bookPageInfo.total}" text="珥?{0}嫄? /></span>
        </div>

        <div class="history-container">
            <c:choose>
                <c:when test="${not empty my_book_list}">
                    <c:forEach var="b" items="${my_book_list}">
                        <div class="history-item">
                            <div class="history-info">
                                <div class="history-meta">
                                    <span class="history-tag"><spring:message code="wait.history.type_book" text="[?덉빟]" /></span>
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
                                                data-review-id="${b.review_id}" 
                                                data-store-id="${b.store_id}"
                                                data-return-url="/member/history?waitPage=${waitPageInfo.pageNum}&bookPage=${bookPageInfo.pageNum}"><spring:message code="common.btn.delete" text="??젣" /></button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:if test="${b.book_status == 'RESERVED'}">
                                    <div style="display: flex; align-items: center; gap: 8px;">
							            <span class="text-done text-done--success"><spring:message code="wait.history.status.reserved" text="諛⑸Ц?덉젙" /></span>
							            
							            <%-- 痍⑥냼 泥섎━???④꺼吏???--%>
							            <form action="<c:url value='/book/updateStatus'/>" method="post" class="userCancelForm">
							                <input type="hidden" name="book_id" value="${b.book_id}">
							                <input type="hidden" name="_csrf" value="${_csrf.token}" />
							                <button type="button" 
							                        class="btn-small btn-danger-outline history-cancel-btn"
							                        data-payid="${b.pay_id}"
							                        style="padding: 4px 8px; font-size: 11px;"><spring:message code="wait.history.status.book_cancelled" text="?덉빟痍⑥냼" /></button>
							            </form>
							        </div>
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
                </c:when>
                <c:otherwise>
                    <div class="status-empty"><spring:message code="wait.history.book.empty" text="?덉빟 ?댁뿭???놁뒿?덈떎." /></div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- ?덉빟 ?섏씠吏?--%>
        <c:if test="${bookPageInfo.pages > 1}">
            <div class="pagination-container">
                <c:if test="${bookPageInfo.hasPreviousPage}">
                    <a href="?waitPage=${waitPageInfo.pageNum}&bookPage=${bookPageInfo.pageNum - 1}" class="btn-wire"><spring:message code="common.btn.back" text="?댁쟾" /></a>
                </c:if>
                
                <%-- ???섏젙: fn:length() ?ъ슜 --%>
                <c:set var="navLength" value="${fn:length(bookPageInfo.navigatepageNums)}" />
                <c:forEach begin="0" end="${navLength - 1}" var="i">
                    <c:set var="num" value="${bookPageInfo.navigatepageNums[i]}" />
                    <a href="?waitPage=${waitPageInfo.pageNum}&bookPage=${num}" 
                       class="btn-wire ${num == bookPageInfo.pageNum ? 'active' : ''}">${num}</a>
                </c:forEach>
                
                <c:if test="${bookPageInfo.hasNextPage}">
                    <a href="?waitPage=${waitPageInfo.pageNum}&bookPage=${bookPageInfo.pageNum + 1}" class="btn-wire"><spring:message code="common.btn.next" text="?ㅼ쓬" /></a>
                </c:if>
            </div>
        </c:if>
    </div>

    <%-- ?섎떒 ?ㅻ퉬寃뚯씠??踰꾪듉 --%>
    <div style="text-align: center; margin-top: 50px;">
        <button type="button" class="btn-wire" style="width: 200px; height: 55px;" onclick="location.href='<c:url value='/member/wait_status'/>'"><spring:message code="wait.history.btn.status" text="?댁슜 ?꾪솴?쇰줈" /></button>
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

<!-- <script>
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

// JS 怨듯넻 湲곕뒫
$(".js-alert").on("click", function() {
    alert($(this).data("message"));
});

$(".js-review-link").on("click", function() {
    location.href = $(this).data("url");
});
</script> -->

<%-- JSP ?섎떒 --%>
<script src="<c:url value='/resources/js/wait_history.js'/>"></script>

<script>
// ?섏씠吏 媛쒕퀎?곸쑝濡??꾩슂????젣 ?뺤씤李??깅쭔 ?④퉩?덈떎.
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
