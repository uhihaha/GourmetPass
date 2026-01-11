<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}",
        // 점주 알림 수신을 위한 데이터
        role: "ROLE_OWNER",
        storeId: "${store.store_id}"
    };

    // 페이지 로드 시 웹소켓 연결 시작 (member-mypage.js에 정의된 함수 호출)
    document.addEventListener("DOMContentLoaded", function() {
        if(typeof initMyPageWebSocket === 'function') {
            initMyPageWebSocket(null, APP_CONFIG.role, APP_CONFIG.storeId);
        }
    });
</script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<h2>⚙️ 실시간 매장 관리</h2>

<div class="dashboard-container">
    <h3 style="color: #2f855a;">🚶 웨이팅 현황</h3>
    <table class="info-table">
        <thead>
            <tr><th>번호</th><th>고객</th><th>인원</th><th>상태</th><th>관리</th></tr>
        </thead>
        <tbody>
            <c:forEach var="wait" items="${store_wait_list}">
                <tr>
                    <td align="center">${wait.wait_num}</td>
                    <td>${wait.user_id}</td>
                    <td align="center">${wait.people_cnt}명</td>
                    <td align="center">${wait.wait_status}</td>
                    <td align="center">
                        <form action="<c:url value='/wait/updateStatus'/>" method="post">
                            <input type="hidden" name="wait_id" value="${wait.wait_id}">
                            <input type="hidden" name="user_id" value="${wait.user_id}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <select name="status">
                                <option value="CALLED">호출</option>
                                <option value="COMPLETED">입장</option>
                                <option value="CANCELLED">취소</option>
                            </select>
                            <button type="submit" class="btn-primary">변경</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <h3 style="color: #e65100; margin-top: 50px;">📅 오늘 예약</h3>
    <table class="info-table">
        <thead>
            <tr><th>시간</th><th>고객</th><th>인원</th><th>상태</th><th>관리</th></tr>
        </thead>
        <tbody>
            <c:forEach var="book" items="${store_book_list}">
                <tr>
                    <td align="center"><fmt:formatDate value="${book.book_date}" pattern="HH:mm"/></td>
                    <td>${book.user_id}</td>
                    <td align="center">${book.people_cnt}명</td>
                    <td align="center">${book.book_status}</td>
                    <td align="center">
                        <form action="<c:url value='/book/updateStatus'/>" method="post">
                            <input type="hidden" name="book_id" value="${book.book_id}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button name="status" value="COMPLETED" class="btn-success">방문</button>
                            <button name="status" value="NOSHOW" class="btn-danger">노쇼</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="../common/footer.jsp" />