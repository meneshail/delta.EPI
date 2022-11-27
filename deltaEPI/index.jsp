<%@ taglib prefix="s" uri="/struts-tags"%>
<%@page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link href="/deltaEPI/css/default.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="/deltaEPI/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="/deltaEPI/js/menu.js"> </script>
	<script src="https://ngdc.cncb.ac.cn/cdn/js/headerfooter.js"> </script>


	<title>Hi-C Data Based Enhancer-Promoter Interaction Predictor</title>

	<script type="text/javascript" language="javascript">

		var default_quick_search_text = "chr1 : 1000000-2000000"
		var chromList;

		$(function(){
			setDefault($("#QuickSearchText")[0],default_quick_search_text);
			init_species();
		})

		$(function(){
		});


		function init_species(){
			$.ajax({
				url : '/deltaEPI/ajax/getAllSpecies.action?time='+new Date(),
				type : 'post',
				dataType : 'json',
				success : initSpeciesResult,
				error : processSpeciesErrorResult
			});
		}


		function initSpeciesResult(data){
			console.log("Initializing species to human...");
			$("#SpeciesID").empty();
			$("#SpeciesID").val("Homo_sapiens");
			$.each(data.entryList,addSpeciesData);

			console.log("Initializing chrom list...");
			clickOnSpecies();
		}

		function processSpeciesErrorResult(){
		}

		function addSpeciesData(index,value){
			var optionstr="<option value='"+value.speciesName+"'>"+value.speciesName;
			optionstr= optionstr+"</option>";
			$("#SpeciesID").append(optionstr);
		}


		function unsetDefault(obj,default_value){
			console.log(obj);
			console.log($(obj));
			if(obj.value == default_value){
				obj.value='';
				obj.style.color='#000';
			}
		}

		function setDefault(obj,default_value){
			console.log(obj);
			console.log($(obj));
			if(!obj.value){
				obj.value=default_value;
				obj.style.color='#999';
			}
		}


		function clickOnSpecies(){
			refreshBySpecies();
		}

		function refreshBySpecies(){
			console.log("Now the species name change to: " + $("#SpeciesID").val());
			var speciesName = $("#SpeciesID").val();
			var params = {"speciesName":speciesName};
			console.log("Retriving chrom list from mysql...");
			$.ajax({
				url : '/deltaEPI/ajax/getChromList.action?time='+new Date().getTime(),
				type : 'post',
				data : params,
				dataType : 'json',
				success : processChromResult,
				error : processSpeciesErrorResult
			});
		}


		function processChromResult(data){
			console.log("Emptify chromList.");
			chromList = new Array(0);
			$.each(data.chromList,addChrom);
			console.log("Now the chromList becomes:");
			console.log(chromList);
		}

		function addChrom(index,value){
			chromList = chromList.concat(value.chrom);
		}

		function quickSearch(){
			var input = $("#QuickSearchText").val();
			var input_purified = input.replace(/\s/g,"").toUpperCase();
			var speciesName = $("#SpeciesID").val();
			console.log("Input:" + input_purified);

			var url = "/deltaEPI/page/custom_search.jsp?species="+speciesName;

			//check if input is a locus range
			var regex_locus = /(chr)?([0-9XY]{1,2}):(\d*)-(\d*)/g

			var reg_match_locus = regex_locus.exec(input_purified);
			console.log(reg_match_locus);

			//check if input is dna sequence
			var regex_blast = /SEQ:(.*)/g
			var reg_match_blast = regex_blast.exec(input_purified);
			console.log(reg_match_blast);

			//operation
			if(reg_match_locus != null && reg_match_locus.length==5){
				console.log("search mode 1 detected.");
				searchMode = 1;
				chrom = reg_match_locus[2];
				start = reg_match_locus[3];
				end = reg_match_locus[4];
				console.log("chrom: "+chrom +"\nstart" + start +"\nend" + end);
				if(checkChrom(chrom)){
					console.log("Match successfully!");
					url+="&searchMode=" + searchMode;
					url+="&chrom=" +chrom;
					url+="&start=" + start;
					url+="&end=" + end;
					window.location.href=url;
				}else{
					alert("Invalid chromosome specified!");
					return;
				}
			}else if(reg_match_blast != null && reg_match_blast.length==2){
				console.log("search mode 2 detected.");
				searchMode = 2;
				sequence = reg_match_blast[1];
				console.log("sequence "+sequence);

				url+="&searchMode=" + searchMode;
				url+="&sequence=" + sequence;
				window.location.href=url;
			}else{
				console.log("search mode 3 detected.");
				searchMode = 3;
				url+="&searchMode=" + searchMode;
				url+="&input=" +input_purified;
				window.location.href=url;
			}

		}

		function checkChrom(chrom){
			for ( var i=0 ; i< chromList.length ; i++){
				if(chrom == chromList[i]){
					return  true;
				}
			}
			return false;
		}

		function quickSearchThis(mode){
			$("#QuickSearchText")[0].style.color='#999';
			if(mode==1){
				$("#QuickSearchText").val("chr17: 38653000-38663000");
			}else if(mode==2){
				$("#QuickSearchText").val("seq:GTCAGGGAGCCTGTAGCAGCCCACACTGAGACAGGGCTCACAGGGCCTGGAGTGACATGGAGCCTGGT");
			}else if(mode==3){
				$("#QuickSearchText").val("A1B");
			}

		}

	</script>
