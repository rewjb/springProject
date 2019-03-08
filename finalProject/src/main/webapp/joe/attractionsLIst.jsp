<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
// session.setAttribute("mid", "temp");
%>
<link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR" rel="stylesheet">	

<!--   <!-- Bootstrap core CSS --> 
<!--   <link href="/springProject/resources/bootstrap/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet"> -->
<!--   <!-- Custom styles for this template --> 
<!--   <link href="/springProject/resources/bootstrap/css/modern-business.css" rel="stylesheet"> -->
<!--   <!-- Bootstrap core JavaScript --> 
<!--   <script src="/springProject/resources/bootstrap/vendor/jquery/jquery.min.js"></script> -->
<!--   <script src="/springProject/resources/bootstrap/vendor/bootstrap/js/bootstrap.bundle.min.js"></script> -->

<!--제이쿼리-->
<script type="text/javascript" src="/springProject/resources/JS/jquery.min.js"></script>
<style type="text/css">

{
   font-family: 'Noto Sans KR', sans-serif;
}

img{ width: 300px;} 

h3 {
    color: white;
    text-shadow:
    -1px -1px 0 #000,
    1px -1px 0 #000,
    -1px 1px 0 #000,
    1px 1px 0 #000;  
}

#div1 {
position: relative;
height:600px;
width: 850px;
text-align: center;
vertical-align: middle;

}

#div1:after {
	background-image: url('/springProject/resources/IMAGE/banner4.jpg');
    top:0;
    left:0;
    position:absolute;
    background-size:100%;
    opacity:0.3!important;
    filter:alpha(opacity=50);
    z-index:-1;
    content:"";
    width: 100%;
    height: 100%;
    border-radius: 1.0rem;
}
    
.carousel-item {
	width: auto;
	height: 100%;
	max-width: 700px; 
	max-height: 500px;
	background-size: cover;
}

</style>

<script type="text/javascript">

// window.onload = function () {
// 	if (window.performance.navigation.type==2) {
// 		window.location.reload();
// 	}
// }

function deleteCart(event) {
	var deleteBtn = event.target;
// 	alert(deleteBtn.value);
	
	$.ajax({ 
	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
	         Type : "POST",
	         success : function(result) {
	        	 for (var i = 0; i < result.length; i++) {
	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-secondary my-2");
				}
	        	 $.ajax({
	        			url : "cartDelete?pid="+deleteBtn.value + "&mid=" + '<%=session.getAttribute("mid")%>',
	        			Type : "POST",
	        			success : function(result) {
	        				$("#cartTable").empty();
	        				$("#cartTable").append(result);
	        		       
	        				$.ajax({ 
	        			         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
	        			         Type : "POST",
	        			         success : function(result) {
	        			        	 for (var i = 0; i < result.length; i++) {
	        			        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
	        						}
	        			         }
	        			      });
	        			}//success끝
	        		})//ajax끝
	         }
	      });
}  

function cart(event) {//장바구니 버튼 클릭시 
	   
	var cart = event.target;
	if ($(cart).attr("class") == "btn btn-secondary my-2") {
		$(cart).attr("class", "btn btn-primary my-2");	

		 var val =  "#"+$(cart).attr("value");
// 		alert("insert val : "+val);
		
		var data = $(val).serialize();
// 		alert("insert data : "+data);
		$.ajax({
			url : "cartInsert",
			Type : "POST",
			data : data,
			success : function(result) {
// 				alert(result);
				$("#cartTable").empty();
				$("#cartTable").append(result);
			}//success끝
		})//ajax끝
	}else if ($(cart).attr("class") == "btn btn-primary my-2") {//장바구니 취소 하는 ajax 인데 mid pid 둘 다 매개변수로 받아서 처리해야한다.
		$(cart).attr("class", "btn btn-secondary my-2");
		var val =  "#"+$(cart).attr("value");
// 		alert(val);
		var data = $(val).serialize();
// 		alert(data);
		$.ajax({
			url : "cartDelete",
			Type : "POST",
			data : data,
			success : function(result) {
// 				alert(result);ss
				$("#cartTable").empty();
				$("#cartTable").append(result);
			}//success끝
		})//ajax끝 
	}		
}

