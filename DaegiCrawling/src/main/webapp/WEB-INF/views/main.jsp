<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
  <head>
 	<meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="author" content="colorlib.com">
    <link href="https://fonts.googleapis.com/css?family=Poppins" rel="stylesheet" />
    <link href="resources/css/main.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<title>시구군별 대기오염 정보 조회 시스템</title>
  </head>
  <body>
  	<center>
	<h1>시구군별 대기오염 정보 조회 시스템</h1>
	<hr>
	</center>
	
     <form id="optionForm" name="optionForm">
       <div class="inner-form">
         <div class="input-field first-wrap">
           <div class="input-select">
             <select data-trigger="" name="option" onchange="getGu()">
                <option placeholder="">도시를 선택해주세요</option>
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
           </div>
         </div>
     </div>
	 <div class="inner-form">
	   <div class="input-field first-wrap">
	     <div class="input-select" id="gu">
		     <select data-trigger="" name="option" onchange="getGu()">
	                <option placeholder="">도시를 선택해주세요</option>
					<option value="세종">세종</option>
	         </select>
	     </div>
	   </div>
	 </div>
     </form>
     
    <div class="input-field third-wrap">
     <button class="btn-search" type="button" onClick="getInfo()">
     </button>
   	</div>
   
	<div id="daegi_info" style="position:absolute;margin-top:70px;background-color:white;">
	</div>
    <script src="resources/js/extention/choices.js"></script>
    <script>
      const choices = new Choices('[data-trigger]',
      {
        searchEnabled: false,
        itemSelectText: '',
      });

  	function getGu(){
		$.ajax({
			type:'GET',
			url: "<c:url value='getGu'/>",
			dataType: "json",
			data : $("#optionForm").serialize(),
			contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
			success: function(data){
				var html = "<select data-trigger='' id='guOption' name='guOption'>";
				html += "<option placeholder=''>도시를 선택해주세요</option>";
				for(i=0; i<data.length; i++){
					html += "<option value='";
					html += i;
					html += "'>";
					html += data[i];
					html += "</option>";
				}
				html += "</select>";
				html += "<input type='hidden' name='guSize' value='";
				html += data[data.length-1];
				html += "'/>";
				
				$("#gu").html(html);
			},
			error:function(){
	            alert("error");
		       }
			});
	}

	function getInfo(){
		$.ajax({
			type:'GET',
			url: "<c:url value='getInfo'/>",
			dataType: "json",
			data : $("#optionForm").serialize(),
			contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
			success: function(data){
				var html = "<table border='1'><tr><td>cityName</td> <td>dataTime</td> <td>so2Value</td> <td>coValue</td> <td>no2Value</td> <td>pm10Value</td></tr>";
				
				html += "<tr><td>" + data[0] + "</td>";
				html += "<td>" + data[1] + "</td>";
				html += "<td>" + data[2] + "</td>";
				html += "<td>" + data[3] + "</td>";
				html += "<td>" + data[4] + "</td>";
				html += "<td>" + data[5] + "</td>";

				html += "</tr></table>";
				
				$("#daegi_info").html(html);
			},
			error:function(){
	            alert("error");
		    }
		});
	}
    </script>
    
  </body><!-- This templates was made by Colorlib (https://colorlib.com) -->
</html>
