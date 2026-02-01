<%-- 
    GourmetPass 프로젝트: 매장 정보 수정 페이지
    - STORE 테이블 스키마 기반 데이터 바인딩
    - Spring Message Tag (text 속성) 적용으로 다국어 지원 및 500 에러 방지
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- 고메패스 통합 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title">
        🛠️ <spring:message code="store.update.title" text="가게 정보 수정" />
    </div>
    
    <%-- 
        [기능 보존] 
        Multipart 요청 시 CSRF 필터 대응을 위해 Action URL에 토큰을 포함합니다.
    --%>
    <form action="${pageContext.request.contextPath}/store/update?${_csrf.parameterName}=${_csrf.token}" 
          method="post" enctype="multipart/form-data">
        
        <%-- CSRF 보호 및 상위 식별자 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="store_id" value="${store.store_id}">

        <table class="edit-table">
            <%-- 가게 이름 수정 --%>
            <tr>
                <th><spring:message code="store.label.name" text="가게 이름" /></th>
                <td>
                    <input type="text" name="store_name" value="${store.store_name}" 
                           class="login-input" required>
                </td>
            </tr>
            <%-- 가게 전화번호 수정 --%>
            <tr>
                <th><spring:message code="store.label.tel" text="전화번호" /></th>
                <td>
                    <input type="text" name="store_tel" value="${store.store_tel}" 
                           class="login-input" oninput="autoHyphen(this)" maxlength="13">
                </td>
            </tr>
            <%-- 가게 위치 및 주소 검색 (Daum API 연동) --%>
            <tr>
                <th><spring:message code="store.label.addr" text="가게 위치" /></th>
                <td>
                    <div class="input-row mb-10">
                        <input type="text" name="store_zip" id="store_zip" value="${store.store_zip}" 
                               style="width: 120px;" readonly class="login-input"
                               placeholder="<spring:message code='member.zip_code' text='우편번호' />">
                        <button type="button" onclick="execDaumPostcode('store')" class="btn-wire">
                            <spring:message code="member.btn.addr_search" text="위치 변경" />
                        </button>
                    </div>
                    <input type="text" name="store_addr1" id="store_addr1" value="${store.store_addr1}" 
                           class="login-input mb-10" readonly 
                           placeholder="<spring:message code='member.addr1' text='기본 주소' />">
                    <input type="text" name="store_addr2" id="store_addr2" value="${store.store_addr2}" 
                           class="login-input" placeholder="<spring:message code='member.placeholder.addr2' text='상세주소' />">
                </td>
            </tr>
            <%-- 영업 시간 수정 (Time 타입 대응) --%>
            <tr>
                <th><spring:message code="store.label.hours" text="영업 시간" /></th>
                <td>
                    <div class="input-row">
                        <input type="time" name="open_time" value="${store.open_time}" class="login-input" style="flex:1;">
                        <span style="padding:10px; font-weight:900;">~</span>
                        <input type="time" name="close_time" value="${store.close_time}" class="login-input" style="flex:1;">
                    </div>
                </td>
            </tr>
        </table>

        <%-- 하단 버튼 그룹 --%>
        <div class="btn-group">
            <button type="submit" class="btn-submit">
                <spring:message code="common.btn.update" text="정보 수정 완료" />
            </button>
            <button type="button" class="btn-cancel" onclick="history.back()">
                <spring:message code="common.btn.cancel" text="취소" />
            </button>
        </div>
    </form>
</div>

<%-- API 및 공통 스크립트 연동 --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<c:url value='/resources/js/address-api.js'/>"></script>
<script src="<c:url value='/resources/js/common.js'/>"></script>

<jsp:include page="../common/footer.jsp" />