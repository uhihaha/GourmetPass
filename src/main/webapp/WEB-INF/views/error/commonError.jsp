<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><spring:message code="error.common.title" text="GourmetPass - 오류 알림" /></title>
    <style>
        body { font-family: 'Malgun Gothic', dotum, sans-serif; background: #f8f9fa; margin: 0; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .wrap { max-width: 500px; width: 90%; background: #fff; border-radius: 16px; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); text-align: center; }
        .error-icon { font-size: 64px; margin-bottom: 20px; }
        h1 { margin: 0 0 15px; font-size: 28px; color: #333; }
        p { margin: 10px 0; color: #666; line-height: 1.6; }
        .meta { margin-top: 30px; padding: 20px; background: #f1f3f5; border-radius: 8px; color: #888; font-size: 13px; text-align: left; }
        .actions { margin-top: 30px; display: flex; gap: 10px; justify-content: center; }
        .btn { flex: 1; text-decoration: none; padding: 12px; border-radius: 8px; font-weight: bold; transition: 0.2s; }
        .btn-back { background: #e9ecef; color: #495057; }
        .btn-back:hover { background: #dee2e6; }
        .btn-home { background: #ff6b6b; color: #fff; } /* 브랜드 컬러 예시 */
        .btn-home:hover { background: #fa5252; }
    </style>
</head>
<body>
    <div class="wrap">
        <div class="error-icon">
            <c:choose>
                <c:when test="${code eq '404'}">🔍</c:when>
                <c:otherwise>⚠️</c:otherwise>
            </c:choose>
        </div>

        <h1>
            <c:choose>
                <c:when test="${code eq '404'}"><spring:message code="error.404.heading" text="페이지를 찾을 수 없습니다." /></c:when>
                <c:otherwise><spring:message code="common.serverError" text="처리 중 오류가 발생했습니다." /></c:otherwise>
            </c:choose>
        </h1>

        <p>
            <c:choose>
                <c:when test="${code eq '404'}">요청하신 페이지가 존재하지 않거나,<br>입력하신 주소가 정확한지 확인해주세요.</c:when>
                <c:otherwise>${msg}</c:otherwise>
            </c:choose>
        </p>

        <div class="actions">
            <a href="javascript:history.back()" class="btn btn-back">
                <spring:message code="mypage.historyCollapse" text="이전으로" />
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">
                <spring:message code="error.common.home" text="홈으로 이동" />
            </a>
        </div>

        <div class="meta">
            <strong>Log Information:</strong><br>
            • <spring:message code="error.common.status" text="상태 코드" />: <c:out value="${code}" /><br/>
            • <spring:message code="error.common.path" text="요청 경로" />: <c:out value="${uri}" />
        </div>
    </div>
</body>
</html>