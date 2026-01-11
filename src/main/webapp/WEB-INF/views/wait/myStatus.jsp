<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<%-- [1] 공통 헤더 포함 --%>
<jsp:include page="../common/header.jsp" />

<%-- [2] 공통 스타일 및 페이지 전용 스크립트 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}",
        // [추가] 실시간 수신용 데이터
        userId: "<sec:authentication property='principal.username'/>",
        role: "ROLE_USER"
    };

    // [추가] 페이지 로드 시 웹소켓 연결 시작
    document.addEventListener("DOMContentLoaded", function() {
        if(typeof initMyPageWebSocket === 'function') {
            initMyPageWebSocket(APP_CONFIG.userId, APP_CONFIG.role);
        }
    });

    // 웨이팅 취소 함수
    function cancelWait(waitId) {
        if(!confirm("웨이팅을 취소하시겠습니까?")) return;
        
        const form = document.createElement("form");
        form.method = "POST";
        form.action = APP_CONFIG.contextPath + "/wait/cancel";
        
        const inputId = document.createElement("input");
        inputId.type = "hidden";
        inputId.name = "wait_id";
        inputId.value = waitId;
        
        const inputCsrf = document.createElement("input");
        inputCsrf.type = "hidden";
        inputCsrf.name = APP_CONFIG.csrfName;
        inputCsrf.value = APP_CONFIG.csrfToken;
        
        form.appendChild(inputId);
        form.appendChild(inputCsrf);
        document.body.appendChild(form);
        form.submit();
    }
</script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div class="dashboard-container">
    <h2>📅 나의 이용현황</h2>
    <p>예약 및 실시간 웨이팅 내역을 확인하세요.</p>

    <div style="margin-top: 40px;">
        <h3 style="color: #2f855a; border-bottom: 2px solid #2f855a; padding-bottom: 10px;">🚶 실시간 웨이팅</h3>
        <table class="info-table">
            <thead>
                <tr>
                    <th>가게명</th>
                    <th>대기번호</th>
                    <th>인원</th>
                    <th>신청시간</th>
                    <th>상태</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty my_wait_list}">
                        <c:forEach var="wait" items="${my_wait_list}">
                            <tr>
                                <td><b>${wait.store_name}</b></td>
                                <td align="center"><span class="badge-cat" style="font-size: 16px;">${wait.wait_num}번</span></td>
                                <td align="center">${wait.people_cnt}명</td>
                                <td align="center">
                                    <fmt:formatDate value="${wait.wait_date}" pattern="yyyy-MM-dd HH:mm"/>
                                </td>
                                <td align="center">
                                    <c:choose>
                                        <c:when test="${wait.wait_status == 'WAITING'}"><span class="msg-ok">대기중</span></c:when>
                                        <c:when test="${wait.wait_status == 'CALLED'}"><span style="color: blue; font-weight: bold;">입장순서!</span></c:when>
                                        <c:otherwise>${wait.wait_status}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td align="center">
                                    <c:if test="${wait.wait_status == 'WAITING'}">
                                        <button type="button" class="btn-danger" onclick="cancelWait('${wait.wait_id}')">줄서기 취소</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" style="padding: 50px; text-align: center; color: #999;">현재 진행 중인 웨이팅이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <div style="margin-top: 60px; margin-bottom: 50px;">
        <h3 style="color: #e65100; border-bottom: 2px solid #e65100; padding-bottom: 10px;">📅 예약 내역</h3>
        <table class="info-table">
            <thead>
                <tr>
                    <th>가게명</th>
                    <th>예약일시</th>
                    <th>인원</th>
                    <th>상태</th>
                    <th>결제금액</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty my_book_list}">
                        <c:forEach var="book" items="${my_book_list}">
                            <tr>
                                <td><b>${book.store_name}</b></td>
                                <td align="center">
                                    <fmt:formatDate value="${book.book_date}" pattern="yyyy-MM-dd HH:mm"/>
                                </td>
                                <td align="center">${book.people_cnt}명</td>
                                <td align="center">
                                    <c:choose>
                                        <c:when test="${book.book_status == 'RESERVED'}"><span class="msg-ok">예약완료</span></c:when>
                                        <c:when test="${book.book_status == 'COMPLETED'}">방문완료</c:when>
                                        <c:when test="${book.book_status == 'CANCELLED'}"><span class="msg-no">취소됨</span></c:when>
                                        <c:otherwise>${book.book_status}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td align="right">
                                    <b><fmt:formatNumber value="${book.book_price}" pattern="#,###"/>원</b>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" style="padding: 50px; text-align: center; color: #999;">예약 내역이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />