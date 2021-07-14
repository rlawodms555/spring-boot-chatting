package com.example.chat.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.chat.dao.RoomDao;
import com.example.chat.vo.Room;

@Service
public class RoomServiceImpl implements RoomService {

	@Autowired
	RoomDao roomDao;
	
	@Override
	public void insertRoom(Room room) {
		roomDao.insertRoom(room);
	}
	
	@Override
	public List<Room> getAllRooms() {
		return roomDao.getAllRooms();
	}
}
