<%-- 
    GourmetPass 프로젝트: 메뉴 등록 페이지
    - MENU 테이블 스키마 기반 필드 구성
    - Spring Message Tag (text 속성) 적용으로 500 에러 차단 및 다국어 지원
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- [원칙 1] 고메패스 통합 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title">
        ➕ <spring:message code="menu.register.title" text="Register Menu" />
    </div>

    <%-- 
        [기능 보존] 
        Multipart 요청 시 CSRF 필터가 Body 파라미터를 읽지 못할 수 있으므로, 
        Action URL에 직접 토큰을 포함하는 아키텍처 관례를 유지합니다.
    --%>
    <form action="${pageContext.request.contextPath}/store/menu/register?${_csrf.parameterName}=${_csrf.token}"
          method="post"
          enctype="multipart/form-data">

        <%-- CSRF 토큰 및 상위 스토어 ID 유지 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="store_id" value="${param.store_id}">

        <%-- [교정] 표준 edit-table 구조 적용 --%>
        <table class="edit-table">
            <%-- 메뉴명 입력 --%>
            <tr>
                <th><spring:message code="menu.label.name" text="Name" /></th>
                <td>
                    <input type="text" name="menu_name" class="login-input" 
                           required placeholder="<spring:message code='menu.placeholder.name' text='e.g. Ribeye' />">
                </td>
            </tr>
            <%-- 가격 입력 (MENU_PRICE: NUMBER 대응) --%>
            <tr>
                <th><spring:message code="menu.label.price" text="Price" /></th>
                <td>
                    <input type="number" name="menu_price" class="login-input" 
                           required placeholder="<spring:message code='menu.placeholder.price' text='Amount' />">
                </td>
            </tr>
            <%-- 메뉴 이미지 (MultipartFile) --%>
            <tr>
                <th><spring:message code="menu.label.image" text="Image" /></th>
                <td>
                    <input type="file" name="file" class="login-input" 
                           style="padding-top: 10px;">
                </td>
            </tr>
            <%-- 대표 메뉴 설정 (MENU_SIGN: CHAR(1) 'Y'/'N') --%>
            <tr>
                <th><spring:message code="menu.label.signature" text="Signature" /></th>
                <td>
                    <div style="display: flex; align-items: center; gap: 10px; height: 50px;">
                        <input type="checkbox" name="menu_sign" value="Y" 
                               style="width: 20px; height: 20px; cursor: pointer;">
                        <span style="font-weight: 800; font-size: 14px;">
                            <%-- [수정] 누락된 키 적용 --%>
                            <spring:message code="menu.label.signature.desc" text="Set as Signature Menu" />
                        </span>
                    </div>
                </td>
            </tr>
        </table>

        <%-- [교정] 하단 버튼 그룹: i18n 적용 및 표준 디자인 --%>
        <div class="btn-group">
            <button type="submit" class="btn-submit">
                <spring:message code="menu.btn.register" text="Add Menu" />
            </button>
            <button type="button" class="btn-cancel" onclick="history.back()">
                <spring:message code="common.btn.cancel" text="Cancel" />
            </button>
        </div>
    </form>
</div>

<jsp:include page="../common/footer.jsp" />