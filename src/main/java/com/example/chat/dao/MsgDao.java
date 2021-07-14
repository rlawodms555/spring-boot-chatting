package com.example.chat.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.chat.vo.Msg;

@Mapper
public interface MsgDao {

	void insertMsg(Msg msg);
	List<Msg> getMsgForRoomNo(int roomNo);
}
