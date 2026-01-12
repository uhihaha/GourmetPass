<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="common/header.jsp" />

<%-- 메인 전용 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/main.css'/>">

<div class="main-wrapper">
    <div class="search-card">
        <div class="search-title">🍴 오늘 뭐 먹지?</div>
        <form action="${pageContext.request.contextPath}/store/list" method="get" class="search-form">
            <input type="text" name="keyword" class="search-input" placeholder="가게 이름 또는 메뉴 검색">
            <button type="submit" class="btn-search">맛집 검색</button>
        </form>
    </div>

    <div class="category-container">
        <div class="btn-category" onclick="location.href='${pageContext.request.contextPath}/store/list?category=한식'">한식 🍚</div>
        <div class="btn-category" onclick="location.href='${pageContext.request.contextPath}/store/list?category=일식'">일식 🍣</div>
        <div class="btn-category" onclick="location.href='${pageContext.request.contextPath}/store/list?category=양식'">양식 🍝</div>
        <div class="btn-category" onclick="location.href='${pageContext.request.contextPath}/store/list?category=중식'">중식 🥡</div>
        <div class="btn-category" onclick="location.href='${pageContext.request.contextPath}/store/list?category=카페'">카페 ☕</div>
        <div class="btn-category btn-all" onclick="location.href='${pageContext.request.contextPath}/store/list'">전체보기</div>
    </div>

    <hr class="section-divider">

    <div class="section-title">
        <span>🔥 실시간 인기 맛집 (Top 6)</span>
    </div>

    <div class="store-grid">
        <c:choose>
            <c:when test="${not empty storeList}">
                <c:forEach var="store" items="${storeList}" end="5">
                    <div class="store-card" onclick="location.href='${pageContext.request.contextPath}/store/detail?storeId=${store.store_id}'">
                        <div class="store-img-box">
                            <c:choose>
                                <c:when test="${not empty store.store_img}">
                                    <img src="${pageContext.request.contextPath}/upload/${store.store_img}">
                                </c:when>
                                <c:otherwise><span class="no-img-text">No Image</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="store-info">
                            <div class="store-cat">${store.store_category}</div>
                            <div class="store-name-row">
                                <h3 class="store-name">${store.store_name}</h3>
                                <c:if test="${store.store_cnt >= 100}"><span class="hot-badge">HOT</span></c:if>
                            </div>
                            <div class="store-addr">${store.store_addr1}</div>
                            <div class="store-stats">👀 조회수 ${store.store_cnt}</div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-msg">현재 등록된 인기 맛집이 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="common/footer.jsp" />