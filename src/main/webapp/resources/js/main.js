/* src/main/webapp/resources/js/main.js */
$(document).ready(function() {
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };
    function applyRequiredMessage(inputEl, message) {
        if (!inputEl) return;

        inputEl.addEventListener("input", function() {
            inputEl.setCustomValidity("");
        });

        inputEl.addEventListener("invalid", function() {
            inputEl.setCustomValidity(message);
        });
    }

    /**
     * [교정] 공통 클릭 이벤트 핸들러
     * - clickable 클래스를 가진 요소의 data-url 속성을 읽어 페이지를 이동시킵니다.
     * - main.jsp에서 이미 contextPath가 포함된 URL을 생성하므로 추가 경로 연산이 필요 없습니다.
     */
    $(".clickable").on("click", function() {
        var url = $(this).data("url");
        if(url) {
            // JSTL로 생성된 풀 경로를 그대로 사용합니다.
            location.href = url;
        }
    });

    // 검색창 입력 검증/제출 보조
    var mainSearchForm = document.querySelector(".search-form");
    var mainSearchInput = document.querySelector(".search-input");
    if (mainSearchInput) {
        var requiredMsg = t("store.list.search.required", "검색어를 입력해주세요.");
        applyRequiredMessage(mainSearchInput, requiredMsg);
    }
    if (mainSearchForm && mainSearchInput) {
        mainSearchForm.addEventListener("submit", function(e) {
            if (!mainSearchInput.value.trim()) {
                mainSearchInput.setCustomValidity(t("store.list.search.required", "검색어를 입력해주세요."));
                mainSearchInput.reportValidity();
                e.preventDefault();
                return;
            }
            mainSearchInput.setCustomValidity("");
        });
    }

    var favoriteButtons = document.querySelectorAll(".favorite-toggle");
    if (favoriteButtons.length) {
        var contextPath = (typeof APP_CONFIG !== "undefined" && APP_CONFIG.contextPath)
            ? APP_CONFIG.contextPath
            : "";

        function updateFavoriteButton(btn, isFavorite) {
            if (isFavorite) {
                btn.classList.add("active");
                btn.textContent = "❤️";
            } else {
                btn.classList.remove("active");
                btn.textContent = "🤍";
            }
        }

        function loadFavorites() {
            $.ajax({
                url: contextPath + "/favorite/list",
                type: "GET",
                dataType: "json"
            }).done(function(res) {
                var storeIds = new Set((res.storeIds || []).map(String));
                favoriteButtons.forEach(function(btn) {
                    var storeId = btn.dataset.storeId;
                    updateFavoriteButton(btn, storeIds.has(String(storeId)));
                });
            });
        }

        favoriteButtons.forEach(function(btn) {
            btn.addEventListener("click", function(e) {
                e.preventDefault();
                e.stopPropagation();

                $.ajax({
                    url: contextPath + "/favorite/toggle",
                    type: "POST",
                    data: {store_id: btn.dataset.storeId},
                    beforeSend: function(xhr) {
                        if (typeof APP_CONFIG !== "undefined") {
                            xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
                        }
                    }
                }).done(function(res) {
                    updateFavoriteButton(btn, !!res.favorite);
                }).fail(function(xhr) {
                    if (xhr.status === 401) {
                        alert(t("common.loginRequired", "로그인이 필요합니다"));
                    } else {
                        alert(t("common.favoriteError", "즐겨찾기 처리 중 오류가 발생했습니다."));
                    }
                });
            });
        });

        loadFavorites();
    }
});
