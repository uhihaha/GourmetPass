<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<%-- 외부 스타일 시트로 완전 분리 [manage.css] --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/manage.css'/>">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<div class="edit-wrapper" style="max-width: 1100px; margin: 40px auto;">

	<spring:message code="manage.status.reserved" text="예약확정" var="manageStatusReserved" />
	<spring:message code="manage.status.ing" text="식사중" var="manageStatusIng" />
	<div class="edit-title"><spring:message code="manage.title" text="⚙️ 실시간 매장 관리 센터" /></div>

	<%-- 1. 실시간 웨이팅 섹션 --%>
	<div class="dashboard-card">
		<%-- 실제 입장 대기 중인(WAITING, CALLED) 팀만 합산 --%>
		<c:set var="realWaitCount" value="0" />
		<c:forEach var="w" items="${store_wait_list}">
			<c:if
				test="${w.wait_status == 'WAITING' or w.wait_status == 'CALLED'}">
				<c:set var="realWaitCount" value="${realWaitCount + 1}" />
			</c:if>
		</c:forEach>

		<div class="card-header-flex">
			<h3 class="card-title-wait"><spring:message code="manage.wait.title" text="🚶 실시간 웨이팅 현황" /></h3>
			<span class="badge-wire"><spring:message code="manage.wait.count" arguments="${realWaitCount}" text="입장 대기 {0}팀" /></span>
		</div>

		<div class="table-scroll">
			<table class="manage-dashboard-table">
				<thead>
					<tr>
						<th class="col-num"><spring:message code="manage.col.num" text="번호" /></th>
						<th class="col-userid"><spring:message code="manage.col.userid" text="고객ID" /></th>
						<th class="col-people"><spring:message code="manage.col.people" text="인원" /></th>
						<th class="col-status"><spring:message code="manage.col.status" text="상태" /></th>
						<th class="col-action"><spring:message code="manage.col.action" text="상태 제어" /></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="wait" items="${store_wait_list}">
						<%-- 관리 종료된 건은 제외하고 노출 --%>
						<c:if
							test="${wait.wait_status != 'FINISH' and wait.wait_status != 'CANCELLED'}">
							<tr>
								<td align="center"><b>${wait.wait_num}</b></td>
								<td align="center">${wait.user_id}</td>
								<td align="center"><spring:message code="store.form.unit.person" arguments="${wait.people_cnt}" text="{0}명" /></td>
								<td align="center"><c:choose>
										<c:when test="${wait.wait_status == 'WAITING'}">
											<span class="badge-wire"><spring:message code="manage.status.waiting" text="대기중" /></span>
										</c:when>
										<c:when test="${wait.wait_status == 'CALLED'}">
											<span class="badge-wire badge-called"><spring:message code="manage.status.called" text="호출중" /></span>
										</c:when>
										<c:when test="${wait.wait_status == 'ING'}">
											<span class="badge-wire badge-ing"><spring:message code="manage.status.ing" text="식사중" /></span>
										</c:when>
									</c:choose></td>
								<td align="center">
									<form action="<c:url value='/wait/updateStatus'/>" method="post" class="action-btn-group">
										<input type="hidden" name="wait_id" value="${wait.wait_id}">
										<input type="hidden" name="user_id" value="${wait.user_id}">
										<input type="hidden" name="${_csrf.parameterName}"
											value="${_csrf.token}" />

										<c:choose>
											<c:when test="${wait.wait_status == 'WAITING'}">
												<button type="submit" name="status" value="CALLED"
													class="btn-step btn-step-primary"><spring:message code="manage.btn.call" text="지금 호출하기" /></button>
												<button type="submit" name="status" value="CANCELLED"
													class="btn-step btn-step-danger"><spring:message code="common.btn.cancel" text="취소" /></button>
											</c:when>
											<c:when test="${wait.wait_status == 'CALLED'}">
												<button type="submit" name="status" value="ING"
													class="btn-step btn-step-next"><spring:message code="manage.btn.entry" text="입장 확인" /></button>
												<button type="submit" name="status" value="CANCELLED"
													class="btn-step btn-step-danger"><spring:message code="manage.btn.noshow" text="노쇼 처리" /></button>
											</c:when>
											<c:when test="${wait.wait_status == 'ING'}">
												<button type="submit" name="status" value="FINISH"
													class="btn-step btn-finish"><spring:message code="manage.btn.finish" text="식사 확인" /></button>
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
	</div>

	<%-- 2. 오늘 예약 섹션 --%>
	<div class="dashboard-card">
		<div class="card-header-flex">
			<h3 class="card-title-book"><spring:message code="manage.book.title" text="📅 오늘 예약 현황" /></h3>
			<span class="badge-wire"><spring:message code="manage.book.total" arguments="${store_book_list.size()}" text="총 {0}건" /></span>
		</div>
		
		<%-- 3. 날짜 선택 필터 --%>
	    <div class="date-filter">
	        <h3 style="margin: 0 0 15px 0; font-size: 18px;"><spring:message code="manage.filter.title" text="📆 날짜별 예약 조회" /></h3>
	        <form action="<c:url value='/book/manage'/>" method="get">
	            <div class="date-filter-container">
	                <label for="book_date" style="font-weight: 800;"><spring:message code="manage.filter.date" text="예약 날짜:" /></label>
	                <input type="date" 
	                       id="book_date" 
	                       name="book_date" 
	                       value="${selected_date}"
	                       max="2099-12-31">
	                <button type="submit" class="btn-filter"><spring:message code="manage.filter.search" text="조회" /></button>
	            </div>
	        </form>
	        <c:if test="${not empty selected_date}">
	            <p style="margin: 10px 0 0 0; color: #666; font-size: 14px;">
	                <spring:message code="manage.filter.selected" arguments="${selected_date}" text="{0} 예약 현황" />
	            </p>
	        </c:if>
	    </div>
		
		<div class="table-scroll">
			<table class="manage-dashboard-table">
				<thead>
					<tr>
						<th class="col-num"><spring:message code="manage.col.time" text="시간" /></th>
						<th class="col-userid"><spring:message code="manage.col.userid" text="고객ID" /></th>
						<th class="col-people"><spring:message code="manage.col.people" text="인원" /></th>
						<th class="col-status"><spring:message code="manage.col.status" text="상태" /></th>
						<th class="col-action"><spring:message code="manage.col.action" text="상태 제어" /></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="book" items="${store_book_list}">
						<tr>
							<td align="center"><b><fmt:formatDate
										value="${book.book_date}" pattern="HH:mm" /></b></td>
							<td align="center">${book.user_id}</td>
							<td align="center"><spring:message code="store.form.unit.person" arguments="${book.people_cnt}" text="{0}명" /></td>
							<td align="center"><span
								class="badge-wire ${book.book_status == 'ING' ? 'badge-ing' : ''}">
									${book.book_status == 'RESERVED' ? manageStatusReserved : (book.book_status == 'ING' ? manageStatusIng : book.book_status)}
							</span></td>
							<td align="center">
								<form action="<c:url value='/book/updateStatus'/>" method="post"
									class="action-btn-group">
									<input type="hidden" name="book_id" value="${book.book_id}">
									<input type="hidden" name="user_id" value="${book.user_id}">
									<input type="hidden" name="${_csrf.parameterName}"
										value="${_csrf.token}" />

									<c:choose>
										<c:when test="${book.book_status == 'RESERVED'}">
											<button type="submit" name="status" value="ING"
												class="btn-step btn-step-next"><spring:message code="manage.btn.entry" text="입장 확인" /></button>
											<!-- 노쇼 버튼에 pay_id를 넣어 환불기능을 하기 위해 javascript에 보냄 -->
											<button type="button" name="status" value="NOSHOW"
												class="btn-step btn-step-danger noshow-btn" data-payid="${book.pay_id}"><spring:message code="manage.btn.noshow" text="노쇼 처리" /></button>
										</c:when>
										<c:when test="${book.book_status == 'ING'}">
											<button type="submit" name="status" value="FINISH"
												class="btn-step btn-finish confirm-btn" data-payid="${book.pay_id}"><spring:message code="manage.btn.finish" text="식사 확인" /></button>
										</c:when>
										<c:otherwise>
											<span class="management-end"><spring:message code="manage.status.done" text="관리 종료" /></span>
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
</div>

<%-- 스크립트 및 WebSocket 설정 --%>
<script>
    if (typeof APP_CONFIG !== "undefined") {
        APP_CONFIG.storeId = "${store.store_id}";
    }
</script>
<script src="<c:url value='/resources/js/member_mypage.js'/>"></script>
<script src="<c:url value='/resources/js/manage.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
