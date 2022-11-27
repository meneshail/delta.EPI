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
    <script type="text/javascript" src="/deltaEPI/js/sorttable.js"></script>
    <script type="text/javascript" src="/deltaEPI/js/string.js"></script>
    <script src="https://ngdc.cncb.ac.cn/cdn/js/headerfooter.js"> </script>

    <title>Hi-C Data Based Enhancer-Promoter Interaction Predictor</title>
    <script type="text/javascript" language="javascript">
        var tableLink = "javascript:;";
        var imageLink = "javascript:;";
        var accession = "";
        var anchorString = "";
        var genomeViewSrc = "http://delta.big.ac.cn/jbrowse/index.html?data=hg18&loc=1%3A34832656..83436331&tracks=H1-hESC_H3K4me2%2CGSE18199_GM06690_100000_Matrix%2Censembl_gene%2CGM12878_H3K36me3_signal%2CGM12878_H3K27me3%2CGM12878_H3K27ac%2CGM12878_CTCF&highlight=";
        ///deltaEPI/jbrowse/index.html?data=1499137860032&loc=1%3A4413779..5311180&tracks=Interaction&highlight=
        var defaultTrack = "GM12878_H3K27ac_fold_change%2CGM12878_H3K4me1_fold_change%2CGM12878_H3K4me3_fold_change%2C" ;
        $(function(){
            $("tr td[colspan=7]").find("div").hide();
        })

        function slideDetail(obj) {
            //stopPropagation();
            //console.log("Invoking slide function!");
            //console.log(this);
            //console.log(obj);
            //console.log($(this));
            //console.log($(obj));
            $(obj).closest("tr").next("tr").find('div').slideToggle();
            return false;
        }

        function slideResult(obj){
            $(obj).closest("div").find("div").slideToggle();
            return false;
        }

        String.format = function() {
            if (arguments.length == 0)
                return null;
            var str = arguments[0];
            for ( var i = 1; i < arguments.length; i++) {
                var re = new RegExp('\\{' + (i - 1) + '\\}', 'gm');
                str = str.replace(re, arguments[i]);
            }
            return str;
        };


        window.onload = function (){
            console.log("Analyzing Result of the first entry... ");
            $('#enrichment_graph').prop('src',"/deltaEPI/images/loading.gif");
            $('#enrichment_graph').css('height',"30px");
            $('#enrichment_graph').css('width',"30px");

            $('#promoter-list-table').empty();
            loading_image = '<tr><td><img src="/deltaEPI/images/loading.gif" style="margin: 0 auto; width: 30px; height: 30px;"></td></tr>';
            $('#promoter-list-table').append(loading_image);
            $('#promoter-list').find('p input').prop('type','hidden');

            var first_entry = document.getElementsByName("entryCheckBox")[0];
            first_entry.checked=true;

            var accession_val = first_entry.value;
            var cell_line = S($(first_entry).closest("tr").find("td")[5].innerHTML).stripLeft('\n ').stripRight('\n ').s;


            var accession = sprintf("HEPI%06d",accession_val);
            console.log("Formatted accession:" + accession);
            console.log("Cell line:" + cell_line);
            var task_id = '<s:property value="searchForm.taskId"/>' ;
            var species_name = '<s:property value="searchForm.speciesName"/>' ;
            var display_pair = '<s:property value="searchForm.displayPair"/>' ;
            var use_dataset = '<s:property value="searchForm.useDataset"/>' ;
            console.log("displayPiar: " + display_pair);
            console.log("useDataset: " + use_dataset);
            //var params_cell_line = {"accessionVal":accession_val,"species":species_name,"cellLine":cell_line};
            params = {"accessionVal":accession_val,"species":species_name,"taskId":task_id,"cellLine":cell_line, "displayPair":display_pair,"useDataset":use_dataset};
            console.log(params);
            $('#reanalyse').prop("disabled","disabled");

            $.ajax({
                //url : window.location.protocol+'//bigd.big.ac.cn/deltaEPI/ajax/entryProcessGetTrack.action?time='+new Date().getTime(),
                url : '/deltaEPI/ajax/entryProcessGetTrack.action?time='+new Date().getTime(),
                type : 'get',
                data : params,
                dataType : 'json',
                success : initSrc,
                error : logError
            });
            var step_one_ajax = $.ajax({
                //url : window.location.protocol+'//bigd.big.ac.cn/deltaEPI/ajax/entryProcessStepOne.action?time='+new Date().getTime(),
                url : '/deltaEPI/ajax/entryProcessStepOne.action?time='+new Date().getTime(),
                type : 'get',
                data : params,
                dataType : 'json',
                success : refreshTable,
                error : logError
            });

            /*
            $.when(step_one_ajax).done(function(){
                $.ajax({
                    url : '/deltaEPI/ajax/entryProcessStepTwo.action?time='+new Date().getTime(),
                    type : 'post',
                    data : params,
                    dataType : 'json',
                    success : refreshGraph,
                    error : logError
                });
            });

             */

        }


        function logError(data){
            console.log("Analysis returns non-0 exit code, please check the log.");
            $('#reanalyse').prop("disabled","");
        }

        function refreshGraph(data){
            console.log(data.taskId);
            console.log(data.accession);
            imageLink='/deltaEPI/data/temp/' + data.taskId + '/' + data.accession + '/genes_enrichment.png';
            if(isExistFile(imageLink)){
                $('#enrichment_graph').css('height',"400px");
                $('#enrichment_graph').css('width',"600px");
                $('#enrichment_graph').prop('src',imageLink);
                document.getElementById("graphDownloadID").style.display="";
            }else{
                $('#enrichment_graph').css('height',"0");
                $('#enrichment_graph').css('width',"0");
                $('#enrichment_graph').prop('src',imageLink);
                document.getElementById("graphDownloadID").style.display="none";
            }

        }

        function refreshTable(data){
            //alert(data.interactionInfoList.length);
            $('#promoter-list-table').empty();
            /*
            var header="<thead><tr><th style='width:25px'></th><th style='width:65px'>Entrez ID</th><th style='width:125px'>Name</th><th style='width:150px'>Locus</th>" +
                "<th style='width:25px'>Strand</th><th style='width:60px'>Method</th><th style='width:160px'>Molecular Function</th><th style='width:160px'>Cellular Component</th>" +
                "<th style='width:160px'>Biological Process</th><th style='width:70px'>(Enhancer ID)</th></tr></thead><tbody>"
             */
            var header="<thead><tr><th style='width: 30px'></th><th style='width: 120px'>Interaction Class</th><th style='width: 150px'>Query ID</th><th style='width: 150px'>Locus1</th>" +
                "<th style='width: 150px'>Interaction ID</th><th style='width: 150px'>Locus2</th><th style='width: 150px'>Method</th><th style='width: 150px'>Bin Size</th></tr></thead><tbody>"
            $('#promoter-list-table').append(header);
            if(data.interactionInfoList.length==0){
                $('#promoter-list-table').append("<tr><td colspan='12'  rowspan='5' style='font-size:3ex ; text-align: center; width: 1000px;'>None</td></tr>");
                tableLink = "javascript:;";
            }else{
                $.each(data.interactionInfoList, appendInteractionInfo);
                $('#promoter-list-table').append("</tbody>");
                tableLink='/deltaEPI/data/temp/' + data.taskId + '/' + data.accession + '/download.bedpe';
                $('#promoter-list').find('p input').prop('type','button');
                sorttable.makeSortable(document.getElementById("promoter-list-table"));
                setGeneListener();
            }
            var regex_src = /(.*)&tracks=(.*)/g;
            var reg_match_src = regex_src.exec(genomeViewSrc);
            genomeViewSrc = reg_match_src[1] + "&tracks=myInteractions%2C" + reg_match_src[2] ;

            console.log("Changing genomeViewSrc to" + genomeViewSrc);
            $("#genome-broswer").prop("src",genomeViewSrc);
            $("#genome-broswer-src")[0].innerHTML = genomeViewSrc;

            $('#reanalyse').prop("disabled","");
        }

        function appendInteractionInfo(index,value){
            //console.log(index);
            //console.log(value);
            /*
            var new_line="<tr><td style='width:25px'>{0}</td><td style='width:65px'>{1}</td><td style='width:125px'>{2}</td><td style='width:150px'><a href='javascript:;' class='LocusTD' onclick='changeSrcByLocus(this.innerHTML)'>{3}: {4}-{5}</a></td><td style='width:25px'>{6}</td><td style='width:60px'>{7}</td>" +
                "<td style='width:160px'>{8}</td><td style='width:160px'>{9}</td><td style='width:160px'>{10}</td><td style='width:70px'>{11}</td></tr>";
            $('#promoter-list-table').append(String.format(new_line,index+1,value.geneId,value.name,value.chr2,value.start2,value.end2,value.strand2,value.method,value.MF,value.CC,value.BP,value.enhancerName));
             */
            var new_row="<tr><td style='width: 30px'>%d</td><td style='width: 120px'>%s</td><td class='%s' style='width: 150px'>%s</td><td style='width: 150px'><a href='javascript:;' class='LocusTD' onclick='changeSrcByLocus(this.innerHTML)'>%s: %d-%d</a></td><td class='%s' style='width: 150px'>%s</td><td style='width: 150px'><a href='javascript:;' class='LocusTD' onclick='changeSrcByLocus(this.innerHTML)'>%s: %d-%d</a></td>" +
                "<td style='width: 150px'>%s</td><td style='width: 150px'>%s</td></tr>";

            if(value.interactionClass.length == 1){
                var query_class = "Q";
                var query_content = "Query Region";
                var inter_class = value.interactionClass;
            }else{
                var query_class = value.interactionClass[0];
                var inter_class = value.interactionClass[1];
                if(query_class == 'P'){
                    var query_content = sprintf("<a href='https://www.ncbi.nlm.nih.gov/gene/?term=%s' target='_blank\'>%s<table style='display: none;'><tr><td>Gene Name</td><td>%s</td></tr><tr><td>Molecular Function</td><td>%s</td></tr><tr><td>Cellular Component</td><td>%s</td></tr><tr><td>Biological Process</td><td>%s</td></tr></table></a>",value.queryId,value.symbol1,value.name1,value.MF1,value.CC1,value.BP1);
                }else{
                    var query_content = value.queryId.split("|")[0];
                }
            }
            if(inter_class == 'P'){
                var inter_content = sprintf("<a href='https://www.ncbi.nlm.nih.gov/gene/?term=%s' target='_blank\'>%s<table style='display: none;'><tr><td>Gene Name</td><td>%s</td></tr><tr><td>Molecular Function</td><td>%s</td></tr><tr><td>Cellular Component</td><td>%s</td></tr><tr><td>Biological Process</td><td>%s</td></tr></table></a>",value.interId,value.symbol2, value.name2,value.MF2,value.CC2,value.BP2);
            }else{
                var inter_content = value.interId.split("|")[0];
            }
            console.log(query_content);
            console.log(inter_content);
            $('#promoter-list-table').append(sprintf(new_row,index,value.interactionClass,query_class,query_content,value.chr1,value.start1,value.end1,inter_class,inter_content,value.chr2,value.start2,value.end2,value.method,value.bin));
        }

        function isExistFile(filepath){
            if(filepath ==null  ||filepath == undefined  || filepath =="" ){
                return false
            }
            var xmlhttp;
            if (window.XMLHttpRequest){
                xmlhttp=new XMLHttpRequest();
            }else{
                xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.open("GET",filepath,false);
            xmlhttp.send();
            if(xmlhttp.readyState==4){
                if(xmlhttp.status==200) return true; //url存在
                else if(xmlhttp.status==404) return false; //url不存在
                else return false;//其他状态
            }
        }



        function downloadURI(uri, name)
        {
            var link = document.createElement("a");
            // If you don't know the name or want to use
            // the webserver default set name = ''
            link.setAttribute('download', name);
            link.href = uri;
            document.body.appendChild(link);
            link.click();
            link.remove();
        }

        function initSrc(data){
            console.log("Genome:" + data.genome);
            console.log("Tracks return:" + data.trackString);
            console.log("Accession:" + data.accession);
            console.log("taskId:"+data.taskId)
            var genome = data.genome;
            var accession = data.accession;
            var taskId = data.taskId;
            if(data.trackString=="null"){
                console.log("No tracks available, using default tracks.");
                var trackToShow = defaultTrack;
            }else{
                console.log("Tracks found.");
                var trackToShow = data.trackString;
            }
            var anchorString = '<s:property value="searchForm.anchor"/>'
            var anchor = anchorString.split(':');
            left = parseInt(anchor[1])-50000;
            right = parseInt(anchor[1])+50000;
            if(left <= 0){
                left=1;
            }
            anchorString = "" + anchor[0] + "%3A" + left + ".." + right

            genomeViewSrc = "http://delta.big.ac.cn/jbrowse/index.html?data=" + genome + "&loc="  + anchorString + "&tracks=" + trackToShow
                + accession + "_Hiccups%2C" + accession + "_cLoops%2C" + accession + "_Homer" + "&highlight=" + "&addStores=%7B%22url%22%3A%7B%22type%22%3A%22JBrowse%2FStore%2FSeqFeature%2FGFF3%22%2C%22urlTemplate%22%3A%22192.168.117.41%3A8080%2FdeltaEPI%2Fdata%2Ftemp%2F"
                + taskId + "%2F" + accession + "%2FGFF%2F%7Brefseq%7D%2Farc.gff3%22%7D%7D&addTracks=%5B%7B%22label%22%3A%22myInteractions%22%2C%22type%22%3A%22JBrowse%2FView%2FTrack%2FCanvasFeatures%22%2C%22store%22%3A%22url%22%7D%5D%0A";
	    //"/deltaEPI/jbrowse/index.html?data="
            /*
            genomeViewSrc = "https://bigd.big.ac.cn/circosweb/jbrowse/index.html?data=" + genome + "&loc="  + anchorString + "&tracks=" + trackToShow
                + accession + "_Hiccups%2C" + accession + "_cLoops%2C" + accession + "_Homer" + "&highlight=" + "&addStores=%7B%22url%22%3A%7B%22type%22%3A%22JBrowse%2FStore%2FSeqFeature%2FGFF3%22%2C%22urlTemplate%22%3A%22https%3A%2F%2Fbigd.big.ac.cn%2FdeltaEPI%2Fdata%2Ftemp%2F"
                + taskId + "%2F" + accession + "%2FGFF%2F%7Brefseq%7D%2Farc.gff3%22%7D%7D&addTracks=%5B%7B%22label%22%3A%22myInteractions%22%2C%22type%22%3A%22JBrowse%2FView%2FTrack%2FCanvasFeatures%22%2C%22store%22%3A%22url%22%7D%5D%0A";
            */

            //https://delta.big.ac.cn/circosweb/jbrowse/index.html?data=hg19&loc=11%3A1..13149863&tracks=HEPI000026_Hiccups%2CHEPI000026_Homer%2CHEPI000026_cLoops&organism=hg19&sb=90&highlight=
            //"&tracks=GM12878_CTCF_signal%2CGM12878_H3K27ac_signal%2CGM12878_H3K27me3_signal%2CGM12878_H3K4me1_signal%2C"

            console.log("Changing genomeViewSrc to" + genomeViewSrc);
            $("#genome-broswer").prop("src",genomeViewSrc);
            $("#genome-broswer-src")[0].innerHTML = genomeViewSrc;
        }

        function changeSrcByLocus(temp){
            console.log(temp);
            var input_purified = temp.replace(/\s/g,"");

            var regex_locus = /(chr)?([0-9XY]{1,2}):(\d*)-(\d*)/g

            var reg_match_locus = regex_locus.exec(input_purified);

            var chrom = reg_match_locus[2];
            var start = parseInt(reg_match_locus[3]);
            var end = parseInt(reg_match_locus[4]);

            var mid = ( start + end ) / 2;
            //var left = 2 * start - end;
            var left = mid - 50000;
            if(left<=0){
                left=0;
            }
            //var right = 2 * end - start ;
            var right = mid + 50000;

            var regex_src = /(.*loc=)(.*)(&tracks.*)/g ;
            var reg_src_match = regex_src.exec(genomeViewSrc);


            var curr_genomeViewSrc = reg_src_match[1] + chrom + "%3A" + left + ".." + right + reg_src_match[3];

            $("#genome-broswer").prop("src",curr_genomeViewSrc);
            $("#genome-broswer-src")[0].innerHTML = curr_genomeViewSrc;
        }

        function genomeView(){
            window.open(genomeViewSrc,"_blank");
        }

    </script>

</head>


<body>


<div id="container" >
    <jsp:include page="/inc/menu.jsp" />
    <div id="content" style="">
        <div id="gene-result">
            <div id="promoter-list" style="margin: auto;width: 1000px;">
                <a href="javascript:;" id="test" onclick="slideResult(this)"><p style="text-align: center ;font-size: 1.2em ; font-weight: bold;color: #00ccff">EPI list</p></a>
                <div>
                    <p>
                        <input type="hidden" onclick="downloadURI(tableLink,'result.csv')" value="download" style="float: right;margin: 0 50px 10px 0;"/>
                        <!--<input type="hidden" onclick="genomeView()" value="View in Genome Browser" style="float: right;margin: 0 50px 10px 0;/">
                        -->
                    </p>
                    <br clear='all'>
                    <table id="promoter-list-table">
                        <!--
                        <thead>
                            <tr>
                                <th>index</th>
                                <th>Promoter ID</th>
                                <th>Chrom</th>
                                <th>Start</th>
                                <th>End</th>
                                <th>Strnd</th>
                                <th>Sig</th>
                                <th>Molecular Function</th>
                                <th>Cellular Component</th>
                                <th>Biological Process</th>
                                <th>(Enhancer ID)</th>

                            </tr>
                        </thead>
                        <tbody>
                          <tr>
                            <td>1</td>
                            <td>----</td>
                            <td>----</td>
                            <td>----</td>
                            <td>---</td>
                            <th>---</th>
                            <th>----</th>
                            <th>---------------------------------------------------</th>
                            <th>-------------------------------------------------</th>
                            <th>----------------------------------------------------</th>
                            <th>------------</th>
                            </tr>
                        </tbody>
                        -->
                    </table>
                </div>
            </div>
        </div>
        <div id='genome-view' style='width: 1000px;margin: 0 auto;'>
            <div  style='margin: auto;'>
                <a href="javascript:;" onclick="slideResult(this)"><p style="text-align: center ;font-size: 1.2em ; font-weight: bold;color: #00ccff">Genome View</p></a>
                <div>
                    <!--  -->
                    <p>
                        <input type="button" onclick="genomeView()" value="Browse in Full Screen" style="float: right;margin: 0 50px 10px 0;"/>
                    </p>
                    <br clear='all'>
                    <p id="genome-broswer-src" style="display: none"></p>
                    <iframe id="genome-broswer" src="" style="border: 1px solid black ;width:100%;height:600px;">
                    </iframe>
                </div>
            </div>
        </div>
        <div id="enrichment-result" style="width: 1000px; display: none">
            <div id="promoter-analysis" style="margin: auto;">
                <a href="javascript:;" onclick="slideResult(this)"><p style="text-align: center ;font-size: 1.2em ; font-weight: bold;color: #00ccff">GO Analysis</p></a>
                <div>
                    <p><input type="button" id="graphDownloadID" onclick="downloadURI(imageLink,'Go.png')" value="download" style="float: right;margin: 0 50px 10px 0;display: none;"/></p>
                    <br clear="all">
                    <p style="width:1000px;margin:0 auto; text-align: center">
                        <img src="/deltaEPI/images/loading.gif" style="margin: 0 auto;height: 30px; width: 30px;" id="enrichment_graph">
                    </p>
                </div>
            </div>
        </div>

        <br clear="all">
        <br>
        <div id="bottom-column-result" style="width: 1000px">
            <a href="javascript:;" onclick="slideResult(this)"><p style="text-align: center ;font-size: 1.2em ; font-weight: bold;color: #00ccff">Studies</p></a>
            <div>
                <form action="/deltaEPI/search/exportFile.action" name="export" method="post">
                    <div class="header_content" id="pagenavi">
                        <jsp:include page="/inc/page.jsp"></jsp:include>
                        <s:if test="page!=null&page.rowFrom==0">
                            <s:set var="row" value="0" />
                        </s:if>
                        <s:else>
                            <s:set var="row" value="page.rowFrom-1" />
                        </s:else>
                    </div>

                    <input type="hidden" name="pagesize" value="<s:property value='page.pageSize'/>" />

                    <!--Research Series  Descriptions Interactions ValidPairs-->
                    <table  width=100% align="center" id="study-table" class="searchresult" style="text-align: center; ">
                        <tbody>
                        <tr>
                            <p style="text-align: left; font-size: 0.8em;">*:The first research entry is analysed by default. Click another checkbox to reanalyse.</p>
                        </tr>
                        <tr>
                            <th width="50px" height="40" style="text-align: center;">Selection</th>
                            <th width="150px" height="40" style="text-align: center;">Research Series</th>
                            <th width="350px" height="40" style="text-align: center;">Description</th>
                            <th width="100px" height="40" style="text-align: center;">Tissue</th>
                            <th width="100px" height="40" style="text-align: center;">Cell Type</th>
                            <th width="100px" height="40" style="text-align: center;">Cell Line</th>
                            <th width="150px" height="40" style="text-align: center;">Valid Contact Pairs</th>

                        </tr>

                        <s:iterator value="entryResultList" var="entryInfoBean" status="rowcount">
                            <s:set var="row"  value="#row+1" />
                            <tr>
                                <td height="40" style="text-align: left;background-color: #FFF"><input type="checkbox" name="entryCheckBox" value="<s:property value='#entryInfoBean.accessionVal'/>" /><s:property value="#row" /></td>
                                <td height="40" style="text-align: center; background-color: #FFF">
                                    <a href="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=<s:property value="#entryInfoBean.GSE"/>" target="_blank"><s:property value="#entryInfoBean.GSE"/></a>
                                </td>
                                <td height="40" style="text-align: center;background-color: #FFF">
                                    <a href="javascript:;" onclick="slideDetail(this)"><s:property value="#entryInfoBean.title"/></a>
                                </td>
                                <td height="40" style="text-align: center;background-color: #FFF">
                                    <s:property value="#entryInfoBean.tissueType"/>
                                </td>
                                <td height="40" style="text-align: center;background-color: #FFF">
                                    <s:property value="#entryInfoBean.cellType"/>
                                </td>
                                <td height="40" style="text-align: center;background-color: #FFF">
                                    <s:property value="#entryInfoBean.cellLine"/>
                                </td>
                                <td height="40" style="text-align: center;background-color: #FFF">
                                    <s:property value="#entryInfoBean.validPairCount"/>
                                </td>
                            </tr>
                            <tr><td colspan="7">
                                <div style="height: 200px; width:900px;padding: 25px 50px">
                                    <table>
                                        <tr>
                                            <td style="font-weight: bold;">Merged GSM : </td>
                                            <td>&nbsp; &nbsp; &nbsp; &nbsp; <s:property value="#entryInfoBean.GSM"/></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Growth Protocol : </td>
                                            <td>&nbsp; &nbsp; &nbsp; &nbsp; <s:property value="#entryInfoBean.growthProtocol"/></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Treatment Protocol : </td>
                                            <td>&nbsp; &nbsp; &nbsp; &nbsp; <s:property value="#entryInfoBean.treatmentProtocol"/></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Extraction Protocol : </td>
                                            <td>&nbsp; &nbsp; &nbsp; &nbsp; <s:property value="#entryInfoBean.extractionProtocol"/></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Data Processing : </td>
                                            <td>&nbsp; &nbsp; &nbsp; &nbsp; <s:property value="#entryInfoBean.dataProcessing"/></td>
                                        </tr>
                                    </table>
                                </div>
                            </td></tr>
                        </s:iterator>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>



<script type="text/javascript" language="javascript">
    showTabs('1');

    function setGeneListener(){
        $("td.P").mouseover(function(e){       //mouse moves over
            //var myTitle=this.title;
            //var imgTitle=myTitle?"<br/>"+myTitle:"";	//get the title of image
            console.log("mouseover action detected");
            console.log($(this)[0].innerHTML);
            $(this).css("background-color","#bababa");
            var gene_detail_view=$('<div id="gene_detail" style="background-color: #F1F5EC;width: 400px;height:150px;">' + $(this).find("table")[0].innerHTML + '</div>'); //build image div
            $("body").append(gene_detail_view);
            $("#gene_detail table").css("display","table");
            $("#gene_detail").css({"top":(e.pageY+20)+"px","left":(e.pageX+10)+"px"});  //CSS position property should be set as 'absolute'绝对定位
        }).mousemove(function(e){
            $("#gene_detail").css({"display":"table","top":(e.pageY+20)+"px","left":(e.pageX+10)+"px"});	//update cordinates when mouse moves
        }).mouseout(function(){
            console.log("mouseout action detected");
            $(this).css("background-color","");
            $("#gene_detail").remove();	//remove div when mouseout
        });

    }


    function add_checkbox_listeners(){
        var checkbox_objects = document.getElementsByName("entryCheckBox");
        for(var i=0;i<checkbox_objects.length;i++){
            var check = checkbox_objects[i];
            console.log("add listener for ");
            console.log(check);
            check.addEventListener("change",function (){
                var checkbox_objects = document.getElementsByName("entryCheckBox");
                console.log("refresh checkbox selection by");
                console.log(this);
                if (!this.checked){
                    console.log("Cancel action, no need for check.");
                }
                else{
                    for(var i=0;i<checkbox_objects.length;i++) {
                        var check = checkbox_objects[i];
                        console.log("Doing check for "+check);
                        console.log("Status:"+ check.checked);
                        if (check != this && check.checked) {
                            check.checked=false;
                        }
                    }
                }
            });

        }
    }

    add_checkbox_listeners();

    function reanalyseEntry(){

        var checkbox_objects = document.getElementsByName("entryCheckBox");
        for(var i=0;i<checkbox_objects.length;i++){
            var selected_entry = null;
            var check = checkbox_objects[i];
            if(check.checked==true){
                selected_entry = check;
                break;
            }
        }
        if(selected_entry==null){
            alert("Please select one entry to analyse!");
            return;
        }
        var accession_val = selected_entry.value;
        var cell_line = S($(selected_entry).closest("tr").find("td")[5].innerHTML).stripLeft('\n ').stripRight('\n ').s;
        accession = sprintf("HEPI%06d",accession_val);
        var task_id = '<s:property value="searchForm.taskId"/>' ;
        var species_name = '<s:property value="searchForm.speciesName"/>' ;
        //var params_cell_line = {"accessionVal":accession_val,"species":species_name,"cellLine":cell_line};
        var params = {"accessionVal":accession_val,"species":species_name,"taskId":task_id,"cellLine":cell_line};
        console.log(params);


        $('#reanalyse').prop("disabled","disabled");

        $('#enrichment_graph').prop('src',"/deltaEPI/images/loading.gif");
        $('#enrichment_graph').css('height',"30px");
        $('#enrichment_graph').css('width',"30px");

        $('#promoter-list-table').empty();
        loading_image = '<img src="/deltaEPI/images/loading.gif" style="margin: 0 auto; width: 30px; height: 30px;">';
        $('#promoter-list-table').append(loading_image);
        $('#promoter-list').find('p input').prop('type','hidden');

        console.log("Analysis step one starts");
        $.ajax({
            //url : window.location.protocol+'//bigd.big.ac.cn/deltaEPI/ajax/entryProcessGetTrack.action?time='+new Date().getTime(),
            url : '/deltaEPI/ajax/entryProcessGetTrack.action?time='+new Date().getTime(),
            type : 'get',
            data : params,
            dataType : 'json',
            success : initSrc,
            error : logError
        });
        var step_one_ajax =
        $.ajax({
            //url : window.location.protocol+'//bigd.big.ac.cn/deltaEPI/ajax/entryProcessStepOne.action?time='+new Date().getTime(),
            url : '/deltaEPI/ajax/entryProcessStepOne.action?time='+new Date().getTime(),
            type : 'get',
            data : params,
            dataType : 'json',
            success : refreshTable,
            error : logError
        });

        /*
        genomeViewSrc = genomeViewSrc.replace(/HEPI[0-9]{6}/,accession);

        $("#genome-broswer").prop("src",genomeViewSrc);
        $("#genome-broswer-src")[0].innerHTML = genomeViewSrc;
        */

        /*
        $.when(step_one_ajax).done(function(){
            console.log("Analysis step two starts");
            $.ajax({
                url : '/deltaEPI/ajax/entryProcessStepTwo.action?time='+new Date().getTime(),
                type : 'post',
                data : params,
                dataType : 'json',
                success : refreshGraph,
                error : logError
            });
        });
    */
        return;
    }



</script>
</body>
</html>
