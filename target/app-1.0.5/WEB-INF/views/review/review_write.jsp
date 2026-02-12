<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<div style="width: 80%; max-width: 600px; margin: 40px auto; padding: 30px; border: 2px solid #333; border-radius: 15px; background: #fff;">
    <h2 style="text-align: center; margin-bottom: 30px;"><spring:message code="review.write.title" text="✍️ 리뷰 작성하기" /></h2>
    
    <div style="background: #f9f9f9; padding: 15px; border-radius: 8px; margin-bottom: 25px; border: 1px solid #ddd;">
        <p style="margin: 0; color: #666; font-size: 14px;"><spring:message code="review.write.store_label" text="방문하신 매장" /></p>
        <h3 style="margin: 5px 0;">${store.store_name}</h3>
    </div>

    <form action="${pageContext.request.contextPath}/review/write" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="store_id" value="${store.store_id}">
        <input type="hidden" name="book_id" value="${book_id}">
        <input type="hidden" name="wait_id" value="${wait_id}">

        <div style="margin-bottom: 25px;">
            <label style="display: block; font-weight: bold; margin-bottom: 10px;"><spring:message code="review.write.rating_label" text="⭐ 별점을 선택해 주세요" /></label>
            <select name="rating" required style="width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 5px; font-size: 16px;">
                <option value="5"><spring:message code="review.rating.5" text="5점 - 최고예요!" /></option>
                <option value="4"><spring:message code="review.rating.4" text="4점 - 만족해요" /></option>
                <option value="3"><spring:message code="review.rating.3" text="3점 - 보통이에요" /></option>
                <option value="2"><spring:message code="review.rating.2" text="2점 - 아쉬워요" /></option>
                <option value="1"><spring:message code="review.rating.1" text="1점 - 별로예요" /></option>
            </select>
        </div>

        <div style="margin-bottom: 25px;">
            <label style="display: block; font-weight: bold; margin-bottom: 10px;"><spring:message code="review.write.content_label" text="💬 방문 후기" /></label>
            <textarea name="content" placeholder="<spring:message code='review.write.placeholder' text='맛, 서비스, 분위기는 어떠셨나요? 솔직한 후기를 남겨주세요.' />" required 
                      style="width: 100%; height: 200px; padding: 15px; border: 1px solid #ccc; border-radius: 5px; resize: none; line-height: 1.6; font-family: inherit;"></textarea>
        </div>

        <div style="display: flex; gap: 15px; margin-top: 30px;">
            <button type="button" onclick="history.back();" 
                    style="flex: 1; padding: 15px; background: #eee; border: 1px solid #ccc; border-radius: 8px; cursor: pointer; font-weight: bold;">
                <spring:message code="common.btn.cancel" text="취소" />
            </button>
            <button type="submit" 
                    style="flex: 2; padding: 15px; background: #333; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 16px;">
                <spring:message code="review.write.submit" text="리뷰 등록하기" />
            </button>
        </div>
    </form>
</div>



<jsp:include page="../common/footer.jsp" />
