package com.uhi.gourmet.photo;

import com.uhi.gourmet.store.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.security.Principal;

@Controller
@RequestMapping("/photo")
public class PhotoController {

    @Autowired
    private PhotoService photoService;

    @Autowired
    private StoreService storeService;

    @Value("${upload.path:}")
    private String uploadPath;

    @PostMapping("/upload")
    public String uploadPhotos(@RequestParam("store_id") int store_id,
                               @RequestParam("files") MultipartFile[] files,
                               Principal principal,
                               HttpServletRequest request,
                               RedirectAttributes rttr) {
        if (principal == null) {
            return "redirect:/member/login";
        }

        if (files == null || files.length == 0) {
            rttr.addFlashAttribute("msg", "업로드할 사진을 선택해주세요.");
            return "redirect:/member/mypage";
        }

        int currentCount = photoService.getPhotoCountByStore(store_id);
        if (currentCount + files.length > 5) {
            rttr.addFlashAttribute("msg", "사진은 최대 5장까지만 등록할 수 있습니다.");
            return "redirect:/member/mypage";
        }

        String realPath = resolveUploadPath();
        boolean hasThumbnail = photoService.getThumbnailByStore(store_id) != null;
        boolean thumbnailSet = hasThumbnail;

        String userId = principal.getName();
        for (MultipartFile file : files) {
            if (file == null || file.isEmpty()) {
                continue;
            }
            int photoId = photoService.getNextPhotoId();
            String savedName = buildFileName(userId, "store_img", photoId, file.getOriginalFilename());
            String savedPath = storeService.uploadFile(file, realPath, savedName, "photo");
            if (savedPath == null) {
                continue;
            }

            PhotoVO vo = new PhotoVO();
            vo.setPhoto_id(photoId);
            vo.setStore_id(store_id);
            vo.setFile_path(savedPath);
            vo.setOriginal_name(file.getOriginalFilename());
            vo.setIs_active("Y");
            vo.setSort_order(0);

            if (!thumbnailSet) {
                vo.setIs_thumbnail("Y");
                thumbnailSet = true;
            } else {
                vo.setIs_thumbnail("N");
            }

            photoService.addPhoto(vo);
        }

        rttr.addFlashAttribute("msg", "사진이 등록되었습니다.");
        return "redirect:/member/mypage";
    }

    @PostMapping("/thumbnail")
    public String setThumbnail(@RequestParam("store_id") int store_id,
                               @RequestParam("photo_id") int photo_id,
                               Principal principal,
                               RedirectAttributes rttr) {
        if (principal == null) {
            return "redirect:/member/login";
        }

        photoService.activatePhoto(photo_id);
        photoService.setThumbnail(store_id, photo_id);
        rttr.addFlashAttribute("msg", "썸네일이 변경되었습니다.");
        return "redirect:/member/mypage";
    }

    @PostMapping("/delete")
    public String deletePhoto(@RequestParam("photo_id") int photo_id,
                              Principal principal,
                              RedirectAttributes rttr) {
        if (principal == null) {
            return "redirect:/member/login";
        }

        photoService.deactivatePhoto(photo_id);
        rttr.addFlashAttribute("msg", "사진이 내려졌습니다.");
        return "redirect:/member/mypage";
    }

    @PostMapping("/remove")
    public String removePhoto(@RequestParam("photo_id") int photo_id,
                              Principal principal,
                              RedirectAttributes rttr) {
        if (principal == null) {
            return "redirect:/member/login";
        }

        photoService.deletePhoto(photo_id);
        rttr.addFlashAttribute("msg", "사진이 삭제되었습니다.");
        return "redirect:/member/mypage";
    }

    @PostMapping("/activate")
    public String activatePhoto(@RequestParam("photo_id") int photo_id,
                                Principal principal,
                                RedirectAttributes rttr) {
        if (principal == null) {
            return "redirect:/member/login";
        }

        photoService.activatePhoto(photo_id);
        rttr.addFlashAttribute("msg", "사진이 다시 표시됩니다.");
        return "redirect:/member/mypage";
    }

    private String buildFileName(String userId, String type, int seq, String originalName) {
        String ext = "";
        if (originalName != null) {
            int dot = originalName.lastIndexOf('.');
            if (dot >= 0) {
                ext = originalName.substring(dot);
            }
        }
        return userId + "_" + type + "_" + seq + ext;
    }

    private String resolveUploadPath() {
        if (uploadPath == null || uploadPath.trim().isEmpty()) {
            throw new IllegalStateException("upload.path 설정이 필요합니다.");
        }
        return normalizeUploadPath(uploadPath.trim());
    }

    private String normalizeUploadPath(String path) {
        String normalized = path;
        if (normalized.startsWith("file:")) {
            normalized = normalized.substring("file:".length());
        }
        if (normalized.startsWith("//")) {
            normalized = normalized.substring(2);
        }
        if (normalized.startsWith("/") && normalized.length() > 2 && normalized.charAt(2) == ':') {
            normalized = normalized.substring(1);
        }
        return normalized;
    }
}