$(document).ready(function start() {
	
   var continent = "<%=session.getAttribute("continent") %>"
   var city = "<%=session.getAttribute("city") %>"
   var tag = "<%=session.getAttribute("tag") %>"
   var page = "<%=request.getParameter("page") %>"
   
	if (page=="null" ) {
      $.ajax({ 
         url : "allList?page=null" ,
         Type : "POST",
         success : function(result) {
               $("#container").append(result);
               var offset = $("#div").offset();
		        $('html, body').animate({scrollTop : offset.top}, 400);
               if ( '<%= session.getAttribute("mid") %>' != "null") {
            		 $.ajax({ 
            	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
            	         Type : "POST",
            	         success : function(result) {
            	        	 for (var i = 0; i < result.length; i++) {
//             	        		 alert(result[i].pid);
            	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
							}
            	         }
            	      });
            	   }
         }
      });
	}
  
	if (page !="null") {
// 		alert("2");
   $.ajax({ 
       url : "allList?page=" + '<%=request.getParameter("page") %>',
       Type : "POST",
       success : function(result) {
             $("#container").append(result);
             var offset = $("#div").offset();
		        $('html, body').animate({scrollTop : offset.top}, 400);
             if ( '<%= session.getAttribute("mid") %>' != "null") {
        		 $.ajax({ 
        	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
        	         Type : "POST",
        	         success : function(result) {
        	        	 for (var i = 0; i < result.length; i++) {
        	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
						}
        	         }
        	      });
        	   }
       }
    });
	}
   
   if (continent != "null" && city != "null"  && tag != "null") {
// 	   alert("3");
	   $.ajax({ 
	         url : "pageList?page="+<%= request.getParameter("page")%> + "&continent=" + continent + "&city=" + city + "&category=" + tag,
	         Type : "POST",
	         success : function(result) {
	        	 $("#container").empty();
	               $("#container").append(result);
	               var offset = $("#div").offset();
			        $('html, body').animate({scrollTop : offset.top}, 400);
	               if ( '<%= session.getAttribute("mid") %>' != "null") {
	            		 $.ajax({ 
	            	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
	            	         Type : "POST",
	            	         success : function(result) {
	            	        	 for (var i = 0; i < result.length; i++) {
	            	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
								}
	            	         }
	            	      });
	            	   }
	         }
	      });
	   
	}else if (continent != "null" && city != "null" && tag == "null") {
// 		 alert("4");
		$.ajax({ 
	         url : "pageList?page="+<%= request.getParameter("page")%> + "&continent=" + continent + "&city=" + city,
	         Type : "POST",
	         success : function(result) {
	        	 $("#container").empty();
	             $("#container").append(result);
	             var offset = $("#div").offset();
			        $('html, body').animate({scrollTop : offset.top}, 400);
	             if ( '<%= session.getAttribute("mid") %>' != "null") {
            		 $.ajax({ 
            	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
            	         Type : "POST",
            	         success : function(result) {
            	        	 for (var i = 0; i < result.length; i++) {
            	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
							}
            	         }
            	      });
            	   }
	         }
	      });
		 
	}else if (continent != "null" && city == "null" && tag == "null") {
// 		 alert("5");
		$.ajax({ 
	         url : "pageList?page="+<%= request.getParameter("page")%>+"&continent=" +continent,
	         Type : "POST",
	         success : function(result) {
	        	 $("#container").empty();
	             $("#container").append(result);
	             var offset = $("#div").offset();
			        $('html, body').animate({scrollTop : offset.top}, 400);
	             if ( '<%= session.getAttribute("mid") %>' != "null") {
            		 $.ajax({ 
            	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
            	         Type : "POST",
            	         success : function(result) {
//             	        	 alert(result[0].pid);
            	        	 for (var i = 0; i < result.length; i++) {
            	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
							}
            	         }
            	      });
            	   }
	         }
	      });
	} 
   
   if ( '<%= session.getAttribute("mid") %>' != "null") {
	 $.ajax({ 
         url : "midCartList?mid="+ '<%= session.getAttribute("mid") %>',
         Type : "POST",
         success : function(result) {
//         	 alert(result);
        	 $("#cartTable").empty();
             $("#cartTable").append(result);
         }
      });
   }
   
   
   if ('<%=session.getAttribute("text")%>' != 'null') {
	   $.ajax({ 
	         url : "search?text="+ '<%=session.getAttribute("text")%>' + "&page=" + '<%= request.getParameter("page")%>',
	         Type : "POST",
	         success : function(result) {
	        	 $("#container").empty();
	             $("#container").append(result);
	             var offset = $("#div").offset();
			        $('html, body').animate({scrollTop : offset.top}, 400);
	             if ( '<%= session.getAttribute("mid") %>' != "null") {
            		 $.ajax({ 
            	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
            	         Type : "POST",
            	         success : function(result) {
            	        	 for (var i = 0; i < result.length; i++) {
            	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
							}
            	         }
            	      });
            	   }
	         }
	      }); 
	}
   
})//ready 끝
 
