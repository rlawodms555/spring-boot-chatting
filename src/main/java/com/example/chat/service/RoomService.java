package com.example.chat.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.example.chat.vo.Room;

@Transactional
public interface RoomService {

	void insertRoom(Room room);
	List<Room> getAllRooms();
}
