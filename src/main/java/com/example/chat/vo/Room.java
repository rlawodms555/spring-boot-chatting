package com.example.chat.vo;

import java.util.Date;

import lombok.Data;

@Data
public class Room {

	private int roomNumber;	// 나중에 no로 변경해야지
	private int userNo;
	private String roomName;	// 나중에 name으로 변경할 수도
	private Date createdDate;
}
