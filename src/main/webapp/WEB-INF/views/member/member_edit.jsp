<%-- 
    [1] 페이지 설정 지시어
    - member 객체에는 컨트롤러에서 보낸 기존 회원 정보가 담겨 있어야 합니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<style>
    /* member.css가 적용되기 전 임시 스타일 (삭제 가능) */
    .msg-ok { color: green; font-size: 12px; font-weight: bold; }
    .msg-no { color: red; font-size: 12px; font-weight: bold; }
    table { margin-top: 20px; border-collapse: collapse; }
    td { padding: 10px; }
</style>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>

<script src="<c:url value='/resources/js/common.js'/>"></script>
<script src="<c:url value='/resources/js/address-api.js'/>"></script>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

</head>
<body>
    <h2 align="center">회원 정보 수정</h2>

    <%-- 
       [수정 포인트]
       1. action: <c:url> 사용으로 안전하게 처리
       2. id: 'joinForm'으로 변경 (외부 JS가 이 ID를 인식하여 자동 검증 수행)
    --%>
    <form action="<c:url value='/member/edit'/>" method="post" id="joinForm">

        <%-- CSRF 토큰 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <%-- 기존 좌표 데이터 유지 --%>
        <input type="hidden" name="user_lat" id="user_lat" value="${member.user_lat}">
        <input type="hidden" name="user_lon" id="user_lon" value="${member.user_lon}">

        <table border="1" align="center">
            <tr>
                <td width="120">아이디</td>
                <td>
                    <%-- 아이디는 수정 불가 (readonly) --%>
                    <input type="text" name="user_id" id="user_id" value="${member.user_id}" readonly>
                    <span style="color: gray; font-size: 12px;">(수정 불가)</span>
                    </td>
            </tr>
            <tr>
                <td>새 비밀번호</td>
                <td>
                    <input type="password" name="user_pw" id="user_pw" placeholder="변경 시에만 입력하세요">
                </td>
            </tr>
            <tr>
                <td>비밀번호 확인</td>
                <td>
                    <input type="password" id="user_pw_confirm" placeholder="비밀번호 재입력">
                    <div id="pwCheckMsg"></div>
                </td>
            </tr>
            <tr>
                <td>이름</td>
                <td><input type="text" name="user_nm" value="${member.user_nm}" required></td>
            </tr>
            <tr>
                <td>이메일</td>
                <td><input type="email" name="user_email" value="${member.user_email}"></td>
            </tr>
            <tr>
                <td>전화번호</td>
                <td>
                    <input type="text" name="user_tel" value="${member.user_tel}" required 
                           maxlength="13" oninput="autoHyphen(this)">
                </td>
            </tr>
            <tr>
                <td>주소</td>
                <td>
                    <input type="text" name="user_zip" id="user_zip" value="${member.user_zip}" placeholder="우편번호" readonly>
                    <button type="button" onclick="execDaumPostcode()">주소검색</button> <br>

                    <input type="text" name="user_addr1" id="user_addr1" value="${member.user_addr1}" 
                           placeholder="기본주소" size="40" readonly><br> 
                    <input type="text" name="user_addr2" id="user_addr2" value="${member.user_addr2}" placeholder="상세주소 입력">

                    <div id="coordStatus" style="color: blue; font-size: 12px; margin-top: 5px;">
                        주소를 변경하면 좌표가 자동으로 갱신됩니다.
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="수정완료"> 
                    <input type="button" value="취소" onclick="location.href='<c:url value='/member/mypage'/>'">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>