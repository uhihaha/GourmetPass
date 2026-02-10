<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- [관심사 분리] 공용 마이페이지 스타일 및 통합 스크립트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/review_list.css'/>">
<script src="<c:url value='/resources/js/mypage.js'/>"></script>

<div class="mypage-wrapper">
	<div class="profile-card">
		<div class="profile-info">
			<span class="profile-label"><spring:message code="mypage.user.profile.label" text="MEMBER PROFILE" /></span>
			<h2 class="user-name">${member.user_nm}
				<small><spring:message code="common.user.suffix" text="님" /></small>
			</h2>
			<p class="user-meta"><spring:message code="mypage.user.meta" arguments="${member.user_id},${member.user_tel}" text="ID: {0} | TEL: {1}" /></p>
		</div>
		<div class="btn-group" style="margin: 0; width: auto;">
			<a href="<c:url value='/member/edit'/>" class="btn-wire"
				style="height: 45px; padding: 0 20px; font-size: 14px;"><spring:message code="common.btn.edit" text="정보 수정" /></a>
			<form action="<c:url value='/logout'/>" method="post"
				style="display: inline;">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
				<button type="submit" class="btn-wire btn-logout"
					style="height: 45px; padding: 0 20px; font-size: 14px; margin-left: 10px;"><spring:message code="common.nav.logout" text="로그아웃" /></button>
			</form>
		</div>
	</div>

	<%-- mypage.jsp 내부 핵심 버튼 링크 수정 --%>
	<div class="menu-container">
		<a href="<c:url value='/member/wait_status'/>" class="status-btn-full">
			<spring:message code="mypage.user.status.title" text="📅 나의 이용현황 (예약 / 웨이팅)" /> </a>
	</div>
	<hr class="section-divider">

	<div class="dashboard-card">
		<div class="card-header"
			style="display: flex; justify-content: space-between; align-items: center;">
			<h3 class="card-title"><spring:message code="mypage.user.favorite.title" text="❤️ 내 즐겨찾기" /></h3>
			<span class="favorite-count"><spring:message code="mypage.user.favorite.count" arguments="${fn:length(favorite_list)}" text="총 {0}개" /></span>
		</div>
		<div class="favorite-grid">
			<c:choose>
				<c:when test="${not empty favorite_list}">
					<c:forEach var="fav" items="${favorite_list}">
						<div class="favorite-card" data-store-id="${fav.store_id}">
							<button type="button" class="favorite-remove"
								data-store-id="${fav.store_id}"><spring:message code="common.btn.delete" text="삭제" /></button>
							<a class="favorite-link"
								href="<c:url value='/store/detail?storeId=${fav.store_id}'/>">
								<div class="favorite-thumb">
									<c:choose>
										<c:when test="${not empty fav.store_img}">
											<img src="<c:url value='/upload/${fav.store_img}'/>" alt="${fav.store_name}">
										</c:when>
										<c:otherwise>
											<div class="no-img-placeholder">NO IMAGE</div>
										</c:otherwise>
									</c:choose>
								</div>
								<div class="favorite-info">
									<span class="badge-cat">${fav.store_category}</span>
									<div class="favorite-name">${fav.store_name}</div>
									<div class="favorite-meta">⭐ ${fav.avg_rating}</div>
								</div>
							</a>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="empty-status-box"
						style="grid-column: 1/-1; text-align: center; padding: 40px 0; color: #ccc; font-weight: 900;">
						<spring:message code="mypage.user.favorite.empty" text="즐겨찾기에 등록된 매장이 없습니다." /></div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<div class="dashboard-card">
		<div class="card-header"
			style="display: flex; justify-content: space-between; align-items: center;">
			<%-- [수정] 컨트롤러에서 전달받은 전체 개수(total_review_cnt) 표시 --%>
			<h3 class="card-title"><spring:message code="mypage.user.review.recent" text="💬 최근 리뷰" />&nbsp;&nbsp;</h3>

			<%-- [추가] 전체보기 링크: 신규 생성할 전체 이력 페이지(/member/review/mine)로 연결 --%>
			<a href="<c:url value='/member/review/mine'/>" class="btn-wire"
				style="height: 32px; line-height: 30px; padding: 0 12px; font-size: 12px; text-decoration: none; color: #333;"><spring:message code="store.review.viewall" text="전체보기" />
				❯</a>
		</div>

		<div class="review-list">
			<c:choose>
				<c:when test="${not empty my_review_list}">
					<c:forEach var="review" items="${my_review_list}" begin="0" end="1">
						<%-- 최근 2개까지만 표시 --%>
						<div class="item-card">
							<div
								style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
								<div class="store-link-box">
									<a
										href="<c:url value='/store/detail?storeId=${review.store_id}'/>"
										style="font-size: 18px; font-weight: 900; color: #333; text-decoration: none;">
										🏨 ${review.store_name} <small
										style="font-weight: normal; color: #999;">❯</small>
									</a>
									<div style="margin-top: 5px; color: #f1c40f;">
										<c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
									</div>
								</div>
								<button type="button" class="btn-delete-review"
									data-review-id="${review.review_id}"
									data-store-id="${review.store_id}"
									data-return-url="/member/mypage"><spring:message code="common.btn.delete" text="삭제" /></button>	
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
						<spring:message code="mypage.user.review.empty" text="아직 작성된 리뷰 기록이 없습니다." /></div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

<script src="<c:url value='/resources/js/member_mypage.js'/>"></script>
<script>
	const t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
		? window.I18N_UTIL.t
		: function(key, fallback) { return fallback || key; };

	// 리뷰 삭제 버튼 이벤트 처리
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
				alert(t("common.favoriteError", "즐겨찾기 처리 중 오류가 발생했습니다."));
			});
		}
	});
</script>

<jsp:include page="../common/footer.jsp" />
