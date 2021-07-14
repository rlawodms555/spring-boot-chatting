package com.example.chat.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.example.chat.vo.Msg;

@Transactional
public interface MsgService {

	void insertMsg(Msg msg);
	List<Msg> getMsgForRoomNo(int roomNo);
}
