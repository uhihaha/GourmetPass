<%-- 
    GourmetPass 프로젝트: 메뉴 정보 수정 페이지
    - 기존 MENU 데이터를 기반으로 수정 폼을 구성합니다.
    - Spring Message Tag (text 속성) 적용으로 다국어 지원 및 500 에러 차단
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<%-- 통합 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title">
        ✏️ <spring:message code="menu.update.title" text="Update Menu" />
    </div>
    
    <%-- 
        [기능 보존] 
        Multipart 요청 시 CSRF 필터 대응을 위해 Action URL에 토큰을 포함합니다.
    --%>
    <form action="${pageContext.request.contextPath}/store/menu/update?${_csrf.parameterName}=${_csrf.token}" 
          method="post" 
          enctype="multipart/form-data">
          
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        
        <%-- 기존 데이터 식별 및 유지용 숨김 필드 --%>
        <input type="hidden" name="menu_id" value="${menu.menu_id}">
        <input type="hidden" name="store_id" value="${menu.store_id}">
        <%-- 이미지 미변경 시 기존 경로 유지를 위한 필드 --%>
        <input type="hidden" name="menu_img" value="${menu.menu_img}"> 
        
        <table class="edit-table">
            <%-- 메뉴명 수정 --%>
            <tr>
                <th><spring:message code="menu.label.name" text="Name" /></th>
                <td>
                    <input type="text" name="menu_name" value="${menu.menu_name}" 
                           class="login-input" required 
                           placeholder="<spring:message code='menu.placeholder.name' text='e.g. Ribeye' />">
                </td>
            </tr>
            <%-- 가격 수정 --%>
            <tr>
                <th><spring:message code="menu.label.price" text="Price" /></th>
                <td>
                    <input type="number" name="menu_price" value="${menu.menu_price}" 
                           class="login-input" required 
                           placeholder="<spring:message code='menu.placeholder.price' text='Amount' />">
                </td>
            </tr>
            <%-- 메뉴 이미지 수정 --%>
            <tr>
                <th><spring:message code="menu.label.image" text="Image" /></th>
                <td>
                    <c:if test="${not empty menu.menu_img}">
                        <div style="margin-bottom: 15px;">
                            <img src="${pageContext.request.contextPath}/upload/${menu.menu_img}" 
                                 width="120" style="border: 2px solid #333; border-radius: 10px;">
                        </div>
                    </c:if>
                    <input type="file" name="file" class="login-input" style="padding-top: 10px;">
                    <div class="msg-box" style="color: #888;">
                        <spring:message code="menu.msg.file_update_info" text="Select only to replace." />
                    </div>
                </td>
            </tr>
            <%-- 대표메뉴 여부 (menu_sign: 'Y' or 'N') --%>
            <tr>
                <th><spring:message code="menu.label.signature" text="Signature" /></th>
                <td>
                    <div style="display: flex; align-items: center; gap: 10px; height: 50px;">
                        <input type="checkbox" name="menu_sign" value="Y" 
                               ${menu.menu_sign == 'Y' ? 'checked' : ''} 
                               style="width: 20px; height: 20px; cursor: pointer;">
                        <span style="font-weight: 800; font-size: 14px;">
                            <%-- [수정] 누락된 키 적용 --%>
                            <spring:message code="menu.label.signature.desc" text="Set as Signature Menu" />
                        </span>
                    </div>
                </td>
            </tr>
        </table>
        
        <%-- 하단 버튼 그룹 --%>
        <div class="btn-group">
            <button type="submit" class="btn-submit">
                <spring:message code="common.btn.update" text="Update" />
            </button>
            <button type="button" class="btn-cancel" onclick="history.back()">
                <spring:message code="common.btn.cancel" text="Cancel" />
            </button>
        </div>
    </form>
</div>

<jsp:include page="../common/footer.jsp" />