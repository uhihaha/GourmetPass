/* src/main/webapp/resources/js/app-config.js */
(function() {
    const config = window.APP_CONFIG || {};
    const contextMeta = document.querySelector('meta[name="app-context-path"]');
    const csrfNameMeta = document.querySelector('meta[name="csrf-name"]');
    const csrfTokenMeta = document.querySelector('meta[name="csrf-token"]');

    if (contextMeta) {
        config.contextPath = contextMeta.content || "";
    }
    if (csrfNameMeta) {
        config.csrfName = csrfNameMeta.content || "";
    }
    if (csrfTokenMeta) {
        config.csrfToken = csrfTokenMeta.content || "";
    }

    window.APP_CONFIG = config;
})();

/* src/main/webapp/resources/js/app-config.js - i18n properties loader */
(function() {
    var i18nState = {
        loaded: false,
        lang: "ko",
        messages: {},
        loadPromise: null
    };

    function normalizeLang(rawLang) {
        var lang = (rawLang || "ko").toLowerCase().split("-")[0];

        if (lang === "ja") {
            return "jp";
        }

        if (["ko", "en", "jp"].indexOf(lang) > -1) {
            return lang;
        }

        return "ko";
    }

    function decodePropertiesValue(value) {
        if (!value) {
            return "";
        }

        return value
            .replace(/\\u([0-9a-fA-F]{4})/g, function(_, hex) {
                return String.fromCharCode(parseInt(hex, 16));
            })
            .replace(/\\t/g, "\t")
            .replace(/\\r/g, "\r")
            .replace(/\\n/g, "\n")
            .replace(/\\f/g, "\f")
            .replace(/\\\\/g, "\\");
    }

    function parseProperties(text) {
        var result = {};

        if (!text) {
            return result;
        }

        text.split(/\r?\n/).forEach(function(line) {
            var trimmed = line.trim();
            if (!trimmed || trimmed.startsWith("#") || trimmed.startsWith("!")) {
                return;
            }

            var separatorIndex = trimmed.indexOf("=");
            if (separatorIndex < 0) {
                separatorIndex = trimmed.indexOf(":");
            }
            if (separatorIndex < 0) {
                return;
            }

            var key = trimmed.substring(0, separatorIndex).trim();
            var value = trimmed.substring(separatorIndex + 1).trim();
            result[key] = decodePropertiesValue(value);
        });

        return result;
    }

    function getByPath(source, path) {
        if (!source || !path) {
            return undefined;
        }

        return path.split(".").reduce(function(acc, key) {
            if (acc && typeof acc === "object" && key in acc) {
                return acc[key];
            }
            return undefined;
        }, source);
    }

    function format(template, params) {
        if (typeof template !== "string") {
            return template;
        }

        if (!params || !params.length) {
            return template;
        }

        return template.replace(/\{(\d+)\}/g, function(match, idx) {
            var paramIndex = parseInt(idx, 10);
            return params[paramIndex] !== undefined ? params[paramIndex] : match;
        });
    }

    function loadProperties() {
        if (i18nState.loadPromise) {
            return i18nState.loadPromise;
        }

        var htmlLang = document.documentElement ? document.documentElement.lang : "";
        var browserLang = navigator.language || navigator.userLanguage || "ko";
        var lang = normalizeLang(htmlLang || browserLang);
        var contextPath = (window.APP_CONFIG && window.APP_CONFIG.contextPath) ? window.APP_CONFIG.contextPath : "";
        var basePath = contextPath + "/resources/i18n/";

        i18nState.lang = lang;

        function read(fileName) {
            return fetch(basePath + fileName, { cache: "no-store" })
                .then(function(res) {
                    if (!res.ok) {
                        return "";
                    }
                    return res.text();
                })
                .catch(function() {
                    return "";
                });
        }

        i18nState.loadPromise = read("messages_" + lang + ".properties")
            .then(function(content) {
                i18nState.messages = parseProperties(content);
                i18nState.loaded = true;
                return i18nState.messages;
            });

        return i18nState.loadPromise;
    }

    function t(key, fallback) {
        var params = Array.prototype.slice.call(arguments, 2);
        var message = i18nState.messages[key];

        if (message === undefined || message === null || message === "") {
            message = getByPath(window.I18N || {}, key);
        }

        if (message === undefined || message === null || message === "") {
            message = fallback || key;
        }

        return format(message, params);
    }

    function showAlert(key, fallback) {
        var params = Array.prototype.slice.call(arguments, 2);
        alert(t.apply(null, [key, fallback].concat(params)));
    }

    function showConfirm(key, fallback) {
        var params = Array.prototype.slice.call(arguments, 2);
        return confirm(t.apply(null, [key, fallback].concat(params)));
    }


    function consumeFlashMessage() {
        var flashEl = document.getElementById("flash-message");
        if (!flashEl) {
            return;
        }
        var message = flashEl.getAttribute("data-message");
        if (message) {
            alert(message);
            flashEl.remove();
        }
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", consumeFlashMessage);
    } else {
        consumeFlashMessage();
    }

    window.I18N_UTIL = {
        t: t,
        alert: showAlert,
        confirm: showConfirm,
        load: loadProperties,
        ready: loadProperties(),
        getLang: function() {
            return i18nState.lang;
        }
    };
})();
