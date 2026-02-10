package com.uhi.gourmet.member;

import java.util.regex.Pattern;

public final class MemberValidation {

    private static final Pattern USER_ID_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{4,20}$");
    
    // [수정] 문자 클래스 내의 [ 와 ] 를 정확히 이스케이프 처리하였습니다.
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-\\[\\]{};':\"\\\\|,.<>/?]).{8,20}$"
    );

    private MemberValidation() { }

    public static boolean isValidUserId(String userId) {
        return userId != null && USER_ID_PATTERN.matcher(userId).matches();
    }

    public static boolean isValidPassword(String password) {
        return password != null && PASSWORD_PATTERN.matcher(password).matches();
    }
}