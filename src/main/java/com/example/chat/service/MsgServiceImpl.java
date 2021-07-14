package com.example.chat.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.chat.dao.MsgDao;
import com.example.chat.vo.Msg;

@Service
public class MsgServiceImpl implements MsgService {

	@Autowired
	MsgDao msgDao;
	
	@Override
	public void insertMsg(Msg msg) {
		msgDao.insertMsg(msg);
	}
	
	@Override
	public List<Msg> getMsgForRoomNo(int roomNo) {
		return msgDao.getMsgForRoomNo(roomNo);	// 어차피 List 타입 반환하니까 바로 씀
	}
}