</head>


<body>


<div id="container">
	<jsp:include page="/inc/menu.jsp" />
	<script type="text/javascript" language="javascript">
		showTabs('0');
	</script>

	<div id="content" style="height: 1800px;">
		<div id="left-column1" style="margin-left:5px;width:800px; ">
			<div class="header_border">
				<div class="content_header">
					Quick Search</div>
				<div id="QuickSearchBlock" style="height: 100px;">
					<table id="quick_search_table" style="border-spacing: 20px;">
						<tr>
							<td>
								<select style="width: 200px" name="speciesName" id="SpeciesID" value="Homo_sapiens" onchange="refreshBySpecies()" onfocus="clickOnSpecies()">
									<!--onfocus="this.selectedIndex = -1;"-->
									<option value="Homo_sapiens">Homo_sapiens</option>
								</select>
							</td>
							<td style="width: 150px">
								<input type="text" id="QuickSearchText" onfocus="unsetDefault(this,default_quick_search_text)" onblur="setDefault(this,default_quick_search_text)"
									   style="width: 300px;"/>
							</td>
							<td>
								<input type="button" id="QuickSearchButton" value="quick search" onclick="quickSearch()"/>
							</td>
						</tr>
					</table>
					<table style="width: 550px;margin-left: 50px">
						<tr style="border-spacing: 5px; ">
							<td class="QuickSearchExample" style="width: 15px;">e.g.</td>
							<td >
								<a href="javascript:;" style="width: 15px;" class="QuickSearchExample" onclick="quickSearchThis(1)">chr17: 38653000-38663000</a>
							</td>
							<td >
								<a href="javascript:;" style="width: 15px;" class="QuickSearchExample" onclick="quickSearchThis(2)">seq:GTCAGGG....AGCCTGGT</a>
							</td>
							<td >
								<a href="javascript:;" style="width: 15px;" class="QuickSearchExample" onclick="quickSearchThis(3)">A1B</a>
							</td>
						</tr>
					</table>
				</div>
				<div class="content_header">
					Welcome to Delta.EPI</div>
				<div class="header_content" >
					Delta.EPI is an online tool for EPI annotation from public 3D genome data.
					Delta.EPI curated and pre-analysed multiple published Hi-C/ChIA-PET datasets with well-designed pipeline,
					and thus provides a click-and-go solution for targeted distal regulatory element search.
					<div align="center" style="padding-top:10px;">
						<img src="/deltaEPI/images/process_1.png" width="250px" style="margin: 0 auto;" >

					</div>
					<div class="header">Searching Scheme</div>
					<div class="header_content">
						<p>
							The server is primarily designed for searching distal regulatory interaction. Using the quicksearch box above, the user can search for
							a locus, a DNA sequence or an accession number from mainstream databases. The input will be mapped to reference genome and any potential interacting TSS regions will be listed in result page.
							<br><br>
							Currently, the server has included results of more than 30 cell lines from 3 species. You could narrow down your search scope in Custom Search Page,
							then you can browse the research samples that meet your requirment in result page, and reanalyse the result with a new chosen sample.
							<br><br>
							You can access more info about our searching algorithms in help page.
						</p>

					</div>
					<div class="header">Pre-analysis Pipeline</div>
					<div class="header_content">
						<p>
							All data are pre-analysed using the same standard pipeline from raw fastq file to obtain unbiased and comparable results.
							Briefly, read trimming and quality control for raw fastq reads through trim_galore. Then HiC-Pro is used for Hi-C data processing workflow.
							Valid contact pairs from different samples are pooled in accordance with the source paper to generate .allValidPairs file and contact matrix.
							Finally, four stand-alone methods are used to call distal interactions separately at 5k,10k and 25k resolution.
							Detailed explanation about analysing process and parameter setting could be found at Help Page.
						</p>

					</div>
					<div align="center" style="padding-top:10px;">
						<img src="/deltaEPI/images/pre_pipeline.png" width="550px" style="padding-right: 100px">

					</div>

				</div>
			</div>
		</div>
		<div id="right-column1" style="margin-left:10px;width:250px;float: left">
			<div class="header_border" style="padding-top:0px;margin-top:0px;height: 200px">
				<div class="header">What's new?</div>
				<div class="header_content">
					<div>1.delta.EPI is now available to access(2021-12-01).</div>
				</div>
			</div>
			<div class="header_border" style="height: 150px">
				<div class="header">Other BIG Tools</div>
				<div class="header_content">
					<div><a href="http://deltaar.big.ac.cn/" target="_blank">Delta.AR</a></div>
					<div><a href="http://delta.big.ac.cn/" target="_blank">Delta</a></div>
					<div><a href="http://3cdb.big.ac.cn" target="_blank">3CDB</a></div>
					<div style="display:inline-block;width:200px;"><a href="#" target="_blank"></a></div>
				</div>
			</div>
			<!--
			<div class="header_border" style="height: 150px">
				<div class="header">Useful link</div>
				<div class="header_content"></div>
			</div>
			-->
		</div>
	</div>
</div>





</body>
</html>
