/* com/uhi/gourmet/member/MemberController.java */
package com.uhi.gourmet.member;

import java.security.Principal;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;
import java.util.Locale;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo; 
import com.uhi.gourmet.book.BookService;
import com.uhi.gourmet.book.BookVO;
import com.uhi.gourmet.favorite.FavoriteService;
import com.uhi.gourmet.photo.PhotoService;
import com.uhi.gourmet.photo.PhotoVO;
import com.uhi.gourmet.wait.WaitService;
import com.uhi.gourmet.wait.WaitVO;
import com.uhi.gourmet.store.StoreMapper;
import com.uhi.gourmet.store.StoreVO;
import com.uhi.gourmet.review.ReviewService; 
import com.uhi.gourmet.review.ReviewVO;

import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/member")
@Log4j2
public class MemberController {

    @Autowired
    private MemberService memberService; 

    @Autowired
    private StoreMapper storeMapper; 

    @Autowired
    private BookService book_service;

    @Autowired
    private WaitService wait_service;

    @Autowired
    private ReviewService review_service; 

    @Autowired
    private FavoriteService favoriteService;

    @Autowired
    private PhotoService photoService;

    @Autowired
    private JavaMailSenderImpl mailSender;

    @Autowired
    private KakaoOAuthService kakaoOAuthService;

    @Autowired
    private GoogleOAuthService googleOAuthService;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @Autowired
    private MessageSource messageSource;

    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    private static final String SOCIAL_PROFILE_SESSION_KEY = "socialProfile";
    private static final String SOCIAL_PASSWORD_SESSION_KEY = "socialPassword";
    private static final String SOCIAL_SIGNUP_FLAG = "socialSignup";

    private void addKakaoKeyToModel(Model model) {
        model.addAttribute("kakaoJsKey", kakaoJsKey);
    }

