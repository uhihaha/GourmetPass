/* /resources/js/review.js */
var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
    ? window.I18N_UTIL.t
    : function(key, fallback) { return fallback || key; };

function confirmDeleteReview(reviewId, storeId) {
    var deleteConfirm = t("review.deleteConfirm", "리뷰를 삭제하시겠습니까?");
    if (confirm(deleteConfirm)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = APP_CONFIG.contextPath + '/review/delete';

        const fields = {
            'review_id': reviewId,
            'store_id': storeId,
            [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken
        };

        for (const key in fields) {
            if (Object.prototype.hasOwnProperty.call(fields, key)) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = fields[key];
                form.appendChild(input);
            }
        }

        document.body.appendChild(form);
        form.submit();
    }
}
