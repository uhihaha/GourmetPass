/* /resources/js/store_list.js */

/**
 * 필터 폼 제출
 */
function submitFilter() {
    document.getElementById('filterForm').submit();
}

/**
 * 카테고리 선택 핸들러
 * @param {string} cat - 선택된 카테고리명
 */
function selectCategory(cat) {
    const hiddenInput = document.getElementById('selectedCategory');
    if (hiddenInput) {
        hiddenInput.value = cat;
        submitFilter();
    }
}

// 엔터키 검색 지원
document.addEventListener("DOMContentLoaded", function() {
    const searchInput = document.querySelector(".wire-input");
    if (searchInput) {
        searchInput.addEventListener("keypress", function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                submitFilter();
            }
        });
    }
});