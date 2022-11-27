
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link href="/deltaEPI/css/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="http://static.runoob.com/assets/jquery-validation-1.14.0/lib/jquery.js"></script>
<script type="text/javascript" src="/deltaEPI/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/deltaEPI/js/jquery.layout-latest.js"></script>

<title>Hi-C Data Based Enhancer-Promoter Interaction Predictor</title>
	

</head>


<body>

	
<div id="container" style="height:1000px;">
	<jsp:include page="/deltaEPI/inc/menu.jsp" />

	<div id="content">

		<div id="right-column1" style="margin-left:5px;width:800px;">
			<div class="header_border">

				<div class="block"><img src="/deltaEPI/images/breadcrumb.gif" />Help Page</div>
				<table width="760">
					<tbody>
					<tr><td width="321" valign="top">
						<div  style="padding-top:10px;padding-bottom:10px;"><a href="/deltaEPI/page/help/search.jsp">1.Searching Process</a></div>
						<ul>

							<li><a href="/deltaEPI/page/help/search.jsp#11">1.1 Searching Distal Interaction</a>
								<ul>
									<li><a href="/deltaEPI/page/help/search.jsp#111">1.1.1 Overall Scheme</a></li>
									<li><a href="/deltaEPI/page/help/search.jsp#112">1.1.2 Input Searching Target</a></li>
									<li><a href="/deltaEPI/page/help/search.jsp#113">1.1.3 Curtomize Searching</a></li>
								</ul>

							</li>
							<li><a href="/deltaEPI/page/help/search.jsp#12">1.2 Result Presentation</a>
								<ul>
									<li><a href="/deltaEPI/page/help/search.jsp#121">1.2.1 Putative Interactions</a></li>
									<li><a href="/deltaEPI/page/help/search.jsp#122">1.2.2 Genome Viewer</a></li>
									<li><a href="/deltaEPI/page/help/search.jsp#123">1.2.3 Go Enrichment Analysis</a></li>
									<li><a href="/deltaEPI/page/help/search.jsp#124">1.2.4 Research List and Reanalyse</a></li>
								</ul>

							</li>

						</ul>
					</td><td width="30"></td>
						</tr>
					<tr><td valign="top">

					</td><td></td><td></td></tr>
					</tbody>
				</table>

				<p>Data Curation
					Researches
				</p>
				<p>Pre-processing
					Raw fastq data is downloaded from NCBI. Then read trimming and QC is conducted using trim_galore,
					where adapters are trimmed and any reads pairs with quality score below 30 are discarded.
				</p>
				<p>Hi-C Data Processing Workflow
					HiC-Pro is used to process Hi-C data. Briefly, reads are firstly mapped to the reference genome using a two-step strategy.
					Then read pairs with unique alignment at both end are merged and further assigned to restriction site to filter out invalid ligation products.
					Finally valid pairs from all replicates are pooled together to build contact matrix.
				</p>






			</div>
		</div>

	</div>

</div>

</div>


<script type="text/javascript" src="/hepi/js/headerfooter.js"> </script>
<script type="text/javascript" language="javascript">
		showTabs('0');
</script>
</body>
</html>
