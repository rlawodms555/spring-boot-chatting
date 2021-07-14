package com.example.chat.vo;

import java.util.Date;

import lombok.Data;

@Data
public class Msg {

	private int msgNo;	// no로 바꿀지는 나중에 보자
	private int userNo;
	private int roomNo;
	private String content;
	private Date createdDate;
}