var arr = new Array();
arr = ["아시아" , "동남아시아" , "유럽" , "미주" , "남태평양" , "대한민국"];
  
var count2  = 0;
$(function () {
	
   if (count2 == 0) {
	   
      for (var i = 0; i < arr.length; i++) {
         $("#continentList").append($("<button name = '1' class='btn btn-secondary my-2' onclick = 'continent(event)'>" + arr[i] +  "</button>"));  
      }
   }count2 +=1
  var continent = "<%=session.getAttribute("continent") %>"
  var city = "<%=session.getAttribute("city") %>"
  var tag = "<%=session.getAttribute("tag") %>"
  
//   alert(continent);
//   alert(city);
//   alert(tag);
  
	if (continent != "null" && city == "null" && tag == "null") {
			var list = new Array();
			list = document.getElementsByName("1");
			for (var i = 0; i < list.length; i++) {
				if (list[i].innerHTML == continent) {
					list[i].setAttribute("class", "btn btn-primary my-2");
				}
			}

		} else if (continent != "null" && city != "null" && tag == "null") {
			$.ajax({
				url : "tagCon",
				Type : "POST",
				data : "tag=" + continent,
				success : function(result) {
					$("#city").append(result);
					var list = new Array();
					list = document.getElementsByName("1");
					for (var i = 0; i < list.length; i++) {
						if (list[i].innerHTML == continent) {
							list[i].setAttribute("class",
									"btn btn-primary my-2");
						}
					}
					list = document.getElementsByName("2");

					for (var i = 0; i < array.length; i++) {
						list[i].setAttribute("class", "btn btn-primary my-2");
					}

				}
			});

		} else if (continent != "null" && city != "null" && tag != "null") {

		}
	})

	function continent(event) {
		var con = event.target;
		if ($(con).attr("class") == "btn btn-secondary my-2") {

			$("#city").empty();
			$("#tag").empty();
			$("button[name=1]").attr("class", "btn btn-secondary my-2");
			$("button[name=1]").attr("id", "");

			$(con).attr("class", "btn btn-primary my-2");
			$(con).attr("id", "1");

			var temp2 = $(con).text();
			$.ajax({
				url : "tagCon",
				Type : "POST",
				data : "tag=" + temp2,
				success : function(result) {
					$("#city").append(result);
				}
			});

		} else if ($(con).attr("class") == "btn btn-primary my-2") {
			$("#city").empty();
			$("#tag").empty();
			$(con).attr("class", "btn btn-secondary my-2");
		}
	}

	function city(event) {
		var con = event.target;

		if ($(con).attr("class") == "btn btn-secondary my-2") {

			$("#tag").empty();
			$("button[name=2]").attr("class", "btn btn-secondary my-2");
			$("button[name=2]").attr("id", "");

			$(con).attr("class", "btn btn-primary my-2");
			$(con).attr("id", "2");
			var temp2 = $(con).text();
			$.ajax({
				url : "tagCity",
				Type : "POST",
				data : "tag=" + temp2,
				success : function(result) {
					$("#tag").append(result);
				}
			});

		} else if ($(con).attr("class") == "btn btn-primary my-2") {
			$("#tag").empty();
			$("button[name=2]").attr("id", "");
			$(con).attr("class", "btn btn-secondary my-2");

		}
	}

	function tag(event) {
		var con = event.target;

		if ($(con).attr("class") == "btn btn-secondary my-2") {

			$("button[name=tag]").attr("class", "btn btn-secondary my-2");
			$("button[name=tag]").attr("id", "");
			$(con).attr("class", "btn btn-primary my-2");
			$(con).attr("id", "3");

		} else if ($(con).attr("class") == "btn btn-primary my-2") {
			$("button[name=tag]").attr("id", "");
			$(con).attr("class", "btn btn-secondary my-2");
		}
	}

	function tagSearch() {

		var con = $("button[id=1]").text();
		var city = $("button[id=2]").text();
		var tag = $("button[id=3]").text();

		$.ajax({
			url : "attList?page=null",
			Type : "POST",
			data : "continent=" + con + "&city=" + city + "&category=" + tag,
			success : function(result) {
				$("#container").empty();
				$("#container").append(result);
				var offset = $("#div").offset();
				$('html, body').animate({scrollTop : offset.top}, 400);
					
				
				if ('<%=session.getAttribute("mid")%>' != "null"){
	            		 $.ajax({ 
	            	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
	            	         Type : "POST",
	            	         success : function(result) {
	            	        	 for (var i = 0; i < result.length; i++) {
	            	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
								}
	            	         }  
	            	      });
	            	   }
				//현재 주소를 가져온다.
				var renewURL = location.href;
				//현재 주소 중 page 부분이 있다면 날려버린다.
				renewURL = renewURL.replace(/\?page=([0-9]+)/ig, '');

				//새로 부여될 페이지 번호를 할당한다.
				// page는 ajax에서 넘기는 page 번호를 변수로 할당해주거나 할당된 변수로 변경
				//페이지 갱신 실행!
				history.pushState(null, null, renewURL);

			}
		});
	}
	
	function enter() {//엔터키 입력시 동작함수
		if (window.event.keyCode == 13) {
			var text = $("#search").val();
			  var trimStr = $.trim(text) ;
			  if (trimStr.length != 0) {
			 $.ajax({
					url : "search?text="+text + "&page=null",
					Type : "POST",
					success : function(result) {
						$("#container").empty();
						$("#container").append(result);
						var offset = $("#div").offset();
				        $('html, body').animate({scrollTop : offset.top}, 400);
						    if ( '<%= session.getAttribute("mid") %>' != "null") {
			            		 $.ajax({ 
			            	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
			            	         Type : "POST",
			            	         success : function(result) {
			            	        	 for (var i = 0; i < result.length; i++) {
			            	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
										}
			            	         }
			            	      });
			            	   }
					}
				});
			  }else{
				  alert("검색 내용을 입력해주세요");
			  }
		}
	}
	function search() {//검색버튼 클릭시 동작 함수
			var text = $("#search").val();
			var trimStr = $.trim(text) ;
			if (trimStr.length != 0) {
			 $.ajax({
					url : "search?text="+text + "&page=null",
					Type : "POST",
					success : function(result) {
						$("#container").empty();
						$("#container").append(result);
						var offset = $("#div").offset();
				        $('html, body').animate({scrollTop : offset.top}, 400);
					     if ( '<%= session.getAttribute("mid") %>' != "null") {
		            		 $.ajax({ 
		            	         url : "midCart?mid="+ '<%= session.getAttribute("mid") %>',
		            	         Type : "POST",
		            	         success : function(result) {
		            	        	 for (var i = 0; i < result.length; i++) {
		            	        		$("button[value="+result[i].pid+"]").attr("class","btn btn-primary my-2");
									}
		            	         }
		            	      });
		            	   }
					}
				});
		}else{
			alert("검색 내용을 입력해주세요");
		}
	}
	
	function reset() {
		
		 $.ajax({ 
	         url : "reset",
	         Type : "POST",
	         success : function(result) {
	     			//현재 주소를 가져온다.
					var renewURL = location.href;
					//현재 주소 중 page 부분이 있다면 날려버린다.
					renewURL = renewURL.replace(/\?page=([0-9]+)/ig, '');

					//새로 부여될 페이지 번호를 할당한다.
					// page는 ajax에서 넘기는 page 번호를 변수로 할당해주거나 할당된 변수로 변경
					//페이지 갱신 실행!
					history.pushState(null, null, renewURL);
	        	
					location.reload();//페이지 새로고침
				}
	      });
	}
	
	
