%-- trimDirectiveWhitespaces 是 JSP 2.1 以后的,tomcat 6 之前有问题 --%
%@ tag isELIgnored=false pageEncoding=UTF-8 body-content=empty description=分页 trimDirectiveWhitespaces=true %
%@ attribute name=pageParam type=java.lang.String required=false description=当前页码参数名称 %
%@ attribute name=totalPages type=java.lang.Integer required=true description=总页码 %
%@ attribute name=sliderSize type=java.lang.Integer required=false description=分页滑块宽度 %
%@ attribute name=skip type=java.lang.Boolean required=true description=是否显示跳转输入 %
%@ attribute name=escape type=java.lang.Boolean required=false description=是否转义XML特殊字符 %
%@ attribute name=preText type=java.lang.String required=false description=上一页文字 %
%@ attribute name=nextText type=java.lang.String required=false description=下一页文字 %
%@ attribute name=goText type=java.lang.String required=false description=跳转文字 %
%--%@ attribute name=preText type=java.lang.String required=false description=上一页文本 %--%
%--%@ attribute name=nextText type=java.lang.String required=false description=下一页文本 %--%
%--%@ attribute name=goText type=java.lang.String required=false description=跳转页码文本 %--%
%@ taglib prefix=c uri=httpjava.sun.comjspjstlcore %
%@ taglib prefix=fn uri=httpjava.sun.comjspjstlfunctions %
cset var=pageParam value=${not empty pageParam  pageParam  'page'}  %-- 页码参数 --%
cset var=sliderSize value=${null != sliderSize  sliderSize  9 }     %-- 滑块大小 --%
cset var=preText value=${not empty preText  preText  '上一页'}       %-- 上一页文本 --%
cset var=nextText value=${not empty nextText  nextText  '下一页'}    %-- 上一页文本 --%
cset var=goText value=${not empty goText  goText  '跳转'}        %-- 跳转页码文本 --%
%-- query string --%
cforEach var=pair items=${paramValues} varStatus=st
    cif test=${pair.key != pageParam}
        cforEach var=v items=${pair.value}
            cchoose
                %-- 设置为false 才不转义 --%
                cwhen test=${escape == false}
                    cset var=search value=${search}&${pair.key}=${v}
                cwhen
                cotherwise
                    cset var=search value=${search}&${fnescapeXml(pair.key)}=${fnescapeXml(v)}
                cotherwise
            cchoose
        cforEach
    cif
cforEach
%--cset var=search value=${fnsubstringBefore(search, '&')}--%
cset var=currentPage value=${not empty param[pageParam]  param[pageParam]  '1'}
ccatch var=ex
    cset var=currentPage value=${currentPage + 0} 
ccatch
cset var=currentPage value=${null != ex  '1'  currentPage} 
%--cset var=currentPage value=${currentPage  totalPages  1  currentPage} --%
cset var=sliderSize value=${sliderSize  totalPages  totalPages  sliderSize}
cset var=begin value=${currentPage - (sliderSize - 1)  2}
cset var=begin value=${begin  1  1  begin}
cset var=begin value=${begin + sliderSize - 1  totalPages  totalPages + 1 - sliderSize  begin}

					table class=pageList
						tbody
							tr
								td
									div class=clearfix
										div class=wu-page showinputbox=Never
										!-- 首页 --
										cchoose
									        cwhen test=${currentPage == 1}
									        	a title='已经是第一页' href=javascriptvoid(0); &lt; a
									        cwhen
									        cotherwise
									        	a title='第一页' href=${pageParam}=1${search} &lt; a
									        cotherwise
									    cchoose
																			
										%-- 上一页 --%
									    cchoose
									        cwhen test=${currentPage  1}
									        	a class=prev href=${pageParam}=${currentPage - 1}${search} ${preText } a
									        cwhen
									        cotherwise
									             a class=prev href=javascript; ${preText } a
									        cotherwise
									    cchoose
									    cif test=${0 eq sliderSize}
									        span 1 span
									    cif
	    
	    								%-- 页码 --%
									    cforEach var=p varStatus=st begin=${begin} end=${begin + sliderSize - 1}
									        %-- 起始大于1 --%
									        cif test=${st.first and p  1}
									        	a href=${pageParam}=1${search}1a
									            cif test=${p  2}
									                span ... span
									            cif
									        cif
									        cchoose
									            %-- 当前页  --%
									            cwhen test=${p == currentPage}
									                span ${p} span
									            cwhen
									            cotherwise
									                a href=${pageParam}=${p}${search} ${p} a
									            cotherwise
									        cchoose
									        cif test=${st.last and p  totalPages}
									            cif test=${p  totalPages - 1}
									                span ... span
									            cif
									            a href=${pageParam}=${totalPages}${search} ${totalPages} a
									        cif
									    cforEach
	    
									    %-- 下一页 --%
									    cchoose
									        cwhen test=${currentPage  totalPages}
									           a class=next href=${pageParam}=${currentPage + 1}${search} ${nextText } a
									        cwhen
									        cotherwise
									         a class=next href=javascript; ${nextText } a
									        cotherwise
									    cchoose
	    							
								 		!-- 最后一页 --
										cchoose
									        cwhen test=${currentPage == totalPages}
									        	a href=javascript; title='已经是最后一页' &gt;a
									        cwhen
									        cotherwise
									        	a href=${pageParam}=${totalPages}${search} title='最后一页' &gt;a
									        cotherwise
								    	cchoose
	    	
		    							%-- skip to --%
									    cif test=${ skip and totalPages  0}
									    	p 到第 input type=text name=curPage id=pageTo 页 p
								            cforEach var=pair items=${paramValues} varStatus=st
								                cif test=${pair.key != pageParam}
								                    cforEach var=v items=${pair.value}
								                        cchoose
								                            %-- 设置为false 才不转义 --%
								                            cwhen test=${escape == false}
								                                input type=hidden name=${pair.key} value=${v}
								                            cwhen
								                            cotherwise
								                                input type=hidden name=${fnescapeXml(pair.key)} value=${fnescapeXml(v)}
								                            cotherwise
								                        cchoose
								                    cforEach
								                cif
								            cforEach
									    cif
										a class=Pqd href=javascript; onclick=turnToPage(${totalPages});&nbsp;确定 a
										div
									div
								td
							tr
						tbody
					table