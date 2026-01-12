<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../common/header.jsp" />

<%-- [v1.0.4] 외부 자산 로드 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<script src="<c:url value='/resources/js/common.js'/>"></script>
<script src="<c:url value='/resources/js/address-api.js'/>"></script>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<div class="edit-wrapper">
    <div class="edit-title">⚙️ 회원 정보 수정</div>

    <form action="<c:url value='/member/updateProcess'/>" method="post" id="joinForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="user_lat" id="user_lat" value="${member.user_lat}">
        <input type="hidden" name="user_lon" id="user_lon" value="${member.user_lon}">

        <table class="edit-table">
            <tr>
                <th>아이디</th>
                <td><input type="text" name="user_id" id="user_id" value="${member.user_id}" class="signup-input" readonly></td>
            </tr>
            <tr>
                <th>새 비밀번호</th>
                <td><input type="password" name="user_pw" id="user_pw" class="signup-input" placeholder="변경 시에만 입력하세요"></td>
            </tr>
            <tr>
                <th>비밀번호 확인</th>
                <td>
                    <input type="password" id="user_pw_confirm" class="signup-input" placeholder="비밀번호 재입력">
                    <div id="pwCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th>성명</th>
                <td><input type="text" name="user_nm" value="${member.user_nm}" class="signup-input" required></td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td><input type="text" name="user_tel" value="${member.user_tel}" class="signup-input" required oninput="autoHyphen(this)" maxlength="13"></td>
            </tr>
            <tr>
                <th>주소</th>
                <td>
                    <div class="input-row">
                        <input type="text" name="user_zip" id="user_zip" value="${member.user_zip}" class="signup-input" style="width: 120px; flex: none;" readonly>
                        <button type="button" onclick="execDaumPostcode('user')" class="btn-wire">주소검색</button>
                    </div>
                    <input type="text" name="user_addr1" id="user_addr1" value="${member.user_addr1}" class="signup-input" style="margin-top:8px;" readonly>
                    <input type="text" name="user_addr2" id="user_addr2" value="${member.user_addr2}" class="signup-input" style="margin-top:8px;">
                    <div id="coordStatus" class="msg-box" style="color: #2f855a; margin-top: 8px;">주소 변경 시 좌표가 자동 갱신됩니다.</div>
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit">정보 수정 완료</button>
            <a href="<c:url value='/member/mypage'/>" class="btn-cancel">취소</a>
        </div>
    </form>

    <div class="withdraw-section">
        <button type="button" class="btn-link-withdraw" onclick="dropUser('${member.user_id}')">회원 탈퇴하기</button>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />