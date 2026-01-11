<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}",
        // 웹소켓 초기화용 데이터 추가
        userId: "${member.user_id}",
        role: "ROLE_USER"
    };

    // 페이지 로드 시 웹소켓 연결 시작
    document.addEventListener("DOMContentLoaded", function() {
        if(typeof initMyPageWebSocket === 'function') {
            initMyPageWebSocket(APP_CONFIG.userId, APP_CONFIG.role);
        }
    });
</script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div style="width: 80%; margin: 0 auto; padding: 40px 0; text-align: center;">
    <div class="dashboard-container" style="text-align: left;">
        <h2>👤 마이페이지 (일반 회원)</h2>
        <p>반갑습니다, <b>${member.user_nm}</b>님! 고메패스 회원입니다.</p>

        <table class="info-table" style="width: 100%; margin-top: 20px;">
            <tr>
                <th style="width: 20%;">아이디</th>
                <td>${member.user_id}</td>
            </tr>
            <tr>
                <th>이름</th>
                <td>${member.user_nm}</td>
            </tr>
            <tr>
                <th>연락처</th>
                <td>${member.user_tel}</td>
            </tr>
        </table>

        <div style="text-align: right; margin-top: 15px;">
            <button class="btn-action" onclick="location.href='<c:url value='/member/edit'/>'">
                정보 수정
            </button>
        </div>

        <hr style="margin: 40px 0; border: 0; border-top: 1px solid #eee;">

        <table style="width: 100%; border: none; border-collapse: separate; border-spacing: 15px 0;">
            <tr>
                <td style="width: 50%; padding: 25px; border: 1px solid #ddd; text-align: center; border-radius: 10px;">
                    <a href="<c:url value='/wait/myStatus'/>" style="text-decoration: none; color: black; font-weight: bold; font-size: 18px;">
                        📅 내 예약·웨이팅 확인
                    </a>
                </td>
                <td style="padding: 25px; border: 1px solid #ddd; text-align: center; border-radius: 10px;">
                    <form action="<c:url value='/logout'/>" method="post" style="margin: 0;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn-link-logout" style="font-size: 18px;">🚪 로그아웃</button>
                    </form>
                </td>
            </tr>
        </table>

        <div style="margin-top: 60px; text-align: right;">
            <button type="button" class="btn-link-withdraw" onclick="dropUser('${member.user_id}')">
                회원 탈퇴 신청
            </button>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />