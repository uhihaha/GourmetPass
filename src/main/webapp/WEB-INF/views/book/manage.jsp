<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- 외부 스타일 시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/manage.css'/>">

<div class="edit-wrapper" style="max-width: 1100px; margin: 40px auto;">
	<div class="edit-title">
		<spring:message code="manage.title" text="⚙️ 실시간 매장 관리 센터" />
	</div>

	<%-- 1. 실시간 웨이팅 섹션 --%>
	<div class="dashboard-card">
		<%-- 입장 대기 중인(WAITING, CALLED) 팀 합산 로직 유지 --%>
		<c:set var="realWaitCount" value="0" />
		<c:forEach var="w" items="${store_wait_list}">
			<c:if test="${w.wait_status == 'WAITING' or w.wait_status == 'CALLED'}">
				<c:set var="realWaitCount" value="${realWaitCount + 1}" />
			</c:if>
		</c:forEach>

		<div class="card-header-flex">
			<h3 class="card-title-wait">
				🚶 <spring:message code="manage.wait.title" text="실시간 웨이팅 현황" />
			</h3>
			<span class="badge-wire">
                <%-- [수정] 누락된 키 적용 (Waiting {0} Team(s)) --%>
				<spring:message code="manage.wait.team_count" arguments="${realWaitCount}" text="입장 대기 ${realWaitCount}팀" />
			</span>
		</div>

		<table class="manage-dashboard-table">
			<thead>
				<tr>
					<th class="col-num"><spring:message code="manage.col.num" text="No." /></th>
					<th class="col-userid"><spring:message code="manage.col.userid" text="고객ID" /></th>
					<th class="col-people"><spring:message code="manage.col.people" text="인원" /></th>
					<th class="col-status"><spring:message code="manage.col.status" text="상태" /></th>
					<th class="col-action"><spring:message code="manage.col.action" text="상태 제어" /></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="wait" items="${store_wait_list}">
					<c:if test="${wait.wait_status != 'FINISH' and wait.wait_status != 'CANCELLED'}">
						<tr>
							<td align="center"><b>${wait.wait_num}<spring:message code="manage.col.num" text="" /></b></td>
							<td align="center">${wait.user_id}</td>
							<td align="center">${wait.people_cnt}<spring:message code="common.unit.person" text="명" /></td>
							<td align="center">
								<c:choose>
									<c:when test="${wait.wait_status == 'WAITING'}">
										<span class="badge-wire"><spring:message code="manage.status.waiting" text="Waiting" /></span>
									</c:when>
									<c:when test="${wait.wait_status == 'CALLED'}">
										<span class="badge-wire badge-called"><spring:message code="manage.status.called" text="Calling" /></span>
									</c:when>
									<c:when test="${wait.wait_status == 'ING'}">
										<span class="badge-wire badge-ing"><spring:message code="manage.status.ing" text="Dining" /></span>
									</c:when>
								</c:choose>
							</td>
							<td align="center">
								<form action="<c:url value='/store/wait/updateStatus'/>" method="post" class="action-btn-group">
									<input type="hidden" name="wait_id" value="${wait.wait_id}">
									<input type="hidden" name="user_id" value="${wait.user_id}">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

									<c:choose>
										<c:when test="${wait.wait_status == 'WAITING'}">
											<button type="submit" name="status" value="CALLED" class="btn-step btn-step-primary">
												<spring:message code="manage.btn.call" text="Call Now" />
											</button>
											<button type="submit" name="status" value="CANCELLED" class="btn-step btn-step-danger">
												<spring:message code="common.btn.cancel" text="Cancel" />
											</button>
										</c:when>
										<c:when test="${wait.wait_status == 'CALLED'}">
											<button type="submit" name="status" value="ING" class="btn-step btn-step-next">
												<spring:message code="manage.btn.entry" text="Confirm Entry" />
											</button>
											<button type="submit" name="status" value="CANCELLED" class="btn-step btn-step-danger">
												<spring:message code="manage.btn.noshow" text="No-Show" />
											</button>
										</c:when>
										<c:when test="${wait.wait_status == 'ING'}">
											<button type="submit" name="status" value="FINISH" class="btn-step btn-finish">
												<spring:message code="manage.btn.finish" text="Finish" />
											</button>
										</c:when>
									</c:choose>
								</form>
							</td>
						</tr>
					</c:if>
				</c:forEach>
			</tbody>
		</table>
	</div>

	<%-- 2. 오늘 예약 섹션 --%>
	<div class="dashboard-card">
		<div class="card-header-flex">
			<h3 class="card-title-book">📅 <spring:message code="manage.book.title" text="오늘 예약 현황" /></h3>
			<span class="badge-wire">
				<spring:message code="manage.book.total" arguments="${store_book_list.size()}" text="총 ${store_book_list.size()}건" />
			</span>
		</div>

		<table class="manage-dashboard-table">
			<thead>
				<tr>
					<th class="col-num"><spring:message code="store.form.label.time" text="Time" /></th>
					<th class="col-userid"><spring:message code="manage.col.userid" text="User ID" /></th>
					<th class="col-people"><spring:message code="manage.col.people" text="Party" /></th>
					<th class="col-status"><spring:message code="manage.col.status" text="Status" /></th>
					<th class="col-action"><spring:message code="manage.col.action" text="Action" /></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="book" items="${store_book_list}">
					<tr>
						<td align="center"><b><fmt:formatDate value="${book.book_date}" pattern="HH:mm" /></b></td>
						<td align="center">${book.user_id}</td>
						<td align="center">${book.people_cnt}<spring:message code="common.unit.person" text="명" /></td>
						<td align="center">
							<span class="badge-wire ${book.book_status == 'ING' ? 'badge-ing' : ''}">
								<c:choose>
									<c:when test="${book.book_status == 'RESERVED'}"><spring:message code="manage.status.reserved" text="Reserved" /></c:when>
									<c:when test="${book.book_status == 'ING'}"><spring:message code="manage.status.ing" text="Dining" /></c:when>
									<c:otherwise>${book.book_status}</c:otherwise>
								</c:choose>
							</span>
						</td>
						<td align="center">
							<form action="<c:url value='/book/updateStatus'/>" method="post" class="action-btn-group">
								<input type="hidden" name="book_id" value="${book.book_id}">
								<input type="hidden" name="user_id" value="${book.user_id}">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

								<c:choose>
									<c:when test="${book.book_status == 'RESERVED'}">
										<button type="submit" name="status" value="ING" class="btn-step btn-step-next">
											<spring:message code="manage.btn.entry" text="Confirm Entry" />
										</button>
										<button type="button" name="status" value="NOSHOW" class="btn-step btn-step-danger noshow-btn" data-payid="${book.pay_id}">
											<spring:message code="manage.btn.noshow" text="No-Show" />
										</button>
									</c:when>
									<c:when test="${book.book_status == 'ING'}">
										<button type="submit" name="status" value="FINISH" class="btn-step btn-finish confirm-btn" data-payid="${book.pay_id}">
											<spring:message code="manage.btn.finish" text="Finish" />
										</button>
									</c:when>
									<c:otherwise>
										<span class="management-end"><spring:message code="manage.status.done" text="Done" /></span>
									</c:otherwise>
								</c:choose>
							</form>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>

<%-- 스크립트 설정 --%>
<script src="<c:url value='/resources/js/member_mypage.js'/>"></script>
<script src="<c:url value='/resources/js/manage.js'/>"></script>

<jsp:include page="../common/footer.jsp" />