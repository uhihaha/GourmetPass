/* /resources/js/review.js */
function confirmDeleteReview(reviewId, storeId) {
    if(confirm("이 리뷰를 삭제하시겠습니까?")) {
        const form = document.createElement('form');
        form.method = 'POST';
        // APP_CONFIG가 header.jsp에 선언되어 있다고 가정
        form.action = APP_CONFIG.contextPath + '/review/delete';
        
        const fields = {
            'review_id': reviewId,
            'store_id': storeId,
            [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken
        };

        for (const key in fields) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = fields[key];
            form.appendChild(input);
        }
        document.body.appendChild(form);
        form.submit();
    }
}