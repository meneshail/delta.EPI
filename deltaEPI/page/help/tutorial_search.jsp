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

	
<div id="container" style="height:3500px;">
	<jsp:include page="../../inc/menu.jsp" />

	<div id="content">

		<div id="right-column1" style="margin-left:5px;width:200px;">
			<div class="header_border">

				<div class="block"><img src="/deltaEPI/images/breadcrumb.gif" />1. Search Process</div>
				<ul>
					<ul>
						<li><a href="/deltaEPI/page/help/tutorial_search.jsp#11">1.1 Overall Scheme</a></li>
						<li><a href="/deltaEPI/page/help/tutorial_search.jsp#12">1.2 Search Modes</a></li>
						<li><a href="/deltaEPI/page/help/tutorial_search.jsp#13">1.3 Custom Search</a></li>
					</ul>
				</ul>

			</div>
		</div>


		<div id="left-column1" style="margin-left:10px;width:900px;margin-top:10px;">
			<div class="header_border" style="padding-top:0px;margin-top:0px;padding-left: 10px;">
				<div class="header">Search Process</div>
				<div class="header_content" id="Tutorial">

					<p class="tracktitle" ></p>

					<div id="11" class="sub_tutorial" style="padding-top:10px; padding-bottom:10px; font-weight:bold;" >1.1  Overall Scheme</div>
						<div class="sub_tutorial_content">
							<p class="p_tutorial">
							Delta.EPI is designed as a meta-tool to privide a click-and-go solution for EPI searching and visualization.
								<br></p>
							<p class="p_tutorial">
							Briefly, researches with Hi-C experiment are curated and all Hi-C data are processed with the same standard workflow. In a single research, contact pairs from samples belonging to the same cell line and cultured under the same experimental conditions will be pooled together
							to allow downstream high-resolution interaction analysis. This pooling process is done as is mentioned in the original research paper or additional materials. The pooled samples, sharing the same cell line and condition info, will be set as one entry in our database.
								<br></p>
							<p class="p_tutorial">
							For each entry, interactions are called by five independent Hi-C data analysing softwares in advance. Users can set as input a locus, a piece of DNA sequences, or a gene identifier.
							Then, input information will be located on the genome using built-in tools as input span(s) and any interactions that have one bin overlapped with it will be selected.
							For those interaction pairs, any TSS regions that overlap with the other bin will be recorded, and such input-TSS pairs will be listed on the result page as putative interactions.
							By default, the interactions are sorted in the order of (1) amount of methods agree on this interaction (2) overlapped ratio of the bin and corresponding span, which means interactions with higher overall reliability should rank at the top.
							</p>
							<div>
								<img src="/deltaEPI/images/process_1.png" style="height: 400px;" alt="process illustration">
							</div>
						</div>
					<div id="12" class="sub_tutorial" style="padding-top:10px; padding-bottom:10px; font-weight:bold;">1.2  Search Modes</div>
					<div class="sub_tutorial_content">
						<p class="p_tutorial">
						Currently there are three search modes users may use to search for interactions. You could switch the search mode by simply clicking
						on three corresponding options in the <a href="/deltaEPI/page/custom_search.jsp">Custom Search</a> page.
						</p>
						<ul>
							<li>
								<p>Search for Locus</p>
								<p class="p_tutorial">
									If users know the exact position of the enhancer( or other elements of interest), Locus Search mode could simply be used for analysis.
									Please make sure the locus uses the same reference genome as delta.EPI, and if they don't, users can easily convert them using <a href="https://genome.ucsc.edu/cgi-bin/hgLiftOver" style="display: inline;">UCSC online LiftOver tool</a>.
								</p>
								<img src="/deltaEPI/images/searchmode_1.png" style="height: 180px;">
							</li>
							<li>
								<p>Search for Sequence</p>
								<p class="p_tutorial">
									Sequence Search mode integrates an NCBI Blast Tools to provide support for users interesting in a specific DNA sequence while don't know where it come from.
									Inputted sequence will be mapped to the reference genome of selected species, and the result locus will be use as input for downstream processing.
									An editable span length variable decides the length of input span(extends from the midpoint of mapped sequence to upstream and downstream with same length).
									<br></p>
								<p class="p_tutorial">
									Note that only the match with highest mapping score will be used, so if the sequence is too short or does not result in a considerably small q value, we highly recommand you use NCBI online Blast tool, mapping to reference genome and select the locus yourself.
								</p>
								<img src="/deltaEPI/images/searchmode_2.png" style="height: 250px;">
							</li>
							<li>
								<p>Search for Gene Identifier</p>
								<p class="p_tutorial">
									Users could also set gene identifier as search target. Note that in this mode, TSS(es) of the input gene will be set as input spans, so basically results of TSS-TSS interactions instead of EPIs will be generated.
									Supported gene identifiers include Gene Symbol(Alias), or accession numbers from frequently-used database such as GenBank, Unigene, Entrez, Ensembl, UniProt, Pfam, Prosite.
									For some sorts of identifiers, one-to-many search result may be given, in this case the user may distinguish them by the unique Entrez ID and select one or more of them.
									<br>
								</p>
								<p class="p_tutorial">
									The gene identifier info is extracted from OrgDb , and the TSS info is obtained from TxDb via R Bioconductor.
								</p>
								<img src="/deltaEPI/images/searchmode_3.png" style="height: 230px;">
							</li>
							<li>
								<p>Quick Search</p>
								<p class="p_tutorial">
									The Quick Search bar on the <a href="/deltaEPI/index.jsp" style="display: inline;">index page</a> is a combination of three above search modes.
									By filling this single text box with some specific formats, users could arose corresponding search modes and get instant feedback.
									<ul style="list-style-position: inside;list-style-type: disc;">
										<li>For Locus Search, users may need to use the format "chrN : start-end", where 'N','start','end' denotes the detailed info of the locus.</li>
										<li>For Sequence Search, users need to add a "seq:" tag before the whole sequence.</li>
										<li>All inputs that do not match to previous formats will be used in Identifier Search.</li>
									</ul>
									<img src="/deltaEPI/images/quick_search_2.png" alt="illustration of quick search format" style="height: 250px;"/>
									<br clear="all">
								<b>*:</b>&emsp;All formats used in quick search are space and case insensitive, so users may only need to make sure the tag(in black color) and search targets(in red color) are in proper order.
									you may also click on the examples below the quick search textbox to try it out.
									<br>
								<b>*:</b>&emsp;Note that since it is not guaranteed that users' input will successfully map to the genome or match one identifier in the database, for Sequence or Identifier search mode,
									you may still need to click on Submit button to continue analysis after manually check the search result.
								</p>

							</li>

						</ul>
					</div>
					<div id="13" class="sub_tutorial" style="padding-top:10px; padding-bottom:10px; font-weight:bold;">1.3  Custom Search</div>
					<div class="sub_tutorial_content">
						<p class="p_tutorial">
						In the <a href="/deltaEPI/page/custom_search.jsp" style="display: inline;">Custom Search</a> Page, users could also select the cell lines info to narrow down the searching scope, the four selection bars are in
						hierarchical structure, users may stop at any layers to get entries of one specific species, tissues, cell types or cell lines.
							<br></p>
						<p class="p_tutorial">
						Users may also add some additional screening conditions such as <i>only selecting result from control group</i> to filter those results obtained under some special experimental condition.
						By default all entries that meet the cell line requirements will be listed in the Entry list on Result Page.
						</p>
					</div>



				</div>
			</div>
		</div>

	</div>

</div>


<script type="text/javascript" language="javascript">
	showTabs('3');

<!--
<script type="text/javascript" src="/deltaEPI/js/headerfooter.js">
-->
</script>

</body>
</html>
