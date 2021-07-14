package com.example.chat.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.chat.vo.Room;

@Mapper
public interface RoomDao {

	void insertRoom(Room room);
	List<Room> getAllRooms();
}
