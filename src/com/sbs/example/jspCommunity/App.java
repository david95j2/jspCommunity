
package com.sbs.example.jspCommunity;

public class App {
	public static boolean isProductMode() {
		
		// 톰캣안에서 spring.profiles.active 변수를 받아옴 cf). 정해진 변수 이름 아님!
		String profilesActive = System.getProperty("spring.profiles.active");
		
		if (profilesActive == null ) {
			return false;
		}
		
		// production 변수가 톰캣안에 있을 시 개발모드로 설정하겠다.
		if (profilesActive.equals("production") == false) {
			return false;
		}
		
		return true;
	}

	public static String getSiteName() {
		return "Chillax";
	}

	public static String getContextName() {
		if (isProductMode()) {
			return "";
		}
		
		return "jspCommunity";
	}

	public static String getMainUrl() {
		return getAppUrl();
	}

	public static String getLoginUrl() {
		return getAppUrl() + "/usr/member/login";
	}
	
	public static String getAppUrl() {
		String appUrl = getSiteProtocol() + "://" + getSiteDomain();

		if (getSitePort() != 80 && getSitePort() != 443) {
			appUrl += ":" + getSitePort();
		}
		
		if (getContextName().length() > 0) {
			appUrl += "/" + getContextName();
		}
		
		return appUrl;
	}
	
	private static String getSiteProtocol() {
		if (isProductMode()) {
			return "https";
		}
		
		return "http";
	}

	private static int getSitePort() {
		if (isProductMode()) {
			return 443;
		}
		
		return 8080;
	}

	private static String getSiteDomain() {
		if (isProductMode()) {
			return "chillax.yadah.kr";
		}
		
		return "localhost";
	}
}