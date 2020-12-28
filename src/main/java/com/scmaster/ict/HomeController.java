package com.scmaster.ict;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	// 지도를 띄우는 코드 작성
	@RequestMapping(value = "/educate01")
	public String educate01() {

		return "educate01";
	}
	
	// 지도를 띄우는 코드 작성
	@RequestMapping(value = "/educate02")
	public String educate02() {

		return "educate02";
	}
	
	// 지도를 띄우는 코드 작성
	@RequestMapping(value = "/educate03")
	public String educate03() {

		return "educate03";
	}
	
	// 지도를 띄우는 코드 작성
	@RequestMapping(value = "/educate04")
	public String educate04() {

		return "educate04";
	}
	
	// 지도를 띄우는 코드 작성
	@RequestMapping(value = "/educate05")
	public String educate05() {

		return "educate05";
	}
	
	// 지도를 띄우는 코드 작성
	@RequestMapping(value = "/educate06")
	public String educate06() {

		return "educate06";
	}
	

}
