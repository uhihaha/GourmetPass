<%-- 
    GourmetPass 프로젝트: 회원 정보 수정 페이지
    - MEMBERS 테이블 기반 데이터 바인딩
    - Spring Message Tag (text 속성) 적용으로 다국어 지원 및 500 에러 차단
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title">
        ⚙️ <spring:message code="member.edit.title" text="회원 정보 수정" />
    </div>

    <form action="<c:url value='/member/edit'/>" method="post" id="joinForm">
        <%-- CSRF 토큰 및 위치 정보 (MEMBERS 테이블 NUMBER(10, 7) 대응) --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="user_lat" id="user_lat" value="${member.user_lat}">
        <input type="hidden" name="user_lon" id="user_lon" value="${member.user_lon}">

        <table class="edit-table">
            <tr>
                <th><spring:message code="member.user_id" text="아이디" /></th>
                <td>
                    <%-- 아이디는 수정 불가하므로 readonly 유지 --%>
                    <input type="text" name="user_id" id="user_id" value="${member.user_id}" readonly>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.edit.pw_change" text="비밀번호 변경" /></th>
                <td>
                    <input type="password" name="user_pw" id="user_pw" 
                           placeholder="<spring:message code='member.placeholder.pw' text='변경 시에만 입력하세요' />">
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.user_pw_confirm" text="비밀번호 확인" /></th>
                <td>
                    <input type="password" id="user_pw_confirm" 
                           placeholder="<spring:message code='member.placeholder.pw_confirm' text='비밀번호를 한 번 더 입력하세요' />">
                    <div id="pwCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.user_nm" text="성명" /></th>
                <td>
                    <input type="text" name="user_nm" value="${member.user_nm}" required 
                           placeholder="<spring:message code='member.placeholder.name' text='성함을 입력하세요' />">
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.user_tel" text="전화번호" /></th>
                <td>
                    <input type="text" name="user_tel" value="${member.user_tel}" required 
                           oninput="autoHyphen(this)" maxlength="13" 
                           placeholder="<spring:message code='member.placeholder.tel' text='숫자만 입력' />">
                </td>
            </tr>

            <%-- 이메일 인증 섹션 --%>
            <tr>
                <th><spring:message code="member.user_email" text="이메일" /></th>
                <td>
                    <div class="input-row">
                        <input type="email" name="user_email" id="user_email" value="${member.user_email}" required placeholder="example@mail.com">
                        <button type="button" id="btnEmailAuth" class="btn-wire">
                            <spring:message code="member.btn.email_auth" text="인증코드 발송" />
                        </button>
                    </div>
                    <div id="emailMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.auth_code" text="인증코드" /></th>
                <td>
                    <div class="input-row">
                        <input type="text" id="auth_code" disabled maxlength="6"
                               placeholder="<spring:message code='member.placeholder.auth_code' text='인증코드 6자리' />">
                        <span id="timer" style="color:red; margin-left:10px; font-weight:bold;"></span>
                    </div>
                    <div id="authMsg" class="msg-box"></div>
                </td>
            </tr>

            <%-- 주소 정보 수정 --%>
            <tr>
                <th><spring:message code="member.user_addr" text="주소" /></th>
                <td>
                    <div class="input-row mb-10">
                        <input type="text" name="user_zip" id="user_zip" value="${member.user_zip}" 
                               style="width: 120px; flex: none;" readonly 
                               placeholder="<spring:message code='member.zip_code' text='우편번호' />">
                        <button type="button" onclick="execDaumPostcode('user')" class="btn-wire">
                            <spring:message code="member.btn.addr_search" text="주소검색" />
                        </button>
                    </div>
                    <input type="text" name="user_addr1" id="user_addr1" value="${member.user_addr1}" 
                           class="mb-10" readonly placeholder="<spring:message code='member.addr1' text='기본주소' />">
                    <input type="text" name="user_addr2" id="user_addr2" value="${member.user_addr2}" 
                           placeholder="<spring:message code='member.placeholder.addr2' text='상세 주소를 입력하세요' />">
                    <div id="coordStatus" class="msg-box msg-ok">
                        <spring:message code="member.msg.coord_auto" text="주소 변경 시 위치 정보가 자동으로 갱신됩니다." />
                    </div>
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit">
                <spring:message code="member.btn.update" text="정보 수정 완료" />
            </button>
            <a href="<c:url value='/member/mypage'/>" class="btn-cancel">
                <spring:message code="common.btn.cancel" text="취소" />
            </a>
        </div>
    </form>

    <div class="withdraw-section">
        <button type="button" class="btn-link-withdraw" onclick="dropUser('${member.user_id}')">
            <spring:message code="member.btn.withdraw" text="회원 탈퇴하기" />
        </button>
    </div>
</div>

<%-- API 및 공통 스크립트 --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<c:url value='/resources/js/address-api.js'/>"></script>
<script src="<c:url value='/resources/js/common.js'/>"></script>

<script type="text/javascript">
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>

<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

<jsp:include page="../common/footer.jsp" />