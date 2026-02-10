package com.uhi.gourmet.common;

import net.coobird.thumbnailator.Thumbnails;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;

@Service
public class ImageProcessingService {

    @Async("imageTaskExecutor")
    public void processImage(File target, int width, int height, float quality) {
        if (target == null || !target.exists()) {
            return;
        }

        try {
            Thumbnails.of(target)
                .size(width, height)
                .outputQuality(quality)
                .toFile(target);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