</script>
</head>
<body>
   <%@ include file="/UserMainHeader.jsp"%>
    <!--해더랑 리스트랑 공간  어차피  jstl for문을 통해서 구현할곳  -->
   
      <div style="margin-left: 50px; position: fixed;">
				<h2 style="font-family: 'Jua', sans-serif;">장바구니</h2>
			</div>
		<div style="width: 180px; height: 500px; margin-left: 40px; margin-top: 65px; position: fixed; overflow: auto;" id="cartTable">
		
		</div>
   <div class = "container marketing" style="text-align: center;">
   
   	  <div id="div1" style="display: inline-block;"> 
	  <h2 style="font-family: 'Jua', sans-serif; display: inline-block; margin-top: 16px; text-align: center;">너님이 좋아할만한 여행지</h2>
	  <br>
  <header style="display: inline-block;">
    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
      <ol class="carousel-indicators">
        <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
      </ol>
      <div class="carousel-inner" role="listbox" style="width: 700px; height: 500px;">
        <div class="carousel-item active" style="background-image: url('/springProject/resources/IMAGE/attractionsImg/${recommend.get(0).getMainImg()}')">
          <div class="carousel-caption d-none d-md-block">
            <h3>${recommend.get(0).getTitle()}</h3>
            <p>${recommend.get(0).getContent()}</p>
          </div>
        </div>
        <div class="carousel-item" style="background-image: url('/springProject/resources/IMAGE/attractionsImg/${recommend.get(1).getMainImg()}')">
          <div class="carousel-caption d-none d-md-block">
            <h3>${recommend.get(1).getTitle()}</h3>
            <p>${recommend.get(1).getContent()}</p>
          </div>
        </div>
        <div class="carousel-item" style="background-image: url('/springProject/resources/IMAGE/attractionsImg/${recommend.get(2).getMainImg()}')">
          <div class="carousel-caption d-none d-md-block">
            <h3>${recommend.get(2).getTitle()}</h3>
            <p>${recommend.get(2).getContent()}</p>
          </div>
        </div>
      </div>
      <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
      </a>
      <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
      </a>
    </div>
  </header>
	  </div>
	</div>
	  <br>
	  
   <div class = "container marketing" id = "div">
   <nav class="navbar navbar-dark bg-dark"> 
   <button class="navbar-toggler collapsed" type="button" data-toggle="collapse" data-target="#navbarsExample01" aria-controls="navbarsExample01" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span><span class="navbar-brand" >조건검색</span>
  </button>
    <div class="form-inline my-2 my-md-0">
    	<span class="navbar-brand">검색</span>
    	<input class="form-control" type="text" placeholder="Search" aria-label="Search" id = "search" onkeypress="enter()" style="margin-right: 0;">
		   <input class="btn btn-secondary my-2" type="button"  value="검색" onclick="search()" style="margin-left: 10px;"> 
   <input class="btn btn-secondary my-2" type="button"  value="초기화" onclick="reset()" style="margin-left: 10px;"> 
    </div>
   <div class="collapse navbar-collapse" id="navbarsExample01">
      <ul class="navbar-nav mr-auto">
         <li class="navbar-brand"><label>대륙</label> 
            <div style="height: 80px; width: 1080px; overflow : auto;" id = "continentList">  
            </div>  
         </li>
         <li class="navbar-brand"><label>도시</label>
             <div style="overflow-x : auto; height: 80px; width: 1080px;" id = "city">
             </div>
         </li>
         <li class="navbar-brand"><label>태그</label>
            <div style="overflow-x : auto; height: 80px; width: 1080px;" id = "tag">
            </div>
         </li>
         <li><button id ="searchBtn" class="btn btn-secondary my-2" style="text-align: center; width: 1080px;" onclick="tagSearch()">검색</button></li>
      </ul>
   </div>
   </nav>
</div>
  <br>
   <!--  모든 리스트   -->
   <div class="container marketing" id = "container" >
   </div>
   </body>
</html>