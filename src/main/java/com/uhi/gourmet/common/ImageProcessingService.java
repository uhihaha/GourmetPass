package com.uhi.gourmet.common;

import net.coobird.thumbnailator.Thumbnails;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

@Service
public class ImageProcessingService {

    @Async("imageTaskExecutor")
    public void processImage(File target, int width, int height, float quality) {
        if (target == null || !target.exists()) {
            return;
        }

        try {
            File parent = target.getParentFile();
            if (parent == null) {
                return;
            }

            File temp = File.createTempFile("resize_", ".tmp", parent);
            Thumbnails.of(target)
                .size(width, height)
                .outputQuality(quality)
                .toFile(temp);

            Path targetPath = target.toPath();
            try {
                Files.move(temp.toPath(), targetPath,
                    StandardCopyOption.REPLACE_EXISTING,
                    StandardCopyOption.ATOMIC_MOVE);
            } catch (AtomicMoveNotSupportedException e) {
                Files.move(temp.toPath(), targetPath, StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
