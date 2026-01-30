<%-- 
    GourmetPass 프로젝트: 일반 회원가입 페이지
    - MEMBERS 테이블 스키마 기반 필드 구성
    - Spring Security CSRF 보호 및 i18n 적용 (default -> text 속성 수정 완료)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title">
        👤 <spring:message code="member.signup.general.title" text="일반 회원가입" />
    </div>

    <%-- 회원가입 처리 컨트롤러 경로: /member/joinProcess --%>
    <form action="${pageContext.request.contextPath}/member/joinProcess" method="post" id="joinForm">
        <%-- CSRF 보안 및 좌표 저장용 숨김 필드 (schema.sql의 NUMBER(10,7) 타입 대응) --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="user_lat" id="user_lat" value="0.0">
        <input type="hidden" name="user_lon" id="user_lon" value="0.0">
        <%-- 일반 회원 권한 강제 설정 --%>
        <input type="hidden" name="user_role" value="ROLE_USER">

        <table class="edit-table">
            <%-- [1] 아이디 섹션 --%>
            <tr>
                <th><spring:message code="member.user_id" text="아이디" /></th>
                <td>
                    <div class="input-row">
                        <input type="text" name="user_id" id="user_id" required 
                               placeholder="<spring:message code='member.placeholder.id_min' text='3글자 이상 입력' />">
                        <button type="button" id="btnIdCheck" class="btn-wire">
                            <spring:message code="member.btn.id_check" text="중복확인" />
                        </button>
                    </div>
                    <div id="idCheckMsg" class="msg-box"></div>
                </td>
            </tr>

            <%-- [2] 비밀번호 섹션 --%>
            <tr>
                <th><spring:message code="member.user_pw" text="비밀번호" /></th>
                <td>
                    <input type="password" name="user_pw" id="user_pw" required 
                           placeholder="<spring:message code='member.placeholder.pw' text='비밀번호 입력' />">
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.user_pw_confirm" text="비밀번호 확인" /></th>
                <td>
                    <input type="password" id="user_pw_confirm" required 
                           placeholder="<spring:message code='member.placeholder.pw_confirm' text='비밀번호 재입력' />">
                    <div id="pwCheckMsg" class="msg-box"></div>
                </td>
            </tr>

            <%-- [3] 기본 인적 사항 --%>
            <tr>
                <th><spring:message code="member.user_nm" text="이름" /></th>
                <td>
                    <input type="text" name="user_nm" required 
                           placeholder="<spring:message code='member.placeholder.name' text='성함을 입력하세요' />">
                </td>
            </tr>
            <tr>
                <th><spring:message code="member.user_tel" text="전화번호" /></th>
                <td>
                    <input type="text" name="user_tel" required maxlength="13" oninput="autoHyphen(this)"
                           placeholder="<spring:message code='member.placeholder.tel' text='숫자만 입력' />">
                </td>
            </tr>
            
            <%-- [4] 이메일 인증 섹션 --%>
            <tr>
                <th><spring:message code="member.user_email" text="이메일" /></th>
                <td>
                    <div class="input-row">
                        <input type="email" name="user_email" id="user_email" required placeholder="example@mail.com">
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

            <%-- [5] 주소 및 위치 정보 (Daum/Kakao API 연동) --%>
            <tr>
                <th><spring:message code="member.user_addr" text="주소" /></th>
                <td>
                    <div class="input-row mb-10">
                        <input type="text" name="user_zip" id="user_zip" style="width: 120px; flex: none;" 
                               placeholder="<spring:message code='member.zip_code' text='우편번호' />" readonly>
                        <button type="button" onclick="execDaumPostcode('user')" class="btn-wire">
                            <spring:message code="member.btn.addr_search" text="주소검색" />
                        </button>
                    </div>
                    <input type="text" name="user_addr1" id="user_addr1" class="mb-10" 
                           placeholder="<spring:message code='member.addr1' text='기본주소' />" readonly>
                    <input type="text" name="user_addr2" id="user_addr2" 
                           placeholder="<spring:message code='member.placeholder.addr2' text='상세주소' />">
                    <div id="coordStatus" class="msg-box msg-ok">
                        <spring:message code="member.msg.coord_auto" text="주소 검색 시 좌표가 자동 설정됩니다." />
                    </div>
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit" id="btnSubmit">
                <spring:message code="member.btn.signup" text="가입하기" />
            </button>
            <a href="${pageContext.request.contextPath}/" class="btn-cancel">
                <spring:message code="common.btn.cancel" text="취소" />
            </a>
        </div>
    </form>
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

<%-- 통합 가입 로직 --%>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

<jsp:include page="../common/footer.jsp" />