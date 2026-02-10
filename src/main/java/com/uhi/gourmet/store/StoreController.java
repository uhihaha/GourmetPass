/* com/uhi/gourmet/store/StoreController.java */
package com.uhi.gourmet.store;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.github.pagehelper.PageInfo;
import com.uhi.gourmet.book.BookService;
import com.uhi.gourmet.member.MemberService;
import com.uhi.gourmet.member.MemberVO;
import com.uhi.gourmet.photo.PhotoService;
import com.uhi.gourmet.photo.PhotoVO;
import com.uhi.gourmet.review.ReviewService;
import com.uhi.gourmet.review.ReviewVO;
import com.uhi.gourmet.wait.WaitService;

@Controller
@RequestMapping("/store")
public class StoreController {

    @Autowired
    private StoreService storeService;

    @Autowired
    private WaitService waitService;

    @Autowired
    private BookService bookService;
    
    @Autowired
    private MemberService memberService;

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private PhotoService photoService;

    @Value("${kakao.js.key}")
    private String kakaoJsKey;
    
    @Value("${portone.store.id}")
    private String portOneStoreId;
    @Value("${portone.channel.key}")
    private String portOneChannelKey;

    @Value("${upload.path:}")
    private String uploadPath;

    @GetMapping("/list")
    public String storeList(
            @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
            @RequestParam(value = "pageSize", defaultValue = "6") int pageSize,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "region", required = false) String region,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {
        
        PageInfo<StoreVO> pageMaker = storeService.getStoreList(pageNum, pageSize, category, region, keyword);
        for (StoreVO store : pageMaker.getList()) {
            PhotoVO thumbnail = photoService.getThumbnailByStore(store.getStore_id());
            if (thumbnail != null) {
                store.setStore_img(thumbnail.getFile_path());
            }
        }
        model.addAttribute("storeList", pageMaker.getList()); 
        model.addAttribute("pageMaker", pageMaker);
        model.addAttribute("category", category);
        model.addAttribute("region", region);
        model.addAttribute("keyword", keyword);
        
        return "store/store_list";
    }

    @GetMapping("/detail")
    public String storeDetail(@RequestParam("storeId") int storeId, Model model, Principal principal) {
        if (principal != null) {
            model.addAttribute("loginUser", memberService.getMember(principal.getName()));
        }
        
        storeService.plusViewCount(storeId);
        StoreVO store = storeService.getStoreDetail(storeId);
        if (store != null && store.getMax_capacity() < 1) {
            store.setMax_capacity(1);
        }
        model.addAttribute("currentWaitCount", waitService.get_current_wait_count(storeId));

        Map<String, Object> stats = reviewService.getReviewStats(storeId);
        if (store != null && stats != null) {
            store.setReview_cnt(stats.get("review_cnt") != null ? Integer.parseInt(String.valueOf(stats.get("review_cnt"))) : 0);
            store.setAvg_rating(stats.get("avg_rating") != null ? Double.parseDouble(String.valueOf(stats.get("avg_rating"))) : 0.0);
        }

        // [수정] PageInfo에서 첫 페이지 2개만 추출 (pageSize를 3에서 2로 변경)
        List<ReviewVO> reviewList = reviewService.getStoreReviews(storeId, 1, 2).getList();
        List<PhotoVO> photoList = photoService.getPhotosByStore(storeId);
        
        model.addAttribute("store", store);
        model.addAttribute("menuList", storeService.getMenuList(storeId));
        model.addAttribute("reviewList", reviewList);
        model.addAttribute("photoList", photoList);
        model.addAttribute("kakaoJsKey", kakaoJsKey);
        model.addAttribute("portOneStoreId", portOneStoreId);
        model.addAttribute("portOneChannelKey", portOneChannelKey);
        model.addAttribute("canWriteReview", (principal != null) && reviewService.checkReviewEligibility(principal.getName(), storeId));
        
        return "store/store_detail";
    }
    
    @GetMapping("/reviews")
    public String allReviews(@RequestParam("store_id") int storeId, Model model) {
        model.addAttribute("store", storeService.getStoreDetail(storeId));
        model.addAttribute("allReviews", reviewService.getStoreReviews(storeId, 1, 10).getList());
        return "store/store_reviews";
    }
    
    @GetMapping(value = "/api/timeSlots", produces = "application/json; charset=UTF-8")
    @ResponseBody 
    public List<String> getTimeSlots(@RequestParam("store_id") int storeId, @RequestParam("book_date") String bookDate) {
        return storeService.getAvailableTimeSlots(storeService.getStoreDetail(storeId), bookDate);
    }

    @PostMapping("/wait/updateStatus")
    public String updateWaitStatus(@RequestParam("wait_id") int waitId, @RequestParam("status") String status, @RequestParam("user_id") String userId) {
        waitService.update_wait_status(waitId, status);
        messagingTemplate.convertAndSend("/topic/wait/" + userId, status);
        return "redirect:/book/manage"; 
    }

