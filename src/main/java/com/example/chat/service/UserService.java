package com.example.chat.service;

import org.springframework.transaction.annotation.Transactional;

import com.example.chat.vo.User;

@Transactional
public interface UserService {

	void insertUser(User user);
}
