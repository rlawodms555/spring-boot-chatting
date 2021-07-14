package com.example.chat.dao;

import org.apache.ibatis.annotations.Mapper;

import com.example.chat.vo.User;

@Mapper
public interface UserDao {

	void insertUser(User user);
}
