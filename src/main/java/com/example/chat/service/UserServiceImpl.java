package com.example.chat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.chat.dao.UserDao;
import com.example.chat.vo.User;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	UserDao userDao;
	
	@Override
	public void insertUser(User user) {
		userDao.insertUser(user);
	}
}
