<%-- WEB-INF/views/common/header.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<c:set var="currentLang" value="${pageContext.response.locale.language}" />
<html lang="${currentLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="common.logo" text="Gourmet Pass" /></title>

    <meta name="app-context-path" content="${pageContext.request.contextPath}">
    <meta name="csrf-name" content="${_csrf.parameterName}">
    <meta name="csrf-token" content="${_csrf.token}">

    <link rel="stylesheet" href="<c:url value='/resources/css/common.css'/>">
    <%-- [Architect Note] 디자인 유지 및 경계선 두께 2px 고정 --%>
    <style>
        .wire-nav {
            border-bottom: 2px solid #333 !important; /* 경계선 두께 2px로 강화 및 색상 통일 */
            display: flow-root; /* 마진 상계 방지 (헤더 높이 흔들림 차단) */
            background: #fff;
            width: 100%;
        }
        .nav-inner {
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1200px;
            margin: 0 auto;
            width: 90%;
        }
        /* 로그아웃 버튼이 헤더 높이를 밀어내지 않도록 정렬 */
        .logout-form-inline { display: inline-flex; align-items: center; }
        .btn-logout-text { background: none; border: none; cursor: pointer; font-size: 15px; font-weight: 600; }
    </style>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="<c:url value='/resources/js/app-config.js'/>"></script>
    <script>
        window.APP_CONFIG = window.APP_CONFIG || {};
        window.APP_CONFIG.isOwner = false;
    </script>
    <sec:authorize access="hasRole('ROLE_OWNER')">
        <script>
            window.APP_CONFIG = window.APP_CONFIG || {};
            window.APP_CONFIG.isOwner = true;
        </script>
    </sec:authorize>
    
    <%-- [Font] Japanese header font (applied via common.css when lang=ja/jp) --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".lang-selector [data-lang]").forEach(function (link) {
                var lang = link.getAttribute("data-lang");
                if (!lang) {
                    return;
                }
                var url = new URL(window.location.href);
                url.searchParams.set("lang", lang);
                link.setAttribute("href", url.toString());
            });
        });
    </script>
</head>
<body>
<%--     Flash Message Alert 처리 추가
    <c:if test="${not empty msg}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                alert("${msg}");
            });
        </script>
    </c:if>
     --%>
    <nav class="wire-nav">
        <div class="nav-inner">
            <h2 class="logo-text">
                <a href="<c:url value='/'/>"><spring:message code="common.logo" text="GOURMET PASS" /></a>
            </h2>
            <div class="nav-links">
                <a href="<c:url value='/store/list'/>" class="nav-item">
                    <spring:message code="common.nav.search" text="Search" />
                </a>
                
                <sec:authorize access="isAnonymous()">
                    <span class="divider">|</span>
                    <a href="<c:url value='/member/login'/>" class="nav-item">
                        <spring:message code="common.nav.login" text="Login" />
                    </a>
                    <span class="divider">|</span>
                    <a href="<c:url value='/member/signup/select'/>" class="nav-item">
                        <spring:message code="common.nav.signup" text="Sign Up" />
                    </a>
                </sec:authorize>
                
                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal" var="user" />
                    <span class="divider">|</span>
                    <span class="user-welcome"><b>${user.username}</b><spring:message code="common.user.suffix" text="님" /></span>
                    
                    <sec:authorize access="hasRole('ROLE_OWNER')">
                        <a href="<c:url value='/member/mypage'/>" class="nav-item owner-link">
                            <spring:message code="common.nav.owner" text="[Owner]" />
                        </a>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')">
                        <a href="<c:url value='/member/mypage'/>" class="nav-item">
                            <spring:message code="common.nav.mypage" text="[My Page]" />
                        </a>
                    </sec:authorize>
                    
                    <form action="<c:url value='/logout'/>" method="post" class="logout-form-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn-logout-text" style="background:none; border:none; padding:0; font-family:inherit; color:#333;">
                            <spring:message code="common.nav.logout" text="Logout" />
                        </button>
                    </form>
                </sec:authorize>

                <span class="divider">|</span>
                <div class="lang-selector">
                    <a href="?lang=ko" data-lang="ko" class="lang-item ${pageContext.response.locale.language == 'ko' ? 'active-lang' : ''}">KO</a>
                    <span style="margin: 0 2px; color: #ccc;">/</span>
                    <a href="?lang=en" data-lang="en" class="lang-item ${pageContext.response.locale.language == 'en' ? 'active-lang' : ''}">EN</a>
                    <span style="margin: 0 2px; color: #ccc;">/</span>
                    <a href="?lang=jp" data-lang="jp" class="lang-item ${pageContext.response.locale.language == 'ja' || pageContext.response.locale.language == 'jp' ? 'active-lang' : ''}">JP</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="page-wrapper">
