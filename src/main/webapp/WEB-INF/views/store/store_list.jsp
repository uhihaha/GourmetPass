<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/store_list.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/main.css'/>">

<div class="list-wrapper">
    <%-- 검색 섹션 --%>
    <div class="search-card" style="margin-bottom: 30px;">
        <spring:message code="main.search.placeholder" var="phText" />
        <h1 class="search-title" style="font-size: 1.5rem;">
            <spring:message code="store.list.search.title" text="🔎 찾으시는 맛집이 있으신가요?" />
        </h1>
        <div class="search-form">
            <input type="text" id="visibleKeyword" class="wire-input" 
                   placeholder="${phText}" value="${keyword}">
            <button type="button" class="btn-search" onclick="syncAndSubmit()">
                <spring:message code="main.search.btn" text="맛집 검색" />
            </button>
        </div>
    </div>

    <%-- 1. 필터 섹션 --%>
    <div class="filter-card">
        <form id="filterForm" action="${pageContext.request.contextPath}/store/list" method="get">
            <%-- [수정] PageInfo(pageMaker)의 속성을 사용하여 상태 유지 --%>
            <input type="hidden" name="pageNum" id="pageNum" value="${pageMaker.pageNum}">
            <input type="hidden" name="pageSize" value="${pageMaker.pageSize}">
            <input type="hidden" name="category" id="selectedCategory" value="${category}">
            <input type="hidden" name="keyword" id="hiddenKeyword" value="${keyword}">

            <div class="filter-item">
                <label><spring:message code="store.list.filter.region" text="📍 지역 선택" /></label>
                <select name="region" onchange="resetPageAndSubmit()" class="wire-select" style="width:200px;">
                    <option value=""><spring:message code="region.all" text="전체 지역" /></option>
                    <option value="서울" ${region == '서울' ? 'selected' : ''}><spring:message code="region.Seoul" text="서울" /></option>
                    <option value="경기" ${region == '경기' ? 'selected' : ''}><spring:message code="region.Gyeonggi" text="경기" /></option>
                    <option value="인천" ${region == '인천' ? 'selected' : ''}><spring:message code="region.Incheon" text="인천" /></option>
                </select>
            </div>
            
            <div class="filter-item">
                <label><spring:message code="store.list.filter.cat" text="🍴 카테고리" /></label>
                <div class="chip-group">
                    <c:set var="cats" value="한식,일식,중식,양식,카페" />
                    <c:forEach var="cat" items="${fn:split(cats, ',')}">
                        <c:choose>
                            <c:when test="${cat eq '한식'}"><c:set var="catKey" value="category.Korean" /></c:when>
                            <c:when test="${cat eq '일식'}"><c:set var="catKey" value="category.Japanese" /></c:when>
                            <c:when test="${cat eq '중식'}"><c:set var="catKey" value="category.Chinese" /></c:when>
                            <c:when test="${cat eq '양식'}"><c:set var="catKey" value="category.Western" /></c:when>
                            <c:when test="${cat eq '카페'}"><c:set var="catKey" value="category.Cafe" /></c:when>
                            <c:otherwise><c:set var="catKey" value="category.Etc" /></c:otherwise>
                        </c:choose>
                        <div class="cat-chip ${category == cat ? 'active' : ''}" 
                             onclick="selectCategory('${cat}')">
                            <spring:message code="${catKey}" text="${cat}" />
                        </div>
                    </c:forEach>
                </div>
            </div>
        </form>
    </div>

    <%-- 2. 맛집 그리드 섹션 --%>
    <div class="store-grid">
        <c:choose>
            <c:when test="${not empty storeList}">
                <c:forEach var="store" items="${storeList}">
                    <div class="store-card" data-store-id="${store.store_id}" onclick="location.href='${pageContext.request.contextPath}/store/detail?storeId=${store.store_id}'">
                        <div class="store-img-box">
                            <c:choose>
                                <c:when test="${not empty store.store_img}">
                                    <img src="${pageContext.request.contextPath}/upload/${store.store_img}" class="store-thumb">
                                </c:when>
                                <c:otherwise>
                                    <div class="no-img-placeholder">NO IMAGE</div>
                                 </c:otherwise>
                            </c:choose>
                            <button type="button" class="favorite-toggle" data-store-id="${store.store_id}">🤍</button>
                        </div>
                        <div class="store-info">
                            <span class="badge-cat">
                                <c:choose>
                                    <c:when test="${store.store_category eq '한식'}"><c:set var="catKey" value="category.Korean" /></c:when>
                                    <c:when test="${store.store_category eq '일식'}"><c:set var="catKey" value="category.Japanese" /></c:when>
                                    <c:when test="${store.store_category eq '중식'}"><c:set var="catKey" value="category.Chinese" /></c:when>
                                    <c:when test="${store.store_category eq '양식'}"><c:set var="catKey" value="category.Western" /></c:when>
                                    <c:when test="${store.store_category eq '카페'}"><c:set var="catKey" value="category.Cafe" /></c:when>
                                    <c:otherwise><c:set var="catKey" value="category.Etc" /></c:otherwise>
                                </c:choose>
                                <spring:message code="${catKey}" text="${store.store_category}" />
                            </span>
                            <h3 class="store-name">${store.store_name}</h3>
                            <div class="store-meta">
                                <span class="rating">⭐ ${store.avg_rating}</span>
                                <span class="view-cnt"><spring:message code="store.list.grid.views" text="조회" /> ${store.store_cnt}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-status-box" style="grid-column: 1/-1; text-align: center; padding: 80px; font-weight: 800; border: 2px dashed #ccc; border-radius: 15px; color: #999;">
                    <spring:message code="store.list.empty" text="검색 결과와 일치하는 맛집이 없습니다." />
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 3. 페이징 섹션 (PageHelper PageInfo 기반으로 전면 수정) --%>
    <div class="pagination-container">
        <ul class="pagination">
            <%-- 이전 페이지 버튼 --%>
            <c:if test="${pageMaker.hasPreviousPage}">
                <li class="page-item">
                    <c:url var="prevUrl" value="/store/list">
                        <c:param name="pageNum" value="${pageMaker.prePage}" />
                        <c:param name="pageSize" value="${pageMaker.pageSize}" />
                        <c:param name="category" value="${category}" />
                        <c:param name="region" value="${region}" />
                        <c:param name="keyword" value="${keyword}" />
                    </c:url>
                     <a class="page-link" href="${prevUrl}" data-page="${pageMaker.prePage}">
                        <spring:message code="store.list.paging.prev" text="PREV" />
                     </a>
                </li>
            </c:if>

            <%-- 페이지 번호 목록 (PageInfo가 제공하는 navigatepageNums 사용) --%>
            <c:forEach var="num" items="${pageMaker.navigatepageNums}">
                <li class="page-item ${pageMaker.pageNum == num ? 'active' : ''}">
                    <c:url var="pageUrl" value="/store/list">
                        <c:param name="pageNum" value="${num}" />
                        <c:param name="pageSize" value="${pageMaker.pageSize}" />
                        <c:param name="category" value="${category}" />
                        <c:param name="region" value="${region}" />
                        <c:param name="keyword" value="${keyword}" />
                    </c:url>
                    <a class="page-link" href="${pageUrl}" data-page="${num}">${num}</a>
                </li>
            </c:forEach>

            <%-- 다음 페이지 버튼 --%>
             <c:if test="${pageMaker.hasNextPage}">
                <li class="page-item">
                    <c:url var="nextUrl" value="/store/list">
                        <c:param name="pageNum" value="${pageMaker.nextPage}" />
                        <c:param name="pageSize" value="${pageMaker.pageSize}" />
                        <c:param name="category" value="${category}" />
                        <c:param name="region" value="${region}" />
                        <c:param name="keyword" value="${keyword}" />
                    </c:url>
                    <a class="page-link" href="${nextUrl}" data-page="${pageMaker.nextPage}">
                        <spring:message code="store.list.paging.next" text="NEXT" />
                    </a>
                </li>
            </c:if>
        </ul>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/store_list.js"></script>
<jsp:include page="../common/footer.jsp" />