    // [수정 핵심] 회원가입 이메일 인증
    @PostMapping("/emailAuth")
    @ResponseBody
    public int emailAuth(@RequestParam("email") String email) {
        log.info("이메일 인증 요청 수신: " + email);
        int checkNum = generateAuthCode();
        
        String title = getMessage(
            "mail.auth.signup.subject",
            null,
            "Gourmet 회원가입 인증 이메일입니다."
        );
        
        // MessageSource에 인자(args)를 넘기지 않고 원문을 가져옵니다.
        String content = getMessage(
            "mail.auth.signup.body",
            null,
            "GourmetPass를 이용해주셔서 감사합니다.<br><br>인증 코드는 <b>{0}</b> 입니다.<br>해당 인증 코드를 인증 코드 확인란에 기입하여 주세요."
        );
        
        // 자바 코드로 직접 {0}을 문자열 숫자로 치환하여 콤마 발생을 원천 차단합니다.
        content = content.replace("{0}", String.valueOf(checkNum));
        
        sendEmail(email, title, content);
        return checkNum;
    }

    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error, Model model) {
        if (error != null) model.addAttribute("msg", "아이디 또는 비밀번호를 확인해주세요.");
        return "member/login";
    }

    @GetMapping("/oauth/kakao")
    public String kakaoOAuthStart(HttpSession session) {
        String state = generateOAuthState(session);
        return "redirect:" + kakaoOAuthService.buildAuthorizeUrl(state);
    }

    @GetMapping("/oauth/google")
    public String googleOAuthStart(HttpSession session, HttpServletRequest request) {
        String state = generateOAuthState(session);
        String redirectUri = buildRedirectUri(request, "/member/oauth/google/callback");
        return "redirect:" + googleOAuthService.buildAuthorizeUrl(state, redirectUri);
    }

    @GetMapping({"/kakao_callback", "/oauth/kakao/callback"})
    public String kakaoCallback(@RequestParam("code") String code,
            @RequestParam(value = "state", required = false) String state,
            HttpSession session, RedirectAttributes rttr, HttpServletRequest request) {
        if (!isValidOAuthState(session, state)) {
            rttr.addFlashAttribute("msg", "소셜 로그인 인증이 만료되었습니다. 다시 시도해주세요.");
            return "redirect:/member/login";
        }
        try {
            SocialProfile profile = kakaoOAuthService.fetchUserProfile(code);
            return handleSocialCallback(profile, session, rttr, request);
        } catch (IllegalStateException ex) {
            log.error("카카오 로그인 실패", ex);
            rttr.addFlashAttribute("msg", "카카오 로그인에 실패했습니다.");
            return "redirect:/member/login";
        }
    }

    @GetMapping({"/google_callback", "/oauth/google/callback"})
    public String googleCallback(@RequestParam("code") String code,
            @RequestParam(value = "state", required = false) String state,
            HttpSession session, RedirectAttributes rttr, HttpServletRequest request) {
        if (!isValidOAuthState(session, state)) {
            rttr.addFlashAttribute("msg", "소셜 로그인 인증이 만료되었습니다. 다시 시도해주세요.");
            return "redirect:/member/login";
        }
        try {
            String redirectUri = buildRedirectUri(request, "/member/oauth/google/callback");
            SocialProfile profile = googleOAuthService.fetchUserProfile(code, redirectUri);
            return handleSocialCallback(profile, session, rttr, request);
        } catch (IllegalStateException ex) {
            log.error("구글 로그인 실패", ex);
            rttr.addFlashAttribute("msg", "구글 로그인에 실패했습니다.");
            return "redirect:/member/login";
        }
    }

    @GetMapping("/signup/select")
    public String signupSelectPage(HttpSession session, Model model) {
        model.addAttribute("socialSignup", session.getAttribute(SOCIAL_PROFILE_SESSION_KEY) != null);
        return "member/signup_select";
    }

    @GetMapping("/signup/general")
    public String signupGeneralPage(@RequestParam(value = "social", required = false) Boolean social,
            HttpSession session, Model model, HttpServletRequest request) {
        addKakaoKeyToModel(model);
        if (Boolean.TRUE.equals(social)) {
            SocialProfile profile = (SocialProfile) session.getAttribute(SOCIAL_PROFILE_SESSION_KEY);
            if (profile != null) {
                String userId = profile.getUserId();
                MemberVO existing = memberService.getMember(userId);
                if (existing != null) {
                    authenticateUser(request, userId);
                    clearSocialSignupSession(session);
                    return redirectByRole(existing.getUser_role());
                }
                MemberVO member = buildSocialMember(profile, session);
                memberService.joinMember(member);
                authenticateUser(request, member.getUser_id());
                clearSocialSignupSession(session);
                return "redirect:/";
            }
        }
        populateSocialSignupModel(social, session, model);
        return "member/signup_general"; 
    }

    @PostMapping("/joinProcess")
    public String joinGeneralProcess(MemberVO vo, @RequestParam(value = "social_signup", required = false) Boolean socialSignup,
            HttpSession session, RedirectAttributes rttr, HttpServletRequest request) {
        String validationError = validateUserInput(vo, !Boolean.TRUE.equals(socialSignup));
        if (validationError != null) {
            rttr.addFlashAttribute("msg", validationError);
            return "redirect:/member/signup/general";
        }
        if (memberService.checkIdDuplicate(vo.getUser_id()) > 0) {
            rttr.addFlashAttribute("msg", "이미 사용 중인 아이디입니다.");
            return "redirect:/member/signup/general";
        }
        memberService.joinMember(vo);
        authenticateUser(request, vo.getUser_id());
        if (Boolean.TRUE.equals(socialSignup)) {
            clearSocialSignupSession(session);
        }
        return "redirect:/";
    }

    @GetMapping("/signup/owner1")
    public String signupOwner1Page(@RequestParam(value = "social", required = false) Boolean social,
            HttpSession session, Model model) {
        addKakaoKeyToModel(model);
        if (Boolean.TRUE.equals(social)) {
            SocialProfile profile = (SocialProfile) session.getAttribute(SOCIAL_PROFILE_SESSION_KEY);
            if (profile != null) {
                MemberVO member = buildSocialMember(profile, session);
                session.setAttribute("tempMember", member);
                session.setAttribute(SOCIAL_SIGNUP_FLAG, true);
                return "redirect:/member/signup/owner2";
            }
        }
        populateSocialSignupModel(social, session, model);
        return "member/signup_owner1"; 
    }
    
    @PostMapping("/signup/ownerStep1")
    public String signupOwner1Process(MemberVO member, @RequestParam(value = "social_signup", required = false) Boolean socialSignup,
            HttpSession session, RedirectAttributes rttr) {
        String validationError = validateUserInput(member, !Boolean.TRUE.equals(socialSignup));
        if (validationError != null) {
            session.removeAttribute("tempMember");
            rttr.addFlashAttribute("msg", validationError);
            return "redirect:/member/signup/owner1";
        }
        if (memberService.checkIdDuplicate(member.getUser_id()) > 0) {
            session.removeAttribute("tempMember");
            rttr.addFlashAttribute("msg", "이미 사용 중인 아이디입니다.");
            return "redirect:/member/signup/owner1";
        }
        session.setAttribute("tempMember", member);
        if (Boolean.TRUE.equals(socialSignup)) {
            session.setAttribute(SOCIAL_SIGNUP_FLAG, true);
        }
        return "redirect:/member/signup/owner2";
    }

    @GetMapping("/signup/owner2")
    public String signupOwner2Page(Model model) {
        addKakaoKeyToModel(model);
        return "member/signup_owner2";
    }

    @PostMapping("/signup/ownerFinal") 
    public String joinOwnerProcess(StoreVO store, HttpSession session, RedirectAttributes rttr,
            HttpServletRequest request) {
        MemberVO member = (MemberVO) session.getAttribute("tempMember");
        boolean socialSignup = Boolean.TRUE.equals(session.getAttribute(SOCIAL_SIGNUP_FLAG));
        if (member != null) {
            String validationError = validateUserInput(member, !socialSignup);
            if (validationError != null) {
                session.removeAttribute("tempMember");
                rttr.addFlashAttribute("msg", validationError);
                return "redirect:/member/signup/owner1";
            }
            if (memberService.checkIdDuplicate(member.getUser_id()) > 0) {
                session.removeAttribute("tempMember");
                rttr.addFlashAttribute("msg", "이미 사용 중인 아이디입니다.");
                return "redirect:/member/signup/owner1";
            }
            memberService.joinOwner(member, store);
            session.removeAttribute("tempMember");
            if (socialSignup) {
                authenticateUser(request, member.getUser_id());
                clearSocialSignupSession(session);
                return "redirect:/member/mypage";
            }
            rttr.addFlashAttribute("msg", "점주 가입 신청이 완료되었습니다.");
        }
        return "redirect:/member/login";
    }

    @GetMapping("/mypage")
    public String mypage(Principal principal, Model model, HttpServletRequest request) {
        String user_id = principal.getName();
        MemberVO member = memberService.getMember(user_id);
        model.addAttribute("member", member);

        if (request.isUserInRole("ROLE_OWNER")) {
            StoreVO store = storeMapper.getStoreByUserId(user_id);
            if (store != null) {
                PhotoVO thumbnail = photoService.getThumbnailByStore(store.getStore_id());
                if (thumbnail != null) {
                    store.setStore_img(thumbnail.getFile_path());
                }
                model.addAttribute("store", store);
                model.addAttribute("menuList", storeMapper.getMenuList(store.getStore_id()));
                model.addAttribute("store_book_list", book_service.get_store_book_list(store.getStore_id()));
                model.addAttribute("photo_list", photoService.getPhotosByStoreAll(store.getStore_id()));
                model.addAttribute("store_review_list", review_service.getStoreReviews(store.getStore_id(), 1, 10).getList());
            } else {
                model.addAttribute("noStoreMsg", "등록된 매장 정보가 없습니다.");
            }
            return "member/mypage_owner";
        } else {
            PageInfo<ReviewVO> reviewPage = review_service.getMyReviewsPaginated(user_id, 1, 3);
            model.addAttribute("my_review_list", reviewPage.getList());
            model.addAttribute("total_review_cnt", reviewPage.getTotal()); 
            model.addAttribute("favorite_list", favoriteService.getFavoritesByUser(user_id));
            return "member/mypage"; 
        }
    }

    @GetMapping("/review/mine")
    public String myReviewList(
            @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
            Principal principal, Model model) {
        if (principal == null) return "redirect:/member/login";
        String user_id = principal.getName();
        PageInfo<ReviewVO> pageMaker = review_service.getMyReviewsPaginated(user_id, pageNum, 3);
        model.addAttribute("allReviews", pageMaker.getList());
        model.addAttribute("pageMaker", pageMaker);
        return "review/review_mine"; 
    }

    @GetMapping("/wait_status")
    public String myStatus(Principal principal, Model model) {
        if (principal == null) return "redirect:/member/login";
        model.addAllAttributes(memberService.getMyStatusSummary(principal.getName()));
        return "wait/wait_status"; 
    }
    
    @GetMapping("/history")
    public String myHistory(
            @RequestParam(value = "waitPage", defaultValue = "1") int waitPage,
            @RequestParam(value = "bookPage", defaultValue = "1") int bookPage,
            Principal principal, Model model) {
        if (principal == null) return "redirect:/member/login";
        String userId = principal.getName();
        PageHelper.startPage(waitPage, 5);
        List<WaitVO> waitList = wait_service.get_my_wait_list(userId);
        PageInfo<WaitVO> waitPageInfo = new PageInfo<>(waitList);
        PageHelper.startPage(bookPage, 5);
        List<BookVO> bookList = book_service.get_my_book_list(userId);
        PageInfo<BookVO> bookPageInfo = new PageInfo<>(bookList);
        model.addAttribute("waitPageInfo", waitPageInfo);
        model.addAttribute("bookPageInfo", bookPageInfo);
        model.addAttribute("my_wait_list", waitList);
        model.addAttribute("my_book_list", bookList);
        return "wait/wait_history";
    }
    
    @GetMapping("/edit")
    public String editPage(Principal principal, Model model) {
        model.addAttribute("member", memberService.getMember(principal.getName()));
        addKakaoKeyToModel(model);
        return "member/member_edit";
    }
    
    @PostMapping("/edit")
    public String updateProcess(MemberVO vo, RedirectAttributes rttr) {
        String validationError = validateUserInput(vo, false);
        if (validationError != null) {
            rttr.addFlashAttribute("msg", validationError);
            return "redirect:/member/edit";
        }
        memberService.updateMember(vo);
        rttr.addFlashAttribute("msg", "회원 정보가 수정되었습니다.");
        return "redirect:/member/mypage";
    }

    @PostMapping("/delete")
    public String deleteMember(@RequestParam("user_id") String user_id, HttpSession session, RedirectAttributes rttr) {
        memberService.deleteMember(user_id);
        SecurityContextHolder.clearContext();
        if (session != null) session.invalidate();
        rttr.addFlashAttribute("msg", "정상적으로 탈퇴되었습니다.");
        return "redirect:/";
    }

    @PostMapping("/idCheck")
    @ResponseBody
    public String idCheck(@RequestParam("user_id") String user_id) {
        if (!MemberValidation.isValidUserId(user_id)) {
            return "invalid";
        }
        return (memberService.checkIdDuplicate(user_id) > 0) ? "fail" : "success";
    }

    @GetMapping("/find")
    public String findAccountPage() {
        return "member/find_account";
    }

    @PostMapping("/find/id")
    public String findId(@RequestParam("user_nm") String name,
                         @RequestParam("user_email") String email,
                         Model model) {
        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            model.addAttribute("idError", "이름과 이메일을 모두 입력해주세요.");
            return "member/find_account";
        }
        String userId = memberService.findUserIdByNameEmail(name.trim(), email.trim());
        if (userId == null) {
            model.addAttribute("idError", "일치하는 아이디가 없습니다.");
            return "member/find_account";
        }
        model.addAttribute("idResult", userId);
        return "member/find_account";
    }

    @PostMapping(value = "/find/id/ajax", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public Map<String, Object> findIdAjax(@RequestParam("user_nm") String name,
                                          @RequestParam("user_email") String email) {
        Map<String, Object> response = new HashMap<>();
        String userId = memberService.findUserIdByNameEmail(name.trim(), email.trim());
        if (userId != null) {
            response.put("status", "success");
            response.put("userId", userId);
        } else {
            response.put("status", "not_found");
        }
        return response;
    }

    @PostMapping("/find/password")
    public String resetPassword(@RequestParam("user_id") String userId,
                                @RequestParam("user_email") String email,
                                @RequestParam(value = "auth_code", required = false) String authCode,
                                HttpSession session,
                                Model model) {
        if (!MemberValidation.isValidUserId(userId)) {
            model.addAttribute("pwError", "아이디는 영문/숫자/언더바 4~20자만 가능합니다.");
            return "member/find_account";
        }
        if (email == null || email.trim().isEmpty()) {
            model.addAttribute("pwError", "이메일을 입력해주세요.");
            return "member/find_account";
        }
        String trimUserId = userId.trim();
        String trimEmail = email.trim();
        if (!isPasswordAuthValid(session, authCode, trimUserId, trimEmail)) {
            model.addAttribute("pwError", "이메일 인증이 완료되지 않았습니다.");
            return "member/find_account";
        }
        String tempPassword = memberService.resetPasswordByIdEmail(trimUserId, trimEmail);
        if (tempPassword == null) {
            model.addAttribute("pwError", "입력하신 정보와 일치하는 계정을 찾을 수 없습니다.");
            return "member/find_account";
        }
        sendTempPasswordEmail(trimEmail, tempPassword);
        clearPasswordAuthSession(session);
        model.addAttribute("pwResult", "임시 비밀번호를 이메일로 발송했습니다.");
        return "member/find_account";
    }

    // [수정 핵심] 비밀번호 찾기 이메일 인증
    @PostMapping("/password/emailAuth")
    @ResponseBody
    public String passwordEmailAuth(@RequestParam("user_id") String userId,
                                    @RequestParam("user_email") String email,
                                    HttpSession session) {
        if (!MemberValidation.isValidUserId(userId) || email == null || email.trim().isEmpty()) {
            return "invalid";
        }
        String trimUserId = userId.trim();
        String trimEmail = email.trim();
        if (!memberService.hasMemberByIdEmail(trimUserId, trimEmail)) {
            return "not_found";
        }
        int checkNum = generateAuthCode();
        
        String title = getMessage(
            "mail.auth.password.subject",
            null,
            "Gourmet 비밀번호 재설정 인증 코드입니다."
        );
        
        // MessageSource가 콤마를 찍지 않도록 null 인자를 전달합니다.
        String content = getMessage(
            "mail.auth.password.body",
            null,
            "비밀번호 재설정을 요청하셨습니다.<br><br>인증 코드는 <b>{0}</b> 입니다.<br>인증 코드를 입력한 뒤 임시 비밀번호 발급을 진행해주세요."
        );
        
        // {0}을 String.valueOf()로 감싼 숫자와 치환합니다.
        content = content.replace("{0}", String.valueOf(checkNum));
        
        sendEmail(trimEmail, title, content);
        session.setAttribute("pwAuthCode", String.valueOf(checkNum));
        session.setAttribute("pwAuthUserId", trimUserId);
        session.setAttribute("pwAuthEmail", trimEmail);
        session.setAttribute("pwAuthIssuedAt", System.currentTimeMillis());
        return "success";
    }

    private boolean isPasswordAuthValid(HttpSession session, String authCode, String userId, String email) {
        if (authCode == null || authCode.trim().isEmpty()) return false;
        if (session == null) return false;
        Object storedCode = session.getAttribute("pwAuthCode");
        Object storedUserId = session.getAttribute("pwAuthUserId");
        Object storedEmail = session.getAttribute("pwAuthEmail");
        Object issuedAt = session.getAttribute("pwAuthIssuedAt");
        if (storedCode == null || storedUserId == null || storedEmail == null || issuedAt == null) return false;
        long issuedTime = (Long) issuedAt;
        if (System.currentTimeMillis() - issuedTime > 180_000) return false;
        return authCode.trim().equals(storedCode) && userId.equals(storedUserId) && email.equals(storedEmail);
    }

    private void clearPasswordAuthSession(HttpSession session) {
        if (session != null) {
            session.removeAttribute("pwAuthCode");
            session.removeAttribute("pwAuthUserId");
            session.removeAttribute("pwAuthEmail");
            session.removeAttribute("pwAuthIssuedAt");
        }
    }

    private int generateAuthCode() {
        Random random = new Random();
        return random.nextInt(888888) + 111111;
    }

    private String generateOAuthState(HttpSession session) {
        String state = UUID.randomUUID().toString();
        session.setAttribute("oauthState", state);
        return state;
    }

    private String buildRedirectUri(HttpServletRequest request, String callbackPath) {
        String scheme = request.getScheme();
        String host = request.getServerName();
        int port = request.getServerPort();
        String contextPath = request.getContextPath();
        StringBuilder redirect = new StringBuilder();
        redirect.append(scheme).append("://").append(host);
        if ((scheme.equals("http") && port != 80) || (scheme.equals("https") && port != 443)) {
            redirect.append(':').append(port);
        }
        redirect.append(contextPath).append(callbackPath);
        return redirect.toString();
    }

    private boolean isValidOAuthState(HttpSession session, String state) {
        Object stored = session.getAttribute("oauthState");
        session.removeAttribute("oauthState");
        return stored != null && stored.equals(state);
    }

    private String handleSocialCallback(SocialProfile profile, HttpSession session, RedirectAttributes rttr,
            HttpServletRequest request) {
        if (profile == null) {
            rttr.addFlashAttribute("msg", "소셜 로그인에 실패했습니다. 다시 시도해주세요.");
            return "redirect:/member/login";
        }
        String userId = createSocialUserId(profile.getProvider(), profile.getProviderId());
        profile.setUserId(userId);
        MemberVO existing = memberService.getMember(userId);
        if (existing != null) {
            authenticateUser(request, userId);
            clearSocialSignupSession(session);
            return redirectByRole(existing.getUser_role());
        }
        session.setAttribute(SOCIAL_PROFILE_SESSION_KEY, profile);
        session.setAttribute(SOCIAL_SIGNUP_FLAG, true);
        return "redirect:/member/signup/select?social=true";
    }

    private void populateSocialSignupModel(Boolean social, HttpSession session, Model model) {
        if (!Boolean.TRUE.equals(social)) {
            clearSocialSignupSession(session);
            model.addAttribute("socialSignup", false);
            return;
        }
        SocialProfile profile = (SocialProfile) session.getAttribute(SOCIAL_PROFILE_SESSION_KEY);
        if (profile == null) {
            model.addAttribute("socialSignup", false);
            return;
        }
        model.addAttribute("socialSignup", true);
        model.addAttribute("socialUserId", profile.getUserId());
        model.addAttribute("socialName", profile.getNickname());
        model.addAttribute("socialEmail", profile.getEmail());
        model.addAttribute("socialPassword", getOrCreateSocialPassword(session));
    }

    private MemberVO buildSocialMember(SocialProfile profile, HttpSession session) {
        MemberVO member = new MemberVO();
        member.setUser_id(profile.getUserId());
        member.setUser_pw(getOrCreateSocialPassword(session));
        String nickname = profile.getNickname();
        if (nickname == null || nickname.trim().isEmpty()) nickname = profile.getUserId();
        member.setUser_nm(nickname);
        member.setUser_email(profile.getEmail());
        member.setUser_tel("010-0000-0000");
        return member;
    }

    private String getOrCreateSocialPassword(HttpSession session) {
        Object stored = session.getAttribute(SOCIAL_PASSWORD_SESSION_KEY);
        if (stored instanceof String) return (String) stored;
        String password = generateSocialPassword();
        session.setAttribute(SOCIAL_PASSWORD_SESSION_KEY, password);
        return password;
    }

    private void clearSocialSignupSession(HttpSession session) {
        session.removeAttribute(SOCIAL_PROFILE_SESSION_KEY);
        session.removeAttribute(SOCIAL_PASSWORD_SESSION_KEY);
        session.removeAttribute(SOCIAL_SIGNUP_FLAG);
    }

    private String generateSocialPassword() {
        SecureRandom random = new SecureRandom();
        String all = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%^&*";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 12; i++) sb.append(all.charAt(random.nextInt(all.length())));
        return sb.toString();
    }

    private String createSocialUserId(String provider, String providerId) {
        String prefix = "GOOGLE_".equalsIgnoreCase(provider) ? "GOOGLE_" : "KAKAO_";
        String raw = prefix + providerId;
        if (raw.length() <= 20) return raw;
        String digest = SocialUserIdHasher.hash(providerId);
        return prefix + digest.substring(0, Math.max(0, 20 - prefix.length()));
    }

    private void authenticateUser(HttpServletRequest request, String userId) {
        UserDetails userDetails = customUserDetailsService.loadUserByUsername(userId);
        UsernamePasswordAuthenticationToken authentication =
            new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication);
        request.getSession().setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, SecurityContextHolder.getContext());
    }

    private String redirectByRole(String role) {
        return "ROLE_OWNER".equals(role) ? "redirect:/member/mypage" : "redirect:/";
    }

    private void sendTempPasswordEmail(String email, String tempPassword) {
        String title = getMessage("mail.temp_password.subject", null, "Gourmet 임시 비밀번호 안내입니다.");
        String content = getMessage("mail.temp_password.body", null, "임시 비밀번호는 <b>{0}</b> 입니다.<br>로그인 후 반드시 비밀번호를 변경해주세요.");
        content = content.replace("{0}", tempPassword);
        sendEmail(email, title, content);
    }

    private void sendEmail(String email, String title, String content) {
        String setFrom = "boardexample114@gmail.com";
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
            helper.setFrom(setFrom);
            helper.setTo(email);
            helper.setSubject(title);
            helper.setText(content, true);
            mailSender.send(message);
        } catch (Exception e) {
            log.error("메일 전송 실패: " + e.getMessage());
        }
    }

    private String getMessage(String code, Object[] args, String defaultMessage) {
        return messageSource.getMessage(code, args, defaultMessage, LocaleContextHolder.getLocale());
    }

    private String validateUserInput(MemberVO vo, boolean requirePassword) {
        if (!MemberValidation.isValidUserId(vo.getUser_id())) return "아이디는 영문/숫자/언더바 4~20자만 가능합니다.";
        if (requirePassword) {
            if (!MemberValidation.isValidPassword(vo.getUser_pw())) return "비밀번호는 영문/숫자/특수문자를 포함한 8~20자여야 합니다.";
        } else if (vo.getUser_pw() != null && !vo.getUser_pw().trim().isEmpty()) {
            if (!MemberValidation.isValidPassword(vo.getUser_pw())) return "비밀번호는 영문/숫자/특수문자를 포함한 8~20자여야 합니다.";
        }
        return null;
    }
}