<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- [愿?ъ궗 遺꾨━] 怨듭슜 留덉씠?섏씠吏 ?ㅽ???諛??듯빀 ?ㅽ겕由쏀듃 ?곌껐 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/review_list.css'/>">
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
<script src="<c:url value='/resources/js/mypage.js'/>"></script>

<div class="mypage-wrapper">
	<div class="profile-card">
		<div class="profile-info">
			<span class="profile-label"><spring:message code="mypage.user.profile.label" text="MEMBER PROFILE" /></span>
			<h2 class="user-name">${member.user_nm}
				<small><spring:message code="common.user.suffix" text="?? /></small>
			</h2>
			<p class="user-meta"><spring:message code="mypage.user.meta" arguments="${member.user_id},${member.user_tel}" text="ID: {0} | TEL: {1}" /></p>
		</div>
		<div class="btn-group" style="margin: 0; width: auto;">
			<a href="<c:url value='/member/edit'/>${review.store_name}</a>
									<div style="margin-top: 5px; color: #f1c40f;">
										<c:forEach begin="1" end="${review.rating}">狩?/c:forEach>
									</div>
								</div>
								<button type="button" class="btn-delete-review"
									data-review-id="${review.review_id}"
									data-store-id="${review.store_id}"
									data-return-url="/member/mypage"><spring:message code="common.btn.delete" text="??젣" /></button>	
							</div>
							<p
								style="line-height: 1.6; font-size: 15px; color: #444; margin-bottom: 15px;">${review.content}</p>
							<div style="font-size: 13px; color: #aaa; font-weight: 800;">
								<fmt:formatDate value="${review.review_date}"
									pattern="yyyy.MM.dd" />
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div
						style="text-align: center; padding: 60px 0; color: #ccc; font-weight: 900;">
						<spring:message code="mypage.user.review.empty" text="?꾩쭅 ?묒꽦??由щ럭 湲곕줉???놁뒿?덈떎." /></div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

<script src="<c:url value='/resources/js/member_mypage.js'/>"></script>
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

	document.addEventListener('click', function(e) {
		if (e.target.classList.contains('favorite-remove')) {
			e.preventDefault();
			const storeId = e.target.dataset.storeId;
			const card = e.target.closest('.favorite-card');

			fetch(APP_CONFIG.contextPath + '/favorite/toggle', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
					'X-CSRF-TOKEN': APP_CONFIG.csrfToken
				},
				body: new URLSearchParams({ store_id: storeId })
			}).then(function(res) {
				if (!res.ok) {
					throw new Error('favorite-toggle-failed');
				}
				return res.json();
			}).then(function(data) {
				if (!data.favorite && card) {
					card.remove();
				}
			}).catch(function() {
				alert(I18N.common.favoriteError);
			});
		}
	});
</script>

<jsp:include page="../common/footer.jsp" />

