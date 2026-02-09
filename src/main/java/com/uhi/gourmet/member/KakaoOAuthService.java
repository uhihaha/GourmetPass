package com.uhi.gourmet.member;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class KakaoOAuthService {

    private static final String AUTHORIZE_URL = "https://kauth.kakao.com/oauth/authorize";
    private static final String TOKEN_URL = "https://kauth.kakao.com/oauth/token";
    private static final String USERINFO_URL = "https://kapi.kakao.com/v2/user/me";

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${kakao.oauth.client-id:}")
    private String clientId;

    @Value("${kakao.oauth.client-secret:}")
    private String clientSecret;

    @Value("${kakao.oauth.redirect-uri:}")
    private String redirectUri;

    @Value("${kakao.oauth.scope:profile_nickname}")
    private String scope;

    public String buildAuthorizeUrl(String state) {
        return UriComponentsBuilder.fromHttpUrl(AUTHORIZE_URL)
            .queryParam("response_type", "code")
            .queryParam("client_id", clientId)
            .queryParam("redirect_uri", redirectUri)
            .queryParam("state", state)
            .queryParamIfPresent("scope", getScope())
            .toUriString();
    }
    private java.util.Optional<String> getScope() {
        if (scope == null || scope.trim().isEmpty()) {
            return java.util.Optional.empty();
        }
        String[] scopes = scope.trim().split("\\s+");
        StringBuilder filtered = new StringBuilder();
        for (String entry : scopes) {
            if ("account_email".equals(entry)) {
                continue;
            }
            if (filtered.length() > 0) {
                filtered.append(' ');
            }
            filtered.append(entry);
        }
        if (filtered.length() == 0) {
            return java.util.Optional.empty();
        }
        return java.util.Optional.of(filtered.toString());
    }

    public SocialProfile fetchUserProfile(String code) {
        String accessToken = getAccessToken(code);
        return getUserInfo(accessToken);
    }

    private String getAccessToken(String code) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("redirect_uri", redirectUri);
        params.add("code", code);
        if (clientSecret != null && !clientSecret.trim().isEmpty()) {
            params.add("client_secret", clientSecret);
        }

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        ResponseEntity<String> response = restTemplate.postForEntity(TOKEN_URL, request, String.class);
        try {
            JsonNode node = objectMapper.readTree(response.getBody());
            JsonNode tokenNode = node.get("access_token");
            if (tokenNode == null) {
                throw new IllegalStateException("No access_token in response");
            }
            return tokenNode.asText();
        } catch (Exception ex) {
            throw new IllegalStateException("Failed to parse Kakao access token", ex);
        }
    }

    private SocialProfile getUserInfo(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        HttpEntity<Void> request = new HttpEntity<>(headers);
        ResponseEntity<String> response = restTemplate.postForEntity(USERINFO_URL, request, String.class);

        try {
            JsonNode node = objectMapper.readTree(response.getBody());
            String id = node.path("id").asText();
            String nickname = extractNickname(node);
            String email = extractEmail(node);
            return new SocialProfile("KAKAO", id, nickname, email);
        } catch (Exception ex) {
            throw new IllegalStateException("Failed to parse Kakao user info", ex);
        }
    }

    private String extractNickname(JsonNode node) {
        JsonNode properties = node.get("properties");
        if (properties != null && properties.get("nickname") != null) {
            return properties.get("nickname").asText();
        }
        JsonNode profile = node.path("kakao_account").path("profile");
        if (profile.get("nickname") != null) {
            return profile.get("nickname").asText();
        }
        String id = node.path("id").asText();
        return "Guest_" + id;
    }

    private String extractEmail(JsonNode node) {
        JsonNode account = node.get("kakao_account");
        if (account != null && account.get("email") != null) {
            return account.get("email").asText();
        }
        return null;
    }
}
