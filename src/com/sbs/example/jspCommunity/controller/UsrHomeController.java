package com.sbs.example.jspCommunity.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sbs.example.jspCommunity.container.Container;
import com.sbs.example.jspCommunity.service.AttrService;

public class UsrHomeController extends Controller{
	public String showMain(HttpServletRequest req, HttpServletResponse resp) {
		return "usr/home/main";
	}
}
