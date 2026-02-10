/* src/main/webapp/resources/js/main.js */
$(document).ready(function() {
    var COMMON_I18N = (window.I18N && window.I18N.common) ? window.I18N.common : {};
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

    // 검색창 엔터키 입력 시 폼 제출 보조 (선택 사항)
    $(".search-input").on("keypress", function(e) {
        if (e.which == 13) {
            $(this).closest("form").submit();
        }
    });

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
                        var loginRequired = COMMON_I18N.loginRequired || "";
                        alert(loginRequired);
                    } else {
                        var favoriteError = COMMON_I18N.favoriteError || "";
                        alert(favoriteError);
                    }
                });
            });
        });

        loadFavorites();
    }
});
