%-- trimDirectiveWhitespaces �� JSP 2.1 �Ժ��,tomcat 6 ֮ǰ������ --%
%@ tag isELIgnored=false pageEncoding=UTF-8 body-content=empty description=��ҳ trimDirectiveWhitespaces=true %
%@ attribute name=pageParam type=java.lang.String required=false description=��ǰҳ��������� %
%@ attribute name=totalPages type=java.lang.Integer required=true description=��ҳ�� %
%@ attribute name=sliderSize type=java.lang.Integer required=false description=��ҳ������ %
%@ attribute name=skip type=java.lang.Boolean required=true description=�Ƿ���ʾ��ת���� %
%@ attribute name=escape type=java.lang.Boolean required=false description=�Ƿ�ת��XML�����ַ� %
%@ attribute name=preText type=java.lang.String required=false description=��һҳ���� %
%@ attribute name=nextText type=java.lang.String required=false description=��һҳ���� %
%@ attribute name=goText type=java.lang.String required=false description=��ת���� %
%--%@ attribute name=preText type=java.lang.String required=false description=��һҳ�ı� %--%
%--%@ attribute name=nextText type=java.lang.String required=false description=��һҳ�ı� %--%
%--%@ attribute name=goText type=java.lang.String required=false description=��תҳ���ı� %--%
%@ taglib prefix=c uri=httpjava.sun.comjspjstlcore %
%@ taglib prefix=fn uri=httpjava.sun.comjspjstlfunctions %
cset var=pageParam value=${not empty pageParam  pageParam  'page'}  %-- ҳ����� --%
cset var=sliderSize value=${null != sliderSize  sliderSize  9 }     %-- �����С --%
cset var=preText value=${not empty preText  preText  '��һҳ'}       %-- ��һҳ�ı� --%
cset var=nextText value=${not empty nextText  nextText  '��һҳ'}    %-- ��һҳ�ı� --%
cset var=goText value=${not empty goText  goText  '��ת'}        %-- ��תҳ���ı� --%
%-- query string --%
cforEach var=pair items=${paramValues} varStatus=st
    cif test=${pair.key != pageParam}
        cforEach var=v items=${pair.value}
            cchoose
                %-- ����Ϊfalse �Ų�ת�� --%
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
										!-- ��ҳ --
										cchoose
									        cwhen test=${currentPage == 1}
									        	a title='�Ѿ��ǵ�һҳ' href=javascriptvoid(0); &lt; a
									        cwhen
									        cotherwise
									        	a title='��һҳ' href=${pageParam}=1${search} &lt; a
									        cotherwise
									    cchoose
																			
										%-- ��һҳ --%
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
	    
	    								%-- ҳ�� --%
									    cforEach var=p varStatus=st begin=${begin} end=${begin + sliderSize - 1}
									        %-- ��ʼ����1 --%
									        cif test=${st.first and p  1}
									        	a href=${pageParam}=1${search}1a
									            cif test=${p  2}
									                span ... span
									            cif
									        cif
									        cchoose
									            %-- ��ǰҳ  --%
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
	    
									    %-- ��һҳ --%
									    cchoose
									        cwhen test=${currentPage  totalPages}
									           a class=next href=${pageParam}=${currentPage + 1}${search} ${nextText } a
									        cwhen
									        cotherwise
									         a class=next href=javascript; ${nextText } a
									        cotherwise
									    cchoose
	    							
								 		!-- ���һҳ --
										cchoose
									        cwhen test=${currentPage == totalPages}
									        	a href=javascript; title='�Ѿ������һҳ' &gt;a
									        cwhen
									        cotherwise
									        	a href=${pageParam}=${totalPages}${search} title='���һҳ' &gt;a
									        cotherwise
								    	cchoose
	    	
		    							%-- skip to --%
									    cif test=${ skip and totalPages  0}
									    	p ���� input type=text name=curPage id=pageTo ҳ p
								            cforEach var=pair items=${paramValues} varStatus=st
								                cif test=${pair.key != pageParam}
								                    cforEach var=v items=${pair.value}
								                        cchoose
								                            %-- ����Ϊfalse �Ų�ת�� --%
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
										a class=Pqd href=javascript; onclick=turnToPage(${totalPages});&nbsp;ȷ�� a
										div
									div
								td
							tr
						tbody
					table