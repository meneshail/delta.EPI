<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page import="cn.ac.big.hepi.util.Page"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		<script language="javascript" type="text/javascript">
		function setPageSize(url) {
			var size = document.getElementById("listpage").value;
			var tail = "&pageSize=" + size;
			var tar = url + tail;
			window.location = tar;
		}
		function goPage(url) {
			var gono = document.getElementById("gono").value;
			var tail = "&pageNo=" + gono;
			var tar = url + tail;
			window.location = tar;
		}
		
		
		</script>
	</head>

	<body>
		<%
			String myUrl = (String) request.getAttribute("myUrl");
			System.out.println(myUrl);
			Page myPage = (Page) request.getAttribute("myPage");
			int pageSize = myPage.getPageSize();
			int pageNo = myPage.getPageNo();
			int rowCount = myPage.getRowCount();
			int firstPageNo = myPage.getFirstPageNo();
			int lastPageNo = myPage.getLastPageNo();
			
			
			int nextPageNo = pageNo + 1;
			int prevPageNo = pageNo - 1;

			String nextUrl = myUrl + "&pageNo=" + nextPageNo + "&pageSize="
					+ pageSize + "&rowCount=" + rowCount+"&isFirstSearchFlag=0";
			String prevUrl = myUrl + "&pageNo=" + prevPageNo + "&pageSize="
					+ pageSize + "&rowCount=" + rowCount+"&isFirstSearchFlag=0";
			
			String lastPage =  myUrl + "&pageNo=" + lastPageNo + "&pageSize="
					+ pageSize + "&rowCount=" + rowCount+"&isFirstSearchFlag=0";
			String firstPage = myUrl + "&pageNo=" + firstPageNo + "&pageSize="
					+ pageSize + "&rowCount=" + rowCount+"&isFirstSearchFlag=0";

			String pageSizeLink = myUrl + "&pageNo=" + pageNo + "&rowCount="
					+ rowCount+"&isFirstSearchFlag=0";
			String goToPageLink = myUrl + "&pageSize=" + pageSize
					+ "&rowCount=" + rowCount+"&isFirstSearchFlag=0";
		%>
		<table width="101%">
			<tr>
				<td width="12%">
					Item&nbsp;
						<s:if test="page.rowCount>0">
							<s:property value="page.rowFrom" />
						</s:if>
						<s:else>0</s:else>
						&nbsp;
					
					&nbsp;-&nbsp;
					
					<s:property value="page.rowTo" />
					&nbsp;
					
					of
					<s:property value="page.rowCount" />
					
			  </td>
				<td width="13%">
					Data/Page&nbsp;
					<select name="pageSize" id="listpage"
						onchange="setPageSize('<%=pageSizeLink%>')" style="width:70px">
						<option value="10"
							<s:if test="page.pageSize==10">selected="selected"</s:if>>
							10
						</option>
						<option value="15"
							<s:if test="page.pageSize==15">selected="selected"</s:if>>
							15
						</option>
						<option value="20"
							<s:if test="page.pageSize==20">selected="selected"</s:if>>
							20
						</option>
						<option value="30"
							<s:if test="page.pageSize==30">selected="selected"</s:if>>
							30
						</option>
					</select>
					
			  </td>

				<td width="26%">
					<a href="<%=firstPage%>">First</a>
					<s:if test="page.isHasPreviousPage==1">
						<a href="<%=prevUrl%>">Prev</a>
					</s:if>
					<s:else>
						<a disabled="disabled" style="color:#555555;">Prev</a>
					</s:else>
					<input type="text" size="3" id="gono" name="gono" value="<s:property value='page.pageNo'/>">of
					<s:property value="page.lastPageNo" />
					<s:if test="page.isHasNextPage==1">
						<a href="<%=nextUrl%>">Next</a>
					</s:if>
					<s:else>
						<a disabled="disabled" style="color:#555555;">Next</a>
					</s:else>
					<a href="<%=lastPage %>">Last</a>
					<input type="button" value="GOTO" onClick="goPage('<%=goToPageLink%>')" style="margin-left:20px"/>
			  </td>
			  <td width="2%"></td>
				<!--
			  <td width="47%">
			  
			  <div class="savetofile">
					Download Options:
					item
					<select name="item" id="dlitem" type="select" style="width:160px" onChange="selectItem()">
						<option value="3">All Search Results</option>
						<option value="1">All Current Displayed items</option>
						<option selected="selected" value="2">Only Selected items</option>
					</select>
					&nbsp;&nbsp;
					File Type
					<select name="filetype" id="filetype" type="select" style="width:100px">
						<option selected="selected" value="1">Text</option>
						<option value="2">File</option>
					</select>
					&nbsp;&nbsp;<input type="submit" value="download" onClick="return checkEmpty()"/>

				</div>
			  </td>
			  <-->
			<td width="25%">
				<div class="Analyse">
					<table>
						<tr>
							Reanalyse with selected research entry<br>
						</tr>
						<tr>
							<div style="margin: auto">
								<input type="button" id="reanalyse" onclick="reanalyseEntry()" value="submit" style="margin-left: 90px;">
							</div>
						</tr>
					</table>
				</div>
			</td>
		</table>
		
	</body>
</html>
