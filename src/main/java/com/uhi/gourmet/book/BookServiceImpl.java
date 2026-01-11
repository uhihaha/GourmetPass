package com.uhi.gourmet.book;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class BookServiceImpl implements BookService {

    @Autowired
    private BookMapper book_mapper;

    // v1.0.3 결제 스위치: true면 결제 검증 없이 DB 저장
    private boolean is_debug_mode = true;

    @Override
    public void register_book(BookVO vo) {
        if (is_debug_mode) {
            System.out.println("DEBUG: 결제 검증 스위치 ON - 예약 바로 진행");
        }
        book_mapper.insertBook(vo);
    }

    @Override
    public List<BookVO> get_my_book_list(String user_id) {
        return book_mapper.selectMyBookList(user_id);
    }

    @Override
    public List<BookVO> get_store_book_list(int store_id) {
        return book_mapper.selectStoreBookList(store_id);
    }

    @Override
    public void update_book_status(int book_id, String status) {
        book_mapper.updateBookStatus(book_id, status);
    }
}