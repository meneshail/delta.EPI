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
	<script type="text/javascript" src="/deltaEPI/js/jquery.params.js"> </script>
	<script type="text/javascript" src="/deltaEPI/js/sorttable.js"></script>
	<script src="https://ngdc.cncb.ac.cn/cdn/js/headerfooter.js"> </script>
	
	<title>Hi-C Data Based Enhancer-Promoter Interaction Predictor</title>

	<script type="text/javascript" language="javascript">
		var default_blast_span = '10000';
		var default_gene_query = 'Enter gene symbol or accession number';
		//var species_init_ajax,tissue_init_ajax,celltype_init_ajax,cellline_init_ajax,chrom_init_ajax;



		$(function(){
            displayPairTable = $("#search_customize_table tbody:eq(0)") ;
            displayPairCheckbox = $(displayPairTable).find("input:checkbox");
            useDatasetTable = $("#search_customize_table tbody:eq(1)") ;
            useDatasetCheckbox = $(useDatasetTable).find("input:checkbox");

			console.log("Intializing search block...");
			$("#blast_block").hide();
			$("#gene_block").hide();

			console.log($("#BlastSpan")[0]);
			setDefault($("#BlastSpan")[0],default_blast_span);
			setDefault($("#gene_id")[0],default_gene_query);

			initialize();
		})

		function initialize(){
			init_celltype();
			init_cellline();

			searchMode = $.query.get("searchMode");
			speciesName = $.query.get("species");
			console.log("searchMode:" + searchMode);

			displayPairCheckbox.filter(":eq(0), :eq(3), :eq(4)").prop("checked","checked");
			useDatasetCheckbox.not(":eq(1)").prop("checked","checked");

			if(searchMode!=""){
				init_species();
				$("#SpeciesID").val(speciesName);
				var params = {"speciesName":speciesName};
				var a=$.ajax({
					url : '/deltaEPI/ajax/getConditionalTissue.action?time='+new Date().getTime(),
					type : 'post',
					data : params,
					async :false,
					dataType : 'json',
					success : processSpeciesResult,
					error : processSpeciesErrorResult
				});
				console.log("Retriving chrom list from mysql...");
				var b=$.ajax({
					url : '/deltaEPI/ajax/getChromList.action?time='+new Date().getTime(),
					type : 'post',
					data : params,
					async :false,
					dataType : 'json',
					success : processChromResult,
					error : processSpeciesErrorResult
				});
				console.log("change species name to"+ speciesName);
				if(searchMode==1){
					console.log("search mode 1 detected");
                    switchSearchBlock(1);
					chrom = $.query.get("chrom");
					start = $.query.get("start");
					end = $.query.get("end");

					$("#ChromID").val(chrom);
					console.log("change chrom to "+ chrom);
					$("#LocusStart").val(start);
					$("#LocusEnd").val(end);

					$("#SubmitButton").click();
				}else if(searchMode==2){
					console.log("search mode 2 detected");
					switchSearchBlock(2);
					sequence = $.query.get("sequence");

					$("#DnaSequence").val(sequence);
					$("#BlastButton").click();
				}else{
					console.log("search mode 3 detected");
					switchSearchBlock(3);
					input = $.query.get("input");

					unsetDefault($("#gene_id")[0],default_gene_query);
					$("#gene_id").val(input);
					$("#gene_block_button").click();
				}
			}else{
                switchSearchBlock(1);
				init_species();
				init_tissue();
				init_chrom();
			}

			//console.log($("#BlastSpan"));

			//$.when(a1,a2,a3,a4,a5).done(function(a1,a2,a3,a4,a5){});
		}




		function init_species(){
			var species_init_ajax=$.ajax({
				url : '/deltaEPI/ajax/getAllSpecies.action?time='+new Date(),
				type : 'post',
				async : false,
				dataType : 'json',
				success : initSpeciesResult,
				error : processSpeciesErrorResult
			});
			$("#TissueID").prop("disabled", "");
			$("#CellTypeID").prop("disabled", "disabled");
			$("#CellLineID").prop("disabled", "disabled");
			return species_init_ajax;
		}

		function init_tissue(){
			var tissue_init_ajax=$.ajax({
				url : '/deltaEPI/ajax/getAllTissue.action?time='+new Date(),
				type : 'post',
				async : false,
				dataType : 'json',
				success : initTissueResult,
				error : processTissueErrorResult
			});
			return tissue_init_ajax;
		}

		function init_celltype(){
			var celltype_init_ajax=$.ajax({
				url : '/deltaEPI/ajax/getAllCellType.action?time='+new Date(),
				type : 'post',
				async : false,
				dataType : 'json',
				success : initCellTypeResult,
				error : processCellTypeErrorResult
			});
			return celltype_init_ajax;
		}

		function init_cellline(){
			var cellline_init_ajax=$.ajax({
				url : '/deltaEPI/ajax/getAllCellLine.action?time='+new Date(),
				type : 'post',
				async : false,
				dataType : 'json',
				success : initCellLineResult,
				error : processCellLineErrorResult
			});
			return cellline_init_ajax;
		}

		function init_chrom(){
			console.log("Initializing chrom list...");
			var speciesName = $("#SpeciesID").val();
			var params = {"speciesName":speciesName};
			console.log("Initiation: Retriving chrom list from mysql...");
			var chrom_init_ajax=$.ajax({
				url : '/deltaEPI/ajax/getChromList.action?time='+new Date().getTime(),
				type : 'post',
				data : params,
				async : false,
				dataType : 'json',
				success : processChromResult,
				error : processSpeciesErrorResult
			});
			return chrom_init_ajax;
		}

		function initSpeciesResult(data){
			console.log("Initializing species to human...");
			$("#SpeciesID").val("Homo_sapiens");
			$.each(data.entryList,addSpeciesData);
			$("#TissueID").prop("disabled", "");
		}

		function processSpeciesErrorResult(){
		}

		function addSpeciesData(index,value){
			var optionstr="<option value='"+value.speciesName+"'>"+value.speciesName;
			optionstr= optionstr+"</option>";
			$("#SpeciesID").append(optionstr);
		}


		function initTissueResult(data){
			console.log("Start initializing tissue type..");
			console.log("Current value:" + $("#TissueID").val());
			var optionstr="<option value='All'>All</option>";
			$("#TissueID").append(optionstr);
			$("#TissueID").val("All");
			console.log("After modifying:" + $("#TissueID").val());
			//console.log("Num of Available tissue:");
			//console.log(data.entryList.length);
			$.each(data.entryList,addTissueData);
			console.log("After initializing options:" + $("#TissueID").val());

		}

		function processTissueErrorResult(){
		}

		function addTissueData(index,value){
			var optionstr="<option value='"+value.tissueType+"'>"+value.tissueType;
			optionstr= optionstr+"</option>";
			$("#TissueID").append(optionstr);
		}

		function initCellTypeResult(data){
			console.log("Start initializing tissue type..");
			console.log("Current value:" + $("#CellTypeID").val());
			var optionstr="<option value='All'>All</option>";
			$("#CellTypeID").append(optionstr);
			$("#CellTypeID").val("All");
			console.log("After modifying:" + $("#CellTypeID").val());
			$.each(data.entryList,addCellTypeData);
			console.log("After initializing options:" + $("#CellTypeID").val());
		}

		function processCellTypeErrorResult(){
		}

		function addCellTypeData(index,value){
			var optionstr="<option value='"+value.cellType+"'>"+value.cellType;
			optionstr= optionstr+"</option>";
			$("#CellTypeID").append(optionstr);
		}

		function initCellLineResult(data){
			console.log("Start initializing tissue type..");
			console.log("Current value:" + $("#CellLineID").val());
			var optionstr="<option value='All'>All</option>";
			$("#CellLineID").append(optionstr);
			$("#CellLineID").val("All");
			console.log("After modifying:" + $("#CellLineID").val());
			$.each(data.entryList,addCellLineData);
			console.log("After initializing options:" + $("#CellLineID").val());
		}

		function processCellLineErrorResult(){
		}

		function addCellLineData(index,value){
			var optionstr="<option value='"+value.cellLine+"'>"+value.cellLine;
			optionstr= optionstr+"</option>";
			$("#CellLineID").append(optionstr);
		}




	</script>
</head>


<body>



<div id="container" style="height:auto;">
	<jsp:include page="/inc/menu.jsp" />
	<div id="content" >
		<form action="/deltaEPI/search/entrySearch.action" method="post" id="searchInfo" >
			<input type="hidden" name="isFirstSearchFlag" value="1" />
			<input type="hidden" id="entrezIdListID" name="entrezIdList" value="" />
			<input type="hidden" id="searchModeID" name="searchForm.searchMode" value="1" />
			<input type="hidden" id="TaskID" name="searchForm.taskId" value="" />
			<input type="hidden" id="AnchorID" name="searchForm.anchor" value="" />
			<div class="header_content">
				<ul>

					<li  class="titleblue" style="padding: 3px 0px">
						<b style="font-size: 13px">Cell line hierarchy:</b>
						<p style="padding-top: 10px; padding-left: 13px">
						<table  id="cell_type_hierarchy" style="margin-left: 20px;">
							<tr>
								<td style="width: 150px">Species*:</td>
								<td>
									<select style="width: 200px" name="searchForm.speciesName" id="SpeciesID" onchange="refreshBySpecies()" onfocus="clickOnSpecies()">  <!--onfocus="this.selectedIndex = -1;"-->
									</select>
								</td>
							</tr>
							<tr>
								<td>Tissue:</td>
								<td>
									<select style="width: 200px" name="searchForm.tissueType" id="TissueID" onchange="refreshByTissue()" onfocus="this.selectedIndex = 0;clickOnTissue()">
									</select>
								</td>
							</tr>
							<tr>
								<td>Cell Type:</td>
								<td>
									<select style="width: 200px" name="searchForm.cellType" id="CellTypeID" onchange="refreshByCellType()" onfocus="this.selectedIndex = 0;clickOnCelltype()">
									</select>
								</td>
							</tr>
							<tr>
								<td height="28">Cell Line:</td>
								<td>
									<select style="width: 200px" name="searchForm.cellLine" id="CellLineID" onchange="refreshByCellLine()">
									</select>
								</td>
							</tr>
						</table>
						</p>
						<div class="header_content" style="padding-bottom: 10px; border-bottom: 1px solid #333333; width: 90%; height: 0px"></div>
					</li>

					<li class="titleblue" style="padding: 3px 0px">
						<b style="font-size: 13px; clear: both;">Searching Scheme:</b>
                        <br clear="all">
                        <div class="custom_search_column1">
                            <div style="margin-left: 15px;margin-top: 15px;">
                                <table id="search_block_option" style="text-align: center;border-spacing: 50px 0px;">
                                    <tr>
                                        <td><a href="javascript:;" onclick="switchSearchBlock(1)">Locus</a></td>
                                        <td><a href="javascript:;" onclick="switchSearchBlock(2)">DNA Sequence</a></td>
                                        <td><a href="javascript:;" onclick="switchSearchBlock(3)">Gene Identifier</a></td>
                                    </tr>
                                </table>
                            </div>
                            <div id="blast_block" class="search_block">
                                <b style="font-size: 13px; clear: both;display: none;">Sequence Search:</b>
                                <div id="Blast">
                                    <div style="margin-left: 20px;">
                                        <table id="BlastInfo" style="margin-right: 15px;margin-top: 15px;float: left; border-spacing: 0 10px" >
                                            <tr>
                                                <td>
                                                    chromosome:
                                                </td>
                                                <td id="BlastChrom" style="text-align: center">
                                                    null
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    start:
                                                </td>
                                                <td id="BlastStart" style="text-align: center">
                                                    null
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    end:
                                                </td>
                                                <td id="BlastEnd" style="text-align: center">
                                                    null
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    span length:
                                                </td>
                                                <td>
                                                    <input id="BlastSpan" type="text" onfocus="unsetDefault(this,default_blast_span)" onblur="setDefault(this,default_blast_span)" style="width: 80px"/>
                                                </td>
                                            </tr>
                                        </table>
                                        <div  style="padding:0; float: left;">
                                            <p>Enter DNA sequence:</p>
                                            <textarea rows="5" cols="30" id="DnaSequence"></textarea><br><br>
                                            <input type="button" id="BlastButton" value="Align to Reference Genome" onclick="blastAction()"/>
                                        </div>
                                        <div id="BlastTip" style="border: 1px dashed; background-color: #F1F5EC; height: 100px; width: 350px; margin:10px 0 0 20px;float:left;padding: 5px;display: none;" >
                                        </div>
                                        <img id="BlastLoading" src="/deltaEPI/images/loading.gif" style="height: 60px; width: 60px; margin-left: 20px;float:left;padding: 5px;display: none;" />
                                </div>
                                <br clear="both">
                                </div>
                            </div>
                            <div id="gene_block" class="search_block" >
                                <b style="font-size: 13px; clear: both;display: none;">Gene Identifier:</b>
                                <div>

                                    <table id="gene_identifier" style="text-align: center;margin: 10px 0 10px 50px; border-spacing: 50px 0px;">
                                        <tr>
                                            <td>
                                                <input type="text" id="gene_id" onfocus="unsetDefault(this,default_gene_query)" onblur="setDefault(this,default_gene_query)"
                                                       style="width: 300px;"/>
                                            </td>
                                            <td>
                                                <input id="gene_block_button" type="button" onclick="getGeneInfo()" value="search"/>
                                            </td>
                                        </tr>
                                    </table>

                                    <div style="margin-left: 0px; max-height: 450px; max-width: 600px; overflow-y: scroll;" >
                                        <table id="gene_block_table" class="sortable" style="float: left;">
                                            <thead>
                                                <tr>
                                                    <th width="40px"><input type="checkbox" name="identifierCheckBox" value="" onchange="changeAll(this)"/></th>
                                                    <th style="min-width: 100px">Identifier</th>
                                                    <th style="min-width: 100px">DataBase</th>
                                                    <th style="min-width: 100px">Entrez ID</th>
                                                    <th style="max-width: 150px">Gene Name</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <tr>
                                                <td><input type="checkbox" name="identifierCheckBox" disabled="disabled" /></td>
                                                <td>null</td>
                                                <td>null</td>
                                                <td>null</td>
                                                <td>null</td>
                                            </tr>
                                            </tbody>
                                        </table>

                                    </div>
                                    <br clear="all">
                                </div>
                            </div>

						<!--<div class="header_content" style="padding-bottom: 10px; border-bottom: 1px solid #333333; width: 90%; height: 0px"></div>


                        </li>
                        <li class="titleblue" style="padding: 3px 0px">
                        -->
                            <div id="position_block">
                                <b style="font-size: 13px; display: none">Position Information:</b>
                                <div id="Position" style="margin-top: 10px">
                                    <p style="padding-top: 10px; padding-left: 13px">Chromosome&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <select style="width: 200px" name="searchForm.chrom" id="ChromID"  disabled="disabled">
                                            <option selected="selected" value="None">——</option>
                                        </select>
                                    </p>
                                    <p style="padding-top: 10px; padding-left: 13px">Location:&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;start&nbsp;
                                        <input type="text"  name="searchForm.start" value=""
                                               style="width:120px;height: 15px" id="LocusStart"/>
                                        &nbsp;&nbsp; end&nbsp;
                                        <input type="text" name="searchForm.end" value=""
                                               style="width:120px;height: 15px" id="LocusEnd"/>
                                    </p>

                                </div>

                            </div>
                        </div>
                        <div class="custom_search_column2">
                            <div id="search_customize_block">
                                <div style="width: 450px;height: 220px;">
                                    <a class="diagram" href="javascript:;" style="width: 450px;" title="diagram"><img width="450px" src="/deltaEPI/images/diagram/PE_PE.svg" alt="interaction diagram" style="margin: 0px; padding: 0px"/></a>
                                </div>
                                <table id="search_customize_table" >
                                    <!--<tr>
                                        <td>
                                            Result Display:
                                        </td>
                                    </tr>-->
                                    <tbody>
                                    <input type="hidden" id="displayPairID" name="searchForm.displayPair" value="" />
                                    <tr>
                                        <td style="width: 250px">
                                            <p class="search_customize_title">Query Region:</p>
                                            <p class="search_customize_option">Use query region as a whole</p>
                                            <p class="search_customize_option">Find promoter elements</p>
                                            <p class="search_customize_option">Find enhancer elements</p>
                                        </td>
                                        <td style="width: 30px">
                                            <p>
                                                <input type="text" class="ValidityText"  value="" style="width:0px;height:0px;position: relative;left:-30px;opacity: 0;" />
                                            </p>
                                            <p><input type="checkbox" value="0" onchange="changeDisplayPair(this)"/></p>
                                            <p><input type="checkbox" value="1" onchange="changeDisplayPair(this)"/></p>
                                            <p><input type="checkbox" value="2" onchange="changeDisplayPair(this)"/></p>
                                        </td>
                                        <td style="width: 200px">
                                            <p class="search_customize_title">Interacting Elements:</p>
                                            <p></p>
                                            <p class="search_customize_option">Find promoter elements</p>
                                            <p class="search_customize_option">Find enhancer elements</p>
                                        </td>
                                        <td style="width: 30px">
                                            <p></p>
                                            <p></p>
                                            <p><input type="checkbox" value="3" onchange="changeDisplayPair(this)"/></p>
                                            <p><input type="checkbox" value="4" onchange="changeDisplayPair(this)"/></p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 400px" colspan="4">
                                            <p class="search_customize_option" style="padding-left: 23px">
                                                *:Show relevant pre-called bin-bin interactions results in a separated track
                                            </p>
                                        </td>
                                        <td>
                                            <p><input type="checkbox" value="5" onchange="changeDisplayPair(this)"/></p>
                                        </td>
                                    </tr>
                                    </tbody>
                                    <tbody>
                                    <input type="hidden" id="useDatasetID" name="searchForm.useDataset" value="" />
                                    <tr>
                                        <td style="width: 250px">
                                            <p class="search_customize_title">Promoter Dataset:
                                                <input type="text" class="ValidityText"  value="" style="width:0px;height:0px;position: relative;left:-30px;opacity: 0;" />
                                            </p>
                                            <p class="search_customize_option">All TSS (&plusmn;2.5kb)</p>
                                            <p class="search_customize_option">Protein Encoding TSS (&plusmn;2.5kb)</p>
                                        </td>
                                        <td style="width: 30px">
                                            <p></p>
                                            <p><input type="checkbox" value="0" onchange="changeUseDataset(this)"/></p>
                                            <p><input type="checkbox" value="1" onchange="changeUseDataset(this)"/></p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 250px">
                                            <p class="search_customize_title">
                                            Enhancer Dataset:
                                                <input type="text" class="ValidityText"  value="" style="width:0px;height:0px;position: relative;left:-30px;opacity: 0;" />
                                            </p>
                                            <p class="search_customize_option">FANTOM5 Enhancer Dataset</p>
                                            <p class="search_customize_option">ChromHMM Enh/EnhG Region</p>
                                            <p class="search_customize_option">cCRE-dELS (ENCODE)</p>
                                        </td>
                                        <td style="width: 30px">
                                            <p></p>
                                            <p><input type="checkbox" value="2" onchange="changeUseDataset(this)"/></p>
                                            <p><input type="checkbox" value="3" onchange="changeUseDataset(this)"/></p>
                                            <p><input type="checkbox" value="4" onchange="changeUseDataset(this)"/></p>
                                        </td>
                                    </tr>
                                    </tbody>

                                </table>

                            </div>
                        </div>
                        <br clear="all">
                    </li>
					<div class="header_content"
						 style="padding-bottom: 10px; border-bottom: 1px solid #333333; width: 90%; height: 0px"></div>

					<li class="titleblue" style="padding: 3px 0px">
						<b style="font-size: 13px">Experiment condition:</b>
						<p style="padding-top: 10px; padding-left: 13px; ">Only Show Control Group &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox"  name="searchForm.locusName" value="" style="height: 15px;padding-left: 5px" />
						</p>
						<div class="header_content"
							 style="padding-bottom: 10px; border-bottom: 1px solid #333333; width: 90%; height: 0px"></div>
					</li>
				</ul>


				<div class="button" style="margin-bottom: 50px; margin-top: 20px;">
					<div id="viewspecies"></div>
					<div id="selspecies"></div>
					<div id="refspecies"></div>
					<!--
                    <a href="result.jsp"><input type="button" value="submit" /></a>
                    -->
					<input type="submit" id="SubmitButton" value="Submit" onclick="return checkSearchForm()" />
					<input type="Reset" value="Reset" style="width: 60px" onclick="" />
				</div>
			</div>
		</form>
	</div>
</div>
</div>
<!--
<script type="text/javascript" src="/deltaEPI/js/headerfooter.js"> </script> -->

<script type="text/javascript" language="javascript">
	showTabs('1');

	function changeUseDataset(obj){
	    console.log(obj);
	    var isValid = true;
	    var currUseDataset = 0;
        if(obj && obj.checked) {
            console.log("check action detected");
            if ($(obj).val() <= 1) {
                useDatasetCheckbox.eq(1 - $(obj).val()).prop("checked", "");
            }
        }
        if(displayPairCheckbox.filter(":eq(1), :eq(3)").filter(":checked").length > 0 && useDatasetCheckbox.slice(0,2).not(":disabled").filter(":checked").length == 0){
            //alert("You may select one promoter dataset for candidate EPI searching.");
            useDatasetTable.find("input.ValidityText")[0].setCustomValidity("You may select one promoter dataset for candidate EPI searching.");
            isValid = false;
        }else{
            useDatasetTable.find("input.ValidityText")[0].setCustomValidity("");
        }

        if(displayPairCheckbox.filter(":eq(2), :eq(4)").filter(":checked").length > 0 && useDatasetCheckbox.slice(2).not(":disabled").filter(":checked").length == 0){
            //alert("You may select at least one enhancer datasets for candidate EPI searching.");
            useDatasetTable.find("input.ValidityText")[1].setCustomValidity("You may select at least one enhancer datasets for candidate EPI searching.");
            isValid = false;
        }else{
            useDatasetTable.find("input.ValidityText")[1].setCustomValidity("");
        }
        document.getElementById("searchInfo").reportValidity();
        if(!obj){
            useDatasetCheckbox.filter(":checked").each(function(i,obj){currUseDataset += 2**obj.value;});
            console.log("useDataset:" + currUseDataset);
            $("#useDatasetID").val(currUseDataset);
        }
        return isValid;
    }

	function changeDisplayPair(obj){
	    console.log(obj);
        var currDisplayPair = 0;
        var isValid = true;
        //console.log(checkboxList.val());
        //check action
        if(obj){
            if(obj.checked){
                console.log("check action detected");
                if($(obj).val() == 0 ){
                    if(displayPairCheckbox.slice(1,3).filter(":checked").length > 0){
                        //alert("The input query may not be considered as a whole while also splits into smaller candidate elements.");
                        displayPairCheckbox.slice(1,3).prop("checked","");
                    }
                }else if($(obj).val() <= 2){
                    if(displayPairCheckbox[0].checked) {
                        //alert("The input query may not be considered as a whole while also splits into smaller candidate elements.");
                        displayPairCheckbox.slice(0, 1).prop("checked", "");
                    }
                }
            }else{
                console.log("uncheck action detected");
            }
        }

        displayPairCheckbox.slice(0,5).filter(":checked").each(function(i,obj){currDisplayPair += 2**obj.value;});

        if(displayPairCheckbox.slice(0,3).not(":checked").length == 3 || displayPairCheckbox.slice(3,5).not(":checked").length == 2 ){
            //alert("You may select at least one type of element to search and display for both query and interacting region.");
            displayPairTable.find("input.ValidityText")[0].setCustomValidity("For both query and interacting regions, you may select at least one type of element to search and display.");
            isValid = false;
        }else {
            //remove validity check prompt
            displayPairTable.find("input.ValidityText")[0].setCustomValidity("");
            //refresh interaction diagram
            if ($("#searchModeID").val() == 3) {
                srcString = "/deltaEPI/images/diagram/" + currDisplayPair + "_2.svg";
            } else {
                srcString = "/deltaEPI/images/diagram/" + currDisplayPair + ".svg";
            }
            $("#search_customize_block img").prop("src", srcString);
        }
        document.getElementById("searchInfo").reportValidity();

        if(!obj){
            displayPairCheckbox.slice(5).filter(":checked").each(function(i,obj){currDisplayPair += 2**obj.value;});
            console.log("displayPair:" + currDisplayPair);
            $("#displayPairID").val(currDisplayPair);
        }
        return isValid;
    }

    $(function(){
        $("a.diagram").mouseover(function(e){       //mouse moves over
            var myTitle=this.title;
            var imgTitle=myTitle?"<br/>"+myTitle:"";	//get the title of image
            var zoom_view=$('<div id="zoom_view"><img src="'+$(this).find("img").prop("src")+'" width="800px" height="400px" alt="放大提示"/>'+imgTitle+"</div>"); //build image div
            $("body").append(zoom_view);
            $("#zoom_view").css({"top":(e.pageY+20)+"px","left":(e.pageX-800-10)+"px"});  //CSS position property should be set as 'absolute'绝对定位
        }).mousemove(function(e){
            $("#zoom_view").css({"top":(e.pageY+20)+"px","left":(e.pageX-800-10)+"px"});	//update cordinates when mouse moves
        }).mouseout(function(){
            $("#zoom_view").remove();	//remove div when mouseout
        });

    });

	function getGeneInfo(){
		var currGeneId = $("#gene_id").val();
		var speciesName = $("#SpeciesID").val();
		currGeneId = currGeneId.replace(/[^a-z\d\s]+/gi,"");
        	$("#gene_id").val(currGeneId);
		console.log("Species: " + speciesName);
		console.log("Search gene id(accession): " + currGeneId);

		var params = {"speciesName":speciesName,"identifier":currGeneId};
		getGeneInfo_Ajax = $.ajax({
			url : '/deltaEPI/ajax/getEntrezId.action?time='+new Date().getTime(),
			type : 'post',
			data : params,
			dataType : 'json',
			success : processEntrezIdResult,
			error : processSpeciesErrorResult
		});
		return getGeneInfo_Ajax;
	}

	function processEntrezIdResult(data){
		//resultList=data.geneList;
		//console.log("Found Genes: " + resultList.length);
		$("#gene_block_table thead input:checkbox")[0].checked = false ;
		console.log("Found Genes: " + data.geneList.length);
		if(data.geneList.length > 0){
			$("#gene_block_table tbody").empty();
			for(i=0;i<data.geneList.length;i++){
				var geneInfo = data.geneList[i];
				console.log(geneInfo);
				$("#gene_block_table tbody").append(sprintf('<tr>\n<td><input type="checkbox" name="identifierCheckBox" value="" /></td>\n<td>%s</td>\n<td>%s</td>\n<td>%s</td>\n<td><a href="https://www.ncbi.nlm.nih.gov/gene/?term=%s" target="_blank">%s</a></td>\n</tr>',geneInfo.identifier,geneInfo.database,geneInfo.entrezId,geneInfo.entrezId,geneInfo.geneName));
				$("#gene_block_table input:checkbox").prop("disabled","");
			}
		}else{
			$("#gene_block_table tbody").empty();
			var searchText = $("#gene_id").val();
			if(searchText == default_gene_query){
				searchText = "null";
			}
			$("#gene_block_table tbody").append(sprintf('<tr>\n<td><input type="checkbox" name="identifierCheckBox" value="" /></td>\n<td>%s</td>\n<td>%s</td>\n<td>%s</td>\n<td>%s</td>\n</tr>',searchText,"null","null","null"));
			$("#gene_block_table input:checkbox").prop("disabled","disabled");
			alert("No gene found with this identifier, please check your input.");
		}
	}

	function changeAll(obj){
		console.log(obj);
		console.log($(obj).parents('table').find("input:checkbox"));
		if(obj.checked){
			$(obj).parents("table").find("input:checkbox").prop('checked',true);
		}else{
			$(obj).parents("table").find("input:checkbox").prop('checked',false);
		}
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


	function switchSearchBlock(block_val){

        var queryAsPromoterCheckbox = $(displayPairCheckbox).eq(1);
        var queryAsOtherCheckbox = $(displayPairCheckbox).filter(":eq(0), :eq(2)");
        var queryAsOtherOption = $(displayPairTable).find("p.search_customize_option").filter(":eq(0), :eq(2)");
        $("#search_block_option").find("td").css("background-color","#FFFFFF");
		$("#search_block_option").find("td").eq(block_val-1).css("background-color","#F0F0F0");
		switch (block_val) {
			case 1:
				$("#blast_block").slideUp();
				$("#gene_block").slideUp();
				$("#position_block").slideDown();
				$("#searchModeID").val(1);
                queryAsOtherOption.css("color","#000000");
                queryAsOtherCheckbox.prop("disabled","");
				break;
			case 2:
				$("#blast_block").slideDown();
				$("#gene_block").slideUp();
				$("#position_block").slideDown();
				$("#searchModeID").val(2);
                queryAsOtherOption.css("color","#000000");
                queryAsOtherCheckbox.prop("disabled","");
				break;
			case 3:
				$("#blast_block").slideUp();
				$("#gene_block").slideDown();
				$("#position_block").slideUp();
				$("#searchModeID").val(3);
                queryAsOtherOption.css("color","#AAAAAA");
                queryAsOtherCheckbox.prop("checked","");
                queryAsOtherCheckbox.prop("disabled","disabled");
                queryAsPromoterCheckbox.prop("checked","true");
				break;
		}
		changeDisplayPair(queryAsPromoterCheckbox);

	}

	function clickOnSpecies(){
		refreshBySpecies();
		clearSelection($("#CellTypeID"));
		clearSelection($("#CellLineID"));

	}

	function refreshBySpecies(){
		console.log("Now the species name change to: " + $("#SpeciesID").val());
		var speciesName = $("#SpeciesID").val();
		var params = {"speciesName":speciesName};
		$.ajax({
			url : '/deltaEPI/ajax/getConditionalTissue.action?time='+new Date().getTime(),
			type : 'post',
			data : params,
			dataType : 'json',
			success : processSpeciesResult,
			error : processSpeciesErrorResult
		});
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


	function processSpeciesResult(data) {

		$("#TissueID").prop("disabled", "");
		$("#TissueID").empty();
		optionstr = "<option value='All'>All</option>";
		$("#TissueID").append(optionstr);
		$.each(data.entryList, addTissueData);

	}

	function processChromResult(data){
		$("#ChromID").prop("disabled", "");
		$("#ChromID").empty();
		$.each(data.chromList,addChrom);
	}

	function addChrom(index,value){
		var optionstr="<option value='"+value.chrom+"'>"+value.chrom+"</option>";
		$("#ChromID").append(optionstr);
	}

	function clickOnTissue(){
		$("#TissueID").selectedIndex=0;

		clearSelection($("#CellTypeID"));
		clearSelection($("#CellLineID"));
	}

	function refreshByTissue(){
		console.log("Now the tissue type change to: " + $("#TissueID").val());
		if($("#TissueID").val()=="All"){
			clearSelection($("#CellTypeID"));
			clearSelection($("#CellLineID"));
		}
		else{
			var speciesName = $("#SpeciesID").val();
			var tissueType = $("#TissueID").val();
			var params = {"speciesName":speciesName,"tissueType":tissueType};
			$.ajax({
				url : '/deltaEPI/ajax/getConditionalCellType.action?time='+new Date().getTime(),
				type : 'post',
				data : params,
				dataType : 'json',
				success : processTissueResult,
				error : processTissueErrorResult
			});
		}
	}


	function processTissueResult(data) {
		$("#CellTypeID").empty();
		$("#CellTypeID").prop("disabled", "");
		optionstr = "<option value='All'>All</option>";
		$("#CellTypeID").append(optionstr);
		$("#CellTypeID").val("All");
		$.each(data.entryList, addCellTypeData);

	}

	function refreshByCellType(){
		console.log("Now the cell type change to: " + $("#CellTypeID").val());
		if($("#CellTypeID").val()=="All"){
			clearSelection($("#CellLineID"));
		}
		else{
			var speciesName = $("#SpeciesID").val();
			var tissueType = $("#TissueID").val();
			var cellType = $("#CellTypeID").val();
			var params = {"speciesName":speciesName,"tissueType":tissueType,"cellType":cellType};
			$.ajax({
				url : '/deltaEPI/ajax/getConditionalCellLine.action?time='+new Date().getTime(),
				type : 'post',
				data : params,
				dataType : 'json',
				success : processCellTypeResult,
				error : processCellTypeErrorResult
			});
		}
	}

	function clickOnCelltype(){
		$("#CellTypeID").selectedIndex=0;

		clearSelection($("#CellLineID"));
	}


	function processCellTypeResult(data) {

		//clearSelection($("#CellLineID"));

		$("#CellLineID").prop("disabled", "");
		$("#CellLineID").empty();
		optionstr = "<option value='All'>All</option>";
		$("#CellLineID").append(optionstr);
		$("#CellLineID").val("All");

		$.each(data.entryList, addCellLineData);
	}

	function clearSelection(obj){
		obj.prop("disabled", "disabled");
		obj.empty();
		optionstr = "<option value='All'>All</option>";
		obj.append(optionstr);
		obj.val("All");
	}

	function refreshByCellLine(){
		console.log("Now the cell line change to: " + $("#CellLineID").val());
	}

	function checkSearchForm(){
		console.log("Species Name:" + $("#SpeciesID").val());
		console.log("Tissue Type:" + $("#TissueID").val());
		console.log("Cell Type:" + $("#CellTypeID").val());
		console.log("Cell Line:" + $("#CellLineID").val());
		console.log("search mode:"+ $("#searchModeID").val());
		if($("#searchModeID").val() == 3){
			if($("#gene_block_table input:checkbox").prop('disabled')){
				console.log("No entrez id specified, retry to get gene info...")
				getGeneInfo_Ajax=getGeneInfo();
				$.when(getGeneInfo_Ajax).done(function(){
					console.log("Action getGeneInfo() finished.");
					alert("Please search and select at least one valid gene identifier before submitting");
				});
				return false;
			}else{
				var geneList = $("#gene_block_table").find("tr") ;
				var entrezIdList = [] ;
				for(var i=1; i < geneList.length ; i++){
					var curr_gene = geneList[i];
					if($(curr_gene).find('input:checkbox').prop('checked')){
						entrezIdList.push($(curr_gene).find('td')[3].innerHTML);
					}
				}
				if(entrezIdList.length==0){
					alert("Please search and select at least one valid gene identifier before submitting");
					return false;
				}
				$("#entrezIdListID").val(entrezIdList.join(','));
				console.log("EntrezIdList: "+ entrezIdList.join(','));
			}
		}else{
			console.log("Locus start:" + $("#LocusStart").val());
			console.log("Locus end:" + $("#LocusEnd").val());
			if( (! isNumber($("#LocusStart").val())) || (! isNumber($("#LocusEnd").val())) ) {
				console.log("Invalid input span, please input two positive integers.")
				alert("Invalid input span, please input two positive integers.");
				return false;
			}else if(parseInt($("#LocusEnd").val())<parseInt($("#LocusStart").val())){
				console.log("Invalid input span, please make sure the start site is larger than 0 and smaller than the end site.")
				alert("Invalid input span, please make sure the start site is larger than 0 and smaller than the end site.");
				return false;
			}
		}
		if(!changeDisplayPair() || !changeUseDataset()){
		    console.log("Invalid parameter");
        }
		date = new Date();
		$("#TaskID").val(""+date.getTime());
		//console.log($("#TaskID").val());
		console.log($("#displayPairID").val());
		console.log($("#useDatasetID").val());
		return true;
	}

	function checkBlastInput(){
		var span = $('#BlastSpan').val();
		var raw_seq = $('#DnaSequence').val();
		var seq = raw_seq.replace(/[^atcg]+/gi,"");
		$('#DnaSequence').val(seq);
		//check span length
		if( span != parseInt(String(span))){
			alert("Span length must be an integer!");
			return 1;
		}
		if (seq.length <25){
			alert("Sequence length must be no less than 25!");
			return  1;
		}
		return 0;
	}

	function blastAction(){
		$('#BlastTip').empty();
		document.getElementById('BlastTip').style.display="none";
		document.getElementById('BlastLoading').style.display="";
		$('#BlastButton').prop('disabled',"disabled");
		$('#BlastSpan').prop("disabled","disabled");
		$("input[type=submit]").prop("disabled","disabled");
		$("input[type=reset]").prop("disabled","disabled");
		if(checkBlastInput()!=0){
			$('#BlastButton').prop('disabled',"");
			$('#BlastSpan').prop("disabled","");
			return;
		}
		var seq = $('#DnaSequence').val();
		var speciesName = $("#SpeciesID").val();
		var params = {"species":speciesName,"sequence":seq};
		$.ajax({
			url : '/deltaEPI/ajax/blast.action?time='+new Date().getTime(),
			type : 'post',
			data : params,
			dataType : 'json',
			success : processBlastResult,
			error : processBlastError
		});
	}

	function processBlastResult(data){
		var blastResult = data.blastResult;
		if(blastResult.exitStatus!=0){
			console.log("Error when doing blast!");
			alert("Unable to map to reference genome!")
		}else{
			var chromosome =blastResult.chromosome;
			var chrom = chromosome.replace(/chr/gi,"");
			document.getElementById("BlastChrom").innerHTML = chromosome;
			document.getElementById("BlastStart").innerHTML = blastResult.start;
			document.getElementById("BlastEnd").innerHTML = blastResult.end;
			$('#ChromID').val(chrom);

			var span = $('#BlastSpan').val()
			var mid = Math.round((blastResult.start+blastResult.end)/2);

			var half_span = Math.round(span/2);

			var start = Math.max(mid - half_span,0);
			var end = mid + half_span;

			$('#LocusStart').val(start);
			$('#LocusEnd').val(end);

			var Tip = "Mapped to reference genome with:<br>&nbsp&nbsp identity:"+blastResult.identity+
					"<br>&nbsp&nbspq value: " + blastResult.qValue+
					"<br>If you want to look for other possibilities, please use this <a href='https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&BLAST_SPEC=OGP__9606__9558&LINK_LOC=blasthome'>NCBI online Blast Tool.</a>"
			document.getElementById("BlastTip").innerHTML = Tip;
			document.getElementById('BlastTip').style.display="";
			document.getElementById('BlastLoading').style.display="none";
		}
		$('#BlastButton').prop('disabled',"");
		$('#BlastSpan').prop("disabled","");
		$("input[type=submit]").prop("disabled","");
		$("input[type=reset]").prop("disabled","");
	}

	function processBlastError(){
		$('#BlastButton').prop('disabled',"");
		$('#BlastSpan').prop("disabled","");
		$("input[type=submit]").prop("disabled","");
		$("input[type=reset]").prop("disabled","");
	}

	function isNumber(val){

		var regPos = /^\d+$/;
		if(regPos.test(val)){
			return true;
		}else{
			return false;
		}

	}
</script>
</body>
</html>
