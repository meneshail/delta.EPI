<%@ taglib prefix="s" uri="/struts-tags"%>
<%@page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="/deltaEPI/css/default.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="/deltaEPI/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="/deltaEPI/js/menu.js"> </script>
	<script type="text/javascript" src="/deltaEPI/js/sprintf.js"> </script>
	<script src="https://ngdc.cncb.ac.cn/cdn/js/headerfooter.js"> </script>

<title>Hi-C Data Based Enhancer-Promoter Interaction Predictor</title>
	

</head>


<body>

	
<div id="container" style="height:2500px;">
	<jsp:include page="../../inc/menu.jsp" />

	<div id="content">

		<div id="right-column1" style="margin-left:5px;width:200px;">
			<div class="header_border">

				<div class="block"><img src="/deltaEPI/images/breadcrumb.gif" />2. Result Presentation</div>
				<ul>
					<li><a href="/deltaEPI/page/help/tutorial_result.jsp#21">2.1 Putative Interactions</a></li>
					<li><a href="/deltaEPI/page/help/tutorial_result.jsp#22">2.2 Genome Browser</a></li>
					<li><a href="/deltaEPI/page/help/tutorial_result.jsp#23">2.3 Entry List and Reanalyse</a></li>

				</ul>

			</div>
		</div>


		<div id="left-column1" style="margin-left:10px;width:900px;margin-top:10px;">
			<div class="header_border" style="padding-top:0px;margin-top:0px;padding-left: 10px;">
				<div class="header">2. Result Presentation</div>
				<div>
					<p class="p_tutorial">
						After submitting the customized searching information, users will enter a result page displaying the result EPI pairs.
						By default, the EPIs are calculated from the entry with the most valid contact pairs among those that meet users' screening requirement.
						The Result Page contains three sections.
					</p>
				</div>
				<div class="header_content" id="Tutorial">

					<p class="tracktitle" ></p>

					<div id="21" class="sub_tutorial" style="padding-top:10px; padding-bottom:10px; font-weight:bold;">2.1	Putative Interactions</div>
					<div class="sub_tutorial_content">
						<p class="p_tutorial">
							All putative EPIs calculated from the first entry are listed in a result table.
							The 2nd~9th columns display the Entrez ID, name, locus, strand, methods(that agree on this interaction), and 3 GO terms of the genes whose TSSes are
							potentially interacting with users' input. And the 10th column is the name of users' input, which is only meaningful in the case of multiple inputs.
							<br>
							<img src="/deltaEPI/images/result_table.png" alt="example of result table" style="height: 300px"/>
							<br></p>
						<p class="p_tutorial">
							By default the list is sorted in the order of overall reliability of the EPI pair, and users can click on the column names to reorder them.
							<br></p>
						<p class="p_tutorial">
							Users could download the whole list in csv format by clicking on the download button.
						</p>
					</div>
					<div id="22" class="sub_tutorial" style="padding-top:10px; padding-bottom:10px; font-weight:bold;">2.2	Genome Browser</div>
					<div class="sub_tutorial_content">
						<p class="p_tutorial">
							Genome Browser provide an easy access to delta Genome View function, where users could visualize the EPIs along with other genomic tracks to further observe the putative interactions.
							By default the interactions called by different softwares for this particular entry(merged sample) will be displayed in arc, as well as the ChipSeq for the cell line this entry belongs to.
							Users may customize the tracks being displayed using the tracks table, which will emerge after clicking on the <i>select tracks</i> button.
							<img src="/deltaEPI/images/genome_view_1.png" alt="example of genome browser" style="height: 300px"/>
						</p>
					</div>
					<div id="23" class="sub_tutorial" style="padding-top:10px; padding-bottom:10px; font-weight:bold;">2.3	Entry List and Reanalyse</div>
					<div class="sub_tutorial_content">
						<p class="p_tutorial">
							As is mentioned above, an research entry is a set of experiment samples that are obtained from the same research series, belonging to the same cell line, cultured and processed under the same experimental conditions.
							To increase the resolution of contact matrix, therefore get more statistically significant interactions with lower bin size, it is actually a common method to pool Hi-C data from many replicates, and
							do the calculation together. Before calling interactions, we meticulously reviewed the original paper as well as any additional materials and pooled samples into entries accordingly.
							<br></p>
						<p class="p_tutorial">
							When users submit the interested locus to the server, all entries that meet the screening requirements will be listed in this table in the order of valid contacts. Only the first entry(with the most valid contacts) will be analysed by default.
							<br></p>
						<p class="p_tutorial">
							Users may check the detailed information about this entry by clicking on the title to expand the protocols, or the GSE accession number to check out the whole research series on GEO.
							To reanalyse users' search target with another entry, click the checkbox and submit your reanalysis request to the server. Seconds later the new results will be calculated, with an automatic refresh of the EPI table and Genome Browser.
							<br>
							<img src="/deltaEPI/images/study_list_1.png" alt="example of entry list" style="height: 300px"/>

						</p>
					</div>

				</div>
			</div>
		</div>

	</div>

</div>



<script type="text/javascript" language="javascript">
	showTabs('3');
</script>


</body>
</html>
