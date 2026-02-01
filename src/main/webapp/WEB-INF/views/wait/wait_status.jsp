<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">

<style>
/* 이용 현황 전용 애니메이션 및 스타일 */
.dining-mode { border: 2px solid #2e7d32 !important; background-color: #f1f8e9 !important; }
.dining-msg { font-size: 14px; color: #2e7d32; font-weight: 900; animation: pulse 2s infinite; }
@keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.6; } 100% { opacity: 1; } }
.status-card { margin-bottom: 25px; transition: 0.3s; }
.status-card:hover { transform: translateY(-5px); }
.badge-ing { background: #2e7d32; color: #fff; }
.badge-call { background: #ff3d00; color: #fff; animation: shake 0.5s infinite; }
@keyframes shake { 0% { transform: rotate(0); } 25% { transform: rotate(1deg); } 75% { transform: rotate(-1deg); } 100% { transform: rotate(0); } }
.history-item { display: flex; justify-content: space-between; align-items: center; padding: 20px; border-bottom: 1px solid #eee; transition: background 0.2s; }
.history-item:hover { background-color: #fafafa; }
.history-info { flex: 1; }
.history-actions { display: flex; gap: 8px; align-items: center; }
.btn-small { height: 32px; padding: 0 12px; font-size: 12px; font-weight: 800; border-radius: 4px; cursor: pointer; }
.btn-review { background: #ff3d00; color: #fff; border: none; }
.btn-payment { background: #fff; color: #333; border: 1px solid #ddd; }
.text-done { color: #ccc; font-size: 12px; font-weight: 800; }
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
APP_CONFIG.userId = "<sec:authentication property='principal.username'/>";
APP_CONFIG.activeStoreId = "${not empty activeWait ? activeWait.store_id : (not empty activeBook ? activeBook.store_id : '')}";
function connectRealtime() {
    const socket = new SockJS(APP_CONFIG.contextPath + '/ws');
    const stompClient = Stomp.over(socket);
    stompClient.debug = null;
    stompClient.connect({}, function (frame) {
        stompClient.subscribe('/topic/wait/' + APP_CONFIG.userId, function () { location.reload(); });
        if (APP_CONFIG.activeStoreId) {
            stompClient.subscribe('/topic/store/' + APP_CONFIG.activeStoreId + '/waitUpdate', function () { location.reload(); });
        }
    }, function() { setTimeout(connectRealtime, 5000); });
}

document.addEventListener("DOMContentLoaded", function() {
    if (APP_CONFIG.userId) connectRealtime();
});
</script>

<div class="edit-wrapper" style="max-width: 900px;">
	<div class="edit-title">
		<spring:message code="wait.status.title" text="📅 My Real-time Status" />
	</div>

	<%-- 1. 진행 중인 서비스 --%>
	<div class="dashboard-card">
		<div class="card-header">
			<h3 class="card-title"><spring:message code="wait.active.title" text="🔥 Active Service" /></h3>
			<span class="badge-wire"><spring:message code="wait.active.badge" text="Active" /></span>
		</div>

		<c:choose>
			<c:when test="${not empty activeWait or not empty activeBook}">
				<%-- 실시간 웨이팅 카드 --%>
				<c:if test="${not empty activeWait}">
					<div class="item-card status-card ${activeWait.wait_status == 'ING' ? 'dining-mode' : ''}">
						<div style="display: flex; justify-content: space-between; align-items: center;">
							<div class="history-info">
								<c:choose>
									<c:when test="${activeWait.wait_status == 'ING'}">
										<span class="badge-wire badge-ing"><spring:message code="wait.badge.dining" text="🍽️ Dining" /></span>
									</c:when>
									<c:when test="${activeWait.wait_status == 'CALLED'}">
										<span class="badge-wire badge-call"><spring:message code="wait.badge.called" text="📢 Called!" /></span>
									</c:when>
									<c:otherwise>
										<span class="badge-wire"><spring:message code="wait.badge.waiting" text="🚶 Waiting" /></span>
									</c:otherwise>
								</c:choose>
								<h3 style="font-size: 22px; font-weight: 900; margin: 10px 0;">${activeWait.store_name}</h3>
								<p style="font-size: 15px; color: #555;">
									<c:choose>
										<c:when test="${activeWait.wait_status == 'ING'}">
											<span class="dining-msg"><spring:message code="wait.msg.enjoy" text="Enjoy your meal!" /></span>
										</c:when>
										<c:otherwise>
											<spring:message code="wait.msg.info" arguments="${activeWait.wait_num},${activeWait.people_cnt}" />
										</c:otherwise>
									</c:choose>
								</p>
							</div>
							<div class="history-actions">
								<c:if test="${activeWait.wait_status == 'WAITING'}">
									<button type="button" class="btn-wire" style="color: #dc3545; border-color: #dc3545;" onclick="cancelWait('${activeWait.wait_id}')">
										<spring:message code="wait.btn.cancel" text="Cancel" />
									</button>
								</c:if>
								<c:if test="${activeWait.wait_status == 'ING'}">
									<button class="btn-small btn-payment" onclick="alert('<spring:message code="common.msg.preparing" text="This feature is coming soon." />')">
										<spring:message code="wait.btn.order_check" text="Order Check" />
									</button>
								</c:if>
							</div>
						</div>
					</div>
				</c:if>

				<%-- 실시간 예약 카드 --%>
				<c:if test="${not empty activeBook}">
					<div class="item-card status-card">
						<div style="display: flex; justify-content: space-between; align-items: center;">
							<div class="history-info">
								<span class="badge-wire"><spring:message code="wait.badge.reserved" text="📅 Reserved" /></span>
								<h3 style="font-size: 22px; font-weight: 900; margin: 10px 0;">${activeBook.store_name}</h3>
								<p style="font-size: 15px; color: #555;">
									<fmt:formatDate var="fmtDate" value="${activeBook.book_date}" pattern="MM-dd HH:mm" />
									<spring:message code="wait.msg.visit_time" arguments="${fmtDate}" />
								</p>
							</div>
							<div class="history-actions" style="text-align: right;">
								<div style="font-weight: 900; font-size: 14px; color: #2e7d32; margin-bottom: 10px;">
									<spring:message code="wait.msg.upcoming" text="Upcoming" />
								</div>
								<form action="<c:url value='/book/updateStatus'/>" method="post" id="userCancelForm">
									<input type="hidden" name="book_id" value="${activeBook.book_id}"> 
									<input type="hidden" name="_csrf" value="${_csrf.token}" />
									<button type="button" class="btn-step btn-step-danger user-cancel-btn" data-payid="${activeBook.pay_id}" style="padding: 8px 15px; border-radius: 5px; cursor: pointer;">
										<spring:message code="wait.btn.cancel" text="Cancel" />
									</button>
								</form>
							</div>
						</div>
					</div>
				</c:if>
			</c:when>
			<c:otherwise>
				<div style="text-align: center; padding: 50px 0; color: #999; font-weight: 800;">
					<spring:message code="wait.msg.empty" text="No active services." />
				</div>
			</c:otherwise>
		</c:choose>
	</div>

	<%-- 2. 이용 히스토리 --%>
	<div class="dashboard-card" style="margin-top: 30px;">
		<div class="card-header">
			<h3 class="card-title"><spring:message code="wait.history.title" text="📜 History" /></h3>
			<span class="badge-wire"><spring:message code="wait.history.badge" text="Recent" /></span>
		</div>

		<div class="history-container">
			<%-- 웨이팅 히스토리 --%>
			<c:forEach var="w" items="${my_wait_list}">
				<div class="history-item">
					<div class="history-info">
						<div style="display: flex; align-items: center; gap: 10px; margin-bottom: 5px;">
							<span style="font-size: 12px; color: #999; font-weight: 700;"><spring:message code="wait.history.type_wait" text="[Waiting]" /></span>
							<span style="font-size: 13px; color: #666;"><fmt:formatDate value="${w.wait_date}" pattern="yy.MM.dd" /></span>
						</div>
						<h4 style="font-size: 17px; font-weight: 800; margin: 0;">${w.store_name}</h4>
					</div>
					<div class="history-actions">
						<c:if test="${w.wait_status == 'FINISH'}">
							<button class="btn-small btn-payment" onclick="alert('<spring:message code="common.msg.preparing" text="This feature is coming soon." />')">
								<spring:message code="wait.history.btn.payment" text="Payment" />
							</button>
							<c:choose>
								<c:when test="${empty w.review_id}">
									<button class="btn-small btn-review" onclick="location.href='<c:url value='/review/write?store_id=${w.store_id}&wait_id=${w.wait_id}'/>'">
										<spring:message code="wait.history.btn.review" text="Review" />
									</button>
								</c:when>
								<c:otherwise><span class="text-done"><spring:message code="wait.history.status.done" text="Reviewed" /></span></c:otherwise>
							</c:choose>
						</c:if>
						<c:if test="${w.wait_status == 'CANCELLED'}"><span class="text-done" style="color: #dc3545"><spring:message code="wait.history.status.cancelled" text="Cancelled" /></span></c:if>
					</div>
				</div>
			</c:forEach>

			<%-- 예약 히스토리 --%>
			<c:forEach var="b" items="${my_book_list}">
				<div class="history-item">
					<div class="history-info">
						<div style="display: flex; align-items: center; gap: 10px; margin-bottom: 5px;">
							<span style="font-size: 12px; color: #999; font-weight: 700;"><spring:message code="wait.history.type_book" text="[Booking]" /></span>
							<span style="font-size: 13px; color: #666;"><fmt:formatDate value="${b.book_date}" pattern="yy.MM.dd" /></span>
						</div>
						<h4 style="font-size: 17px; font-weight: 800; margin: 0;">${b.store_name}</h4>
					</div>
					<div class="history-actions">
						<c:if test="${b.book_status == 'FINISH'}">
							<button class="btn-small btn-payment" onclick="alert('<spring:message code="common.msg.preparing" text="This feature is coming soon." />')">
								<spring:message code="wait.history.btn.payment" text="Payment" />
							</button>
							<c:choose>
								<c:when test="${empty b.review_id}">
									<button class="btn-small btn-review" onclick="location.href='<c:url value='/review/write?store_id=${b.store_id}&book_id=${b.book_id}'/>'">
										<spring:message code="wait.history.btn.review" text="Review" />
									</button>
								</c:when>
								<c:otherwise><span class="text-done"><spring:message code="wait.history.status.done" text="Reviewed" /></span></c:otherwise>
							</c:choose>
						</c:if>
						<c:if test="${b.book_status == 'RESERVED'}"><span class="text-done" style="color: #2e7d32"><spring:message code="wait.history.status.reserved" text="Reserved" /></span></c:if>
						<c:if test="${b.book_status == 'CANCELED'}"><span class="text-done" style="color: #bd2222"><spring:message code="wait.history.status.book_cancelled" text="Cancelled" /></span></c:if>
						<c:if test="${b.book_status == 'NOSHOW'}"><span class="text-done" style="color: #B22222"><spring:message code="wait.history.status.noshow" text="NO-SHOW" /></span></c:if>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</div>

<script src="<c:url value='/resources/js/mypage.js'/>"></script>
<script src="<c:url value='/resources/js/wait_status.js'/>"></script>
<jsp:include page="../common/footer.jsp" />