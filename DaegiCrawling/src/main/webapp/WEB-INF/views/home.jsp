<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<meta charset="UTF-8">
<head>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<title>시구군별 대기오염 정보 조회 시스템</title>
</head>
<body>
<center>
<h1>시구군별 대기오염 정보 조회 시스템</h1>
<hr>
	<form id="optionForm" name="optionForm">
	<div class="container">
		<select name="option" onchange="getGu()" style="width:60%; font-size:25pt;">
		<option>도시를 선택해주세요</option>
		<option value="서울">서울</option>
		<option value="부산">부산</option>
		<option value="대구">대구</option>
		<option value="인천">인천</option>
		<option value="광주">광주</option>
		<option value="대전">대전</option>
		<option value="울산">울산</option>
		<option value="경기">경기</option>
		<option value="강원">강원</option>
		<option value="충북">충북</option>
		<option value="충남">충남</option>
		<option value="전북">전북</option>
		<option value="전남">전남</option>
		<option value="경북">경북</option>
		<option value="경남">경남</option>
		<option value="제주">제주</option>
		<option value="세종">세종</option>
		</select>
		
		<div id="gu" style="width:100%;">
		</div>
	</div>
	<input type="button" value="현재 시간 대기 오염도 검색" onClick="getInfo()" style="width:60%; font-size:25pt;"/>
	</form>
	</center>
	<div id="daegi_info">
	${guSize}
	</div>
	
<script>
	function getGu(){
		$.ajax({
			type:'GET',
			url: "<c:url value='getGu'/>",
			dataType: "json",
			data : $("#optionForm").serialize(),
			contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
			success: function(data){
				var html = "<select id='guOption' name='guOption' style='width:60%; font-size:25pt;'>";
				html += "<option placeholder=''>도시를 선택해주세요</option>";
				for(i=0; i<data.length; i++){
					html += "<option value='";
					html += i;
					html += "'>";
					html += data[i];
					html += "</option>";
				}
				html += "</select>";
				html += "<input type='hidden' name='guSize' value='+";
				html += data[data.length-1];
				html += "'/>";
				
				$("#gu").html(html);
			},
			error:function(){
	            alert("error");
		       }
			});
	}

	function getInfo(inputNo){
		var pageNo = 1;
		if(inputNo != null){
			pageNo = inputNo;
		}
		$.ajax({
			type:'GET',
			url: "<c:url value='getInfo?pageNo="+ pageNo +"'/>",
			dataType: "json",
			data : $("#optionForm").serialize(),
			contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
			success: function(data){
				var html = "";
				html += "<center><table border='1'style='width:60%; font-size:25pt;margin-bottom:20pt;'><tr><td>cityName</td> <td>dataTime</td> <td>so2Value</td> <td>coValue</td> <td>no2Value</td> <td>pm10Value</td></tr>";
				html += "<tr><td>" + data[0] + "</td>";
				html += "<td>" + data[1] + "</td>";
				html += "<td>" + data[2] + "</td>";
				html += "<td>" + data[3] + "</td>";
				html += "<td>" + data[4] + "</td>";
				html += "<td>" + data[5] + "</td>";

				html += "</tr></table></center>";
				html += "<center><input type='button' value='이전 시간 정보 보기'onClick='preNext(1,"+data[data.length-2]+","+data[data.length-1]+")'/>";
				html += "<input type='button' value='다음 시간 정보 보기' onClick='preNext(2,"+data[data.length-2]+")'/></center>";


				$("#daegi_info").html(html);
			},
			error:function(){
	            alert("error");
		    }
		});
	}

	function preNext(order, pageNo, totalCount){
		if(order == 1){
			if((pageNo + 1) > (totalCount/pageNo)){
				alert("이전의 정보가 없습니다");
			}else{
				getInfo(pageNo + 1);
			}

		}else{
			if((pageNo - 1) == 0){
				alert("이후의 정보가 없습니다");
			}else{
				getInfo(pageNo - 1);
			}
			
		}
	}
</script>	
</body>
</html>