    @GetMapping("/register")
    public String registerStorePage() { return "store/store_register"; }

    @PostMapping("/register")
    public String registerStoreProcess(@ModelAttribute StoreVO vo, @RequestParam(value="file", required=false) MultipartFile file, HttpServletRequest request, Principal principal) {
        if (vo.getStore_id() <= 0) {
            vo.setStore_id(storeService.getNextStoreId());
        }
        if (file != null && !file.isEmpty()) {
            String savedName = buildStoredFileName(principal, "store_img", vo.getStore_id(), file);
            vo.setStore_img(storeService.uploadFile(file, resolveUploadPath(), savedName));
        }
        storeService.registerStore(vo, principal.getName());
        return "redirect:/member/mypage";
    }

    @GetMapping("/update")
    public String updateStorePage(@RequestParam("store_id") int storeId, Model model, Principal principal) {
        StoreVO store = storeService.getMyStore(storeId, principal.getName());
        if (store == null) return "redirect:/member/mypage";
        model.addAttribute("store", store);
        return "store/store_update";
    }

    @PostMapping("/update")
    public String updateStoreProcess(@ModelAttribute StoreVO vo,
                                     @RequestParam(value="file", required=false) MultipartFile file,
                                     HttpServletRequest request,
                                     Principal principal,
                                     RedirectAttributes rttr) {
        if (file != null && !file.isEmpty()) {
            String savedName = buildStoredFileName(principal, "store_img", vo.getStore_id(), file);
            vo.setStore_img(storeService.uploadFile(file, resolveUploadPath(), savedName));
        }
        try {
            storeService.modifyStore(vo, principal.getName());
        } catch (RuntimeException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/store/update?store_id=" + vo.getStore_id();
        }
        return "redirect:/member/mypage";
    }

    @GetMapping("/menu/register")
    public String menuRegisterPage(@RequestParam("store_id") int storeId, Model model, Principal principal) {
        if (storeService.getMyStore(storeId, principal.getName()) == null) return "redirect:/member/mypage";
        model.addAttribute("store_id", storeId);
        return "store/menu_register";
    }

    @PostMapping("/menu/register")
    public String menuRegisterProcess(@ModelAttribute MenuVO menuVO,
                                      @RequestParam(value="file", required=false) MultipartFile file,
                                      HttpServletRequest request,
                                      Principal principal,
                                      RedirectAttributes rttr) {
        if (principal == null) {
            return "redirect:/member/login";
        }
        if (menuVO.getMenu_id() <= 0) {
            menuVO.setMenu_id(storeService.getNextMenuId());
        }
        if (file != null && !file.isEmpty()) {
            String savedName = buildStoredFileName(principal, "menu_img", menuVO.getMenu_id(), file);
            menuVO.setMenu_img(storeService.uploadFile(file, resolveUploadPath(), savedName));
        }
        try {
            storeService.addMenu(menuVO, principal.getName());
        } catch (RuntimeException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/store/menu/register?store_id=" + menuVO.getStore_id();
        }
        return "redirect:/member/mypage"; 
    }

    @PostMapping("/menu/delete")
    public String deleteMenu(@RequestParam("menu_id") int menuId, Principal principal) {
        storeService.removeMenu(menuId, principal.getName());
        return "redirect:/member/mypage";
    }
    
    @GetMapping("/menu/update")
    public String menuUpdatePage(@RequestParam("menu_id") int menuId, Model model, Principal principal) {
        MenuVO menu = storeService.getMenuDetail(menuId, principal.getName());
        if (menu == null) return "redirect:/member/mypage";
        model.addAttribute("menu", menu);
        return "store/menu_update";
    }
    
    @PostMapping("/menu/update")
    public String menuUpdateProcess(@ModelAttribute MenuVO vo, @RequestParam(value="file", required=false) MultipartFile file, HttpServletRequest request, Principal principal) {
        if (file != null && !file.isEmpty()) {
            String savedName = buildStoredFileName(principal, "menu_img", vo.getMenu_id(), file);
            vo.setMenu_img(storeService.uploadFile(file, resolveUploadPath(), savedName));
        }
        storeService.modifyMenu(vo, principal.getName());
        return "redirect:/member/mypage";
    }

    private String buildStoredFileName(Principal principal, String type, int id, MultipartFile file) {
        String userId = (principal != null && principal.getName() != null) ? principal.getName() : "user";
        String extension = extractFileExtension(file.getOriginalFilename());
        return userId + "_" + type + "_" + id + extension;
    }

    private String extractFileExtension(String fileName) {
        if (fileName == null) {
            return "";
        }
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(dotIndex);
    }

    private String resolveUploadPath() {
        if (uploadPath == null || uploadPath.trim().isEmpty()) {
            throw new IllegalStateException("upload.path 설정이 필요합니다.");
        }
        return uploadPath.trim();
    }
}
