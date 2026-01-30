<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/store_list.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="list-wrapper">
    <%-- 1. 필터 섹션 --%>
    <div class="filter-card">
        <form id="filterForm" action="${pageContext.request.contextPath}/store/list" method="get">
            <input type="hidden" name="pageNum" id="pageNum" value="${pageMaker.cri.pageNum}">
            <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
            <input type="hidden" name="category" id="selectedCategory" value="${category}">
            <input type="hidden" name="keyword" value="${keyword}">

            <div class="filter-item">
                <label><spring:message code="store.list.filter.region" /></label>
                <select name="region" onchange="resetPageAndSubmit()" class="wire-select" style="width:200px;">
                    <option value=""><spring:message code="region.all" /></option>
                    <c:forEach var="reg" items="${fn:split('서울,경기,인천', ',')}">
                        <option value="${reg}" ${region == reg ? 'selected' : ''}>
                            <spring:message code="region.${reg}" text="${reg}" />
                        </option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="filter-item">
                <label><spring:message code="store.list.filter.cat" /></label>
                <div class="chip-group">
                    <c:set var="cats" value="한식,일식,중식,양식,카페" />
                    <c:forEach var="cat" items="${fn:split(cats, ',')}">
                        <div class="cat-chip ${category == cat ? 'active' : ''}" onclick="selectCategory('${cat}')">
                            <spring:message code="category.${cat}" text="${cat}" />
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
                    <div class="store-card" onclick="location.href='${pageContext.request.contextPath}/store/detail?storeId=${store.store_id}'">
                        <div class="store-img-box">
                            <c:choose>
                                <c:when test="${not empty store.store_img}">
                                    <img src="${pageContext.request.contextPath}/upload/${store.store_img}" class="store-thumb">
                                </c:when>
                                <c:otherwise><div class="no-img-placeholder">NO IMAGE</div></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="store-info">
                            <span class="badge-cat"><spring:message code="category.${store.store_category}" text="${store.store_category}" /></span>
                            <h3 class="store-name">${store.store_name}</h3>
                            <div class="store-meta">
                                <span class="rating">⭐ ${store.avg_rating}</span>
                                <span class="view-cnt"><spring:message code="store.list.grid.views" /> ${store.store_cnt}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-status-box" style="grid-column: 1/-1; text-align: center; padding: 80px; font-weight: 800; border: 2px dashed #ccc; border-radius: 15px; color: #999;">
                    <spring:message code="store.list.empty" />
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 3. 페이징 섹션 --%>
    <div class="pagination-container">
        <ul class="pagination">
            <c:if test="${pageMaker.prev}">
                <li class="page-item">
                    <a class="page-link" href="javascript:void(0);" onclick="movePage(${pageMaker.startPage - 1})">
                        <spring:message code="store.list.paging.prev" />
                    </a>
                </li>
            </c:if>
            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                    <a class="page-link" href="javascript:void(0);" onclick="movePage(${num})">${num}</a>
                </li>
            </c:forEach>
            <c:if test="${pageMaker.next}">
                <li class="page-item">
                    <a class="page-link" href="javascript:void(0);" onclick="movePage(${pageMaker.endPage + 1})">
                        <spring:message code="store.list.paging.next" />
                    </a>
                </li>
            </c:if>
        </ul>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/store_list.js"></script>
<jsp:include page="../common/footer.jsp" />