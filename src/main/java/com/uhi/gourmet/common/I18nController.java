package com.uhi.gourmet.common;

import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/i18n")
public class I18nController {

    @Autowired
    private MessageSource messageSource;

    @GetMapping("/messages")
    public Map<String, String> messages(@RequestParam(value = "keys", required = false) String keys,
                                        Locale locale) {
        Map<String, String> result = new LinkedHashMap<String, String>();
        if (keys == null || keys.trim().isEmpty()) {
            return result;
        }

        String[] keyArray = keys.split(",");
        for (int i = 0; i < keyArray.length; i++) {
            String key = keyArray[i].trim();
            if (key.isEmpty()) {
                continue;
            }
            String message = messageSource.getMessage(key, null, key, locale);
            result.put(key, message);
        }

        return result;
    }
}
