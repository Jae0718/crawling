package com.air.pro;

import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONML;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		return "home";
	}
	
	
	@RequestMapping(value="/getGu", method = RequestMethod.GET, produces="application/json; charset=utf8")
	@ResponseBody
	public ResponseEntity getGu(Model model, HttpServletRequest request
			) throws Exception {
		HttpHeaders responseHeaders = new HttpHeaders();
		String sido_temp = request.getParameter("option");
		
		String URL = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?serviceKey=1eMy5yoN3cKR4e9wjtaw24%2FXZtFaUwZYMxFg7hLnCVGLbhvDxmqa7cj27guLnQcghFOAEHVESNTl0oT0sk7QAg%3D%3D&numOfRows=10&pageNo=1&sidoName="+ sido_temp + "&searchCondition=DAILY";
		Document doc = Jsoup.connect(URL).get();
		Elements elem = doc.select("items item cityName");
		
		HashSet<String> set = new HashSet<String>();
		for(Element e:elem) {
			set.add(e.text());
		}
		Vector<String> list = new Vector<String>();
		for(String str:set) {
			list.add(str);
		}
		Collections.sort(list);
		list.add(String.valueOf(set.size()));
		JSONArray json = new JSONArray(list);
		return new ResponseEntity(json.toString(), responseHeaders, HttpStatus.CREATED);
	}
	
	@RequestMapping(value="/getInfo", method = RequestMethod.GET, produces="application/json; charset=utf8")
	@ResponseBody
	public ResponseEntity getInfo(Model model
			,HttpServletRequest request
			,@RequestParam(value="pageNo", defaultValue="1") int pageNo
			,@RequestParam(value="guSize") int guSize
			,@RequestParam(value="option") String sido_temp
			,@RequestParam(value="guOption") int guOption)throws Exception {
		
		HttpHeaders responseHeaders = new HttpHeaders();
		System.out.println("guSize:" + guSize + "pageNo:"+pageNo+ sido_temp + guOption);
		//시간 + 정보
		//numOfRows = guSize되면 페이지마다 시간이 변경됨
		//다음 누르면 파라메타(pageNo) 변경 기본값 : 1
		
		String URL = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?serviceKey=1eMy5yoN3cKR4e9wjtaw24%2FXZtFaUwZYMxFg7hLnCVGLbhvDxmqa7cj27guLnQcghFOAEHVESNTl0oT0sk7QAg%3D%3D&";
		URL += "numOfRows=" + guSize;
		URL += "&pageNo=" + pageNo;
		URL += "&sidoName="+ sido_temp + "&searchCondition=DAILY";
		Document doc1 = Jsoup.connect(URL).get();
		Elements elems = doc1.select("items item");
		
		String[] col = {"cityName","dataTime","so2Value","coValue","no2Value","pm10Value"};
		Vector<String> list = new Vector<String>();
		
		for(String str:col) {
			String temp = String.valueOf(elems.get(guOption).select(str));
			list.add(temp);
		}
		list.add(String.valueOf(pageNo));
		
		Document doc2 = Jsoup.connect(URL).get();
		Elements totalCount_elems = doc2.select("totalCount");
		System.out.println(String.valueOf(totalCount_elems.get(0).text()).toString());
		list.add(String.valueOf(totalCount_elems.get(0).text()).toString());
		
		JSONArray jsonList = new JSONArray(list);
		
		return new ResponseEntity(jsonList.toString(), responseHeaders, HttpStatus.CREATED);
	}
}
