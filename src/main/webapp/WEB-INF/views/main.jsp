<%-- WEB-INF/views/main.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%-- [필수] 다국어 처리를 위한 Spring 태그 라이브러리 --%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="common/header.jsp" />

<%-- 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/main.css'/>">

<div class="main-wrapper">
    <%-- 1. 검색 섹션 --%>
    <div class="search-card">
        <h1 class="search-title"><spring:message code="main.hero.title"/></h1>
        
        <form action="${pageContext.request.contextPath}/store/list" method="get" class="search-form">
            <%-- placeholder 속성 처리를 위한 변수 선언 --%>
            <spring:message code="main.search.placeholder" var="phText"/>
            
            <input type="text" name="keyword" class="search-input" placeholder="${phText}" required>
            <button type="submit" class="btn-search"><spring:message code="main.search.btn"/></button>
        </form>
    </div>

    <%-- 2. 카테고리 섹션: 동적 다국어 매핑 적용 --%>
    <div class="category-section">
        <div class="chip-group">
            <%-- 카테고리 값 자체(한식, 일식 등)는 DB 매핑을 위해 한글 원본 유지 --%>
            <c:set var="categories" value="한식,일식,양식,중식,카페" />
            <c:forEach var="cat" items="${fn:split(categories, ',')}">
                <%-- [수정] DB 데이터('한식')를 프로퍼티 키('category.Korean')로 매핑 --%>
                <c:choose>
                    <c:when test="${cat eq '한식'}"> <c:set var="catKey" value="category.Korean" /> </c:when>
                    <c:when test="${cat eq '일식'}"> <c:set var="catKey" value="category.Japanese" /> </c:when>
                    <c:when test="${cat eq '중식'}"> <c:set var="catKey" value="category.Chinese" /> </c:when>
                    <c:when test="${cat eq '양식'}"> <c:set var="catKey" value="category.Western" /> </c:when>
                    <c:when test="${cat eq '카페'}"> <c:set var="catKey" value="category.Cafe" /> </c:when>
                    <c:otherwise> <c:set var="catKey" value="category.Etc" /> </c:otherwise>
                </c:choose>

                <div class="cat-chip clickable" data-url="${pageContext.request.contextPath}/store/list?category=${cat}">
                    <%-- 매핑된 키(catKey)를 사용하여 다국어 텍스트 출력 --%>
                    <spring:message code="${catKey}" text="${cat}" />
                </div>
            </c:forEach>
            <div class="cat-chip btn-all clickable" data-url="${pageContext.request.contextPath}/store/list">
                <spring:message code="main.category.all"/>
            </div>
        </div>
    </div>

    <div class="main-divider"></div>

    <%-- 3. 실시간 인기 맛집 섹션 --%>
    <div class="popular-section">
        <h2 class="section-title"><spring:message code="main.section.popular"/></h2>

        <div class="store-grid">
            <c:choose>
                <c:when test="${not empty storeList}">
                    <c:forEach var="store" items="${storeList}">
                        <div class="store-card clickable" data-url="${pageContext.request.contextPath}/store/detail?storeId=${store.store_id}">
                            <div class="store-img-box">
                                <c:choose>
                                    <c:when test="${not empty store.store_img}">
                                        <img src="${pageContext.request.contextPath}/upload/${store.store_img}" alt="${store.store_name}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-img-placeholder">NO IMAGE</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="store-info">
                                <%-- [수정] 카드 내 카테고리 배지도 다국어 매핑 적용 --%>
                                <div class="badge-cat">
                                    <c:choose>
                                        <c:when test="${store.store_category eq '한식'}"> <c:set var="catKey" value="category.Korean" /> </c:when>
                                        <c:when test="${store.store_category eq '일식'}"> <c:set var="catKey" value="category.Japanese" /> </c:when>
                                        <c:when test="${store.store_category eq '중식'}"> <c:set var="catKey" value="category.Chinese" /> </c:when>
                                        <c:when test="${store.store_category eq '양식'}"> <c:set var="catKey" value="category.Western" /> </c:when>
                                        <c:when test="${store.store_category eq '카페'}"> <c:set var="catKey" value="category.Cafe" /> </c:when>
                                        <c:otherwise> <c:set var="catKey" value="category.Etc" /> </c:otherwise>
                                    </c:choose>
                                    <spring:message code="${catKey}" text="${store.store_category}" />
                                </div>
                                <div class="store-name-row">
                                    <h3 class="store-name">${store.store_name}</h3>
                                    <c:if test="${store.store_cnt >= 100}">
                                        <span class="hot-badge"><spring:message code="main.store.hot"/></span>
                                    </c:if>
                                </div>
                                <div class="store-addr-text">${store.store_addr1}</div>
                                <div class="store-stats">
                                    <span class="stat-rating">⭐ ${store.avg_rating} <small>(${store.review_cnt})</small></span>
                                    <span class="stat-views">👀 <spring:message code="main.store.views"/> ${store.store_cnt}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-status-box">
                        <spring:message code="main.list.empty"/>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%-- 공통 인터랙션 스크립트 --%>
<script src="<c:url value='/resources/js/main.js'/>"></script>
<jsp:include page="common/footer.jsp" />