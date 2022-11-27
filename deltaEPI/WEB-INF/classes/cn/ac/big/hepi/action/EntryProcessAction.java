package cn.ac.big.hepi.action;


import cn.ac.big.hepi.po.GeneInfoBean;
import cn.ac.big.hepi.po.TrackBean;
import cn.ac.big.hepi.util.EntryProcess;

import cn.ac.big.hepi.po.InteractionInfoBean;
//import cn.ac.big.hepi.po.TrackBean;

import cn.ac.big.hepi.service.IBaseService;
import cn.ac.big.hepi.util.Page;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.nio.file.*;
import java.util.*;
import java.io.*;
/***********************************************
 * this used to get all entry with detailed information using searchform
 * @zyy
 */
/*
 */

public class EntryProcessAction extends ActionSupport {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Resource(name = "baseService")
	private IBaseService baseService;

	private List<InteractionInfoBean> interactionInfoList =new ArrayList<>();
	private String trackString;

	private GeneInfoBean geneInfo = new GeneInfoBean() ;


	private String species;
	private String genome;
	private String taskId;
	private int accessionVal;
	private String accession;
	private String cellLine;
	private int displayPair;
	private int useDataset;

	/*
	private static final File classDir = new File(EntryResultAction.class.getProtectionDomain().getCodeSource().getLocation().getPath());
	private static final File jbrowseDir = new File(classDir,"./../../jbrowse");
	//private static final File templatePath = new File(jbrowseDir,"trackList_template.json");
	private static final File genomeDir = new File(jbrowseDir,"genome_refseq");

	private static final String jsonSetting = "{  \n" +
			"\"key\" : \"task_<taskId>_<accession>\",\n" +
			"\"feature\" : [\n" +
			"\t\"arc\"\n" +
			"],       \n" +
			"\"storeClass\" : \"JBrowse/Store/SeqFeature/GFF3\",\n" +
			"\"category\" : \"My track\",       \n" +
			"\"autocomplete\" : \"all\",\n" +
			"\"track\" : \"ARC\",\n" +
			"\"style\" : {\n" +
			"\t\"className\" : \"feature\",\n" +
			"\t\"showLabels\": false,\n" +
			"\t\"showTooltips\":false\n" +
			"},\n" +
			"\t\"chunkSizeLimit\" : \"10000000\",\n" +
			"\t\"maxFeatureScreenDensity\" : \"20\" , \n" +
			"\t\"trackType\" : \"src/JBrowse/View/Track/CanvasFeatures\",\n" +
			"\t\"urlTemplate\" : \"tracks/<accession>/{refseq}/arc.gff3\",\n" +
			"\t\"compress\" : 0,\n" +
			"\t\"label\" : \"<taskId>_<accession>\",\n" +
			"\t\"type\" : \"src/JBrowse/View/Track/CanvasFeatures\"\n" +
			"},\n" ;
	 */

	/*****************************************
	 * THIS USED TO invoke back-end intersect calculation from result.jsp
	 * @return
	 */
	public String execEntryProcessGetTrackFunc() throws Exception{
		setGenome();
		setAccession();
		System.out.println("In EntryProcessGetTrack:");
		System.out.println("species: "+ species);
		System.out.println("cellLine: "+cellLine);
		System.out.println("genome: "+genome);
		System.out.println("accessionVal: "+ accessionVal);
		System.out.println("accession: "+ accession);


		Map map = new HashMap();
		map.put("name",this.cellLine);
		TrackBean currTrack ;
		currTrack=(TrackBean)baseService.findObjectByObject("cn.ac.big.hepi.track.getTrackByName",map);
		if(currTrack!=null){
			trackString = currTrack.getTrack();
		}else{
			trackString = "null";
		}
		return SUCCESS;
	}

	public String execEntryProcessStepOneFunc(){
		try{
			setGenome();
			setAccession();
			System.out.println("taskId: "+ taskId);
			System.out.println("species: "+ species);

			System.out.println("genome: "+genome);
			System.out.println("accessionVal: "+ accessionVal);
			System.out.println("accession: "+ accession);
			System.out.println("cellLine: " + cellLine);

			System.out.println("displayPair: " + displayPair);
			System.out.println("useDataset: " + useDataset);

			EntryProcess curr = new EntryProcess(this.genome,this.accession,this.taskId,this.displayPair,this.useDataset,this.cellLine);
			int exitStatus = curr.runProcessOne();

			if (exitStatus == 1){
				System.out.println("Error: source data not found, could not do analysis.");
			}else if(exitStatus == 2){
				System.out.println("Error occured when doing analysis. Please check the output.");
			}else if(exitStatus == 0 || exitStatus == 3) {
				System.out.println("Successfully generating result file. Proceeding to outputfile reading..");
				File resultInfoPath = curr.getResultInfoFile();
				File resultDownloadPath = curr.getResultDownloadFile();
				readInteractionInfo(resultInfoPath,resultDownloadPath);
			/*
			if(exitStatus == 0){
				System.out.println(String.format("The entry %s has not been analysed for task %s, proceeding to visualization file generation",accession,taskId));
				writeGFFAndJson();
			}else{
				System.out.println(String.format("The entry %s has been analysed for task %s",accession,taskId));
			}
			 */
			}
		}catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}

	public String execEntryProcessStepTwoFunc(){
		try {
			setGenome();
			setAccession();
			System.out.println("taskId: " + taskId);
			System.out.println("species: " + species);
			System.out.println("genome: " + genome);
			System.out.println("accessionVal: " + accessionVal);
			System.out.println("accession: " + accession);

			EntryProcess curr = new EntryProcess(this.genome, this.accession, this.taskId);
			int exitStatus = curr.runProcessTwo();

			if (exitStatus == 1) {
				System.out.println("Error: source data not found, could not do analysis.");
			} else if (exitStatus == 2) {
				System.out.println("Error occured when doing analysis. Please check the output.");
			} else if (exitStatus == 0) {
				System.out.println("Successfully doing enrichment analysis.");
			}
		}catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}

	private void readInteractionInfo(File path1,File path2) throws Exception{
		BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(path1), "utf-8"));
		BufferedWriter writer = new BufferedWriter(new FileWriter(path2));
		String line = null;
		reader.readLine();//显示标题行,没有则注释掉
		//System.out.println(reader.readLine());
		writer.write("\"Index\",\"Chr1\",\"Start1\",\"End1\",\"Chr2\",\"Start2\",\"End2\",\"Query_id\",\"Inter_id\",\"Strand1\",\"Strand2\",\"Method\",\"Bin_size\",\"Interaction_class\",\"Name1\",\"Symbol1\",\"BP1\",\"CC1\",\"MF1\",\"Name2\",\"Symbol2\",\"BP2\",\"CC2\",\"MF2\"");
		writer.newLine();

		int index = 0;
		while ((line = reader.readLine()) != null) {
			index++;
			InteractionInfoBean currLine = new InteractionInfoBean();
			String item[] = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");//CSV格式文件时候的分割符,我使用的是,号

			for(int i=0 ; i < item.length ; i++){
				item[i] = item[i].replaceAll("\"","");
			}

			currLine.setChr1(item[0]);
			currLine.setStart1(Integer.parseInt(item[1]));
			currLine.setEnd1(Integer.parseInt(item[2]));

			currLine.setChr2(item[3]);
			currLine.setStart2(Integer.parseInt(item[4]));
			currLine.setEnd2(Integer.parseInt(item[5]));

			currLine.setQueryId(item[6]);
			currLine.setInterId(item[7]);

			currLine.setStrand1(item[8]);
			currLine.setStrand2(item[9]);
			currLine.setClass1(item[10]);
			currLine.setClass2(item[11]);

			currLine.setMethod(item[12]);
			currLine.setBin(item[13]);
			currLine.setInteractionClass(item[14]);

			Map map = new HashMap();
			if(item[6].matches("\\d+")){
				map.put("entrezId",item[6]);
				geneInfo = (GeneInfoBean) baseService.findObjectByObject("cn.ac.big.hepi.info.getGeneInfo", map);

				currLine.setName1(geneInfo.getGeneName());
				currLine.setBP1(geneInfo.getGoBp());
				currLine.setCC1(geneInfo.getGoCc());
				currLine.setMF1(geneInfo.getGoMf());
				currLine.setSymbol1(geneInfo.getGeneSymbol());
			}else{
				currLine.setName1(".");
				currLine.setBP1(".");
				currLine.setCC1(".");
				currLine.setMF1(".");
				currLine.setSymbol1(".");
			}
			if(item[7].matches("\\d+")){
				map.put("entrezId",item[7]);
				geneInfo = (GeneInfoBean) baseService.findObjectByObject("cn.ac.big.hepi.info.getGeneInfo", map);

				currLine.setName2(geneInfo.getGeneName());
				currLine.setBP2(geneInfo.getGoBp());
				currLine.setCC2(geneInfo.getGoCc());
				currLine.setMF2(geneInfo.getGoMf());
				currLine.setSymbol2(geneInfo.getGeneSymbol());
			}else{
				currLine.setName2(".");
				currLine.setBP2(".");
				currLine.setCC2(".");
				currLine.setMF2(".");
				currLine.setSymbol2(".");
			}



			interactionInfoList.add(currLine);
			writer.write(String.format("%d,\"%s\",%s,%s,\"%s\",%s,%s,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",
					index, item[0], item[1], item[2], item[3], item[4], item[5], item[6], item[7], item[8], item[9], item[10],
					item[11], item[12], item[13], item[14], currLine.getName1(),currLine.getSymbol1(), currLine.getBP1(), currLine.getCC1(),
					currLine.getMF1(), currLine.getName2(),currLine.getSymbol2(), currLine.getBP2(), currLine.getCC2(),currLine.getMF2()));
			writer.newLine();
		}
		writer.close();
	}
	/*
	private void writeGFFAndJson() throws Exception{
		File taskJbrowseDir = new File(jbrowseDir,taskId);
		File refSeqDir = new File(taskJbrowseDir,"seq");
		File tracksDir = new File(taskJbrowseDir,"tracks");
		File jsonPath = new File(taskJbrowseDir,"trackList.json");
		System.out.println("Finding visualization directory :" + taskJbrowseDir.toString());
		if( ! taskJbrowseDir.isDirectory()){
			System.out.println("Fail to find visualization directory for " + taskId + ", proceeding to de novo craation.");

			//copy refseq file
			refSeqDir.mkdirs();
			File referenceGenome = new File(genomeDir,String.format("refSeqs_%s.json",genome));
			File refSeqPath = new File(refSeqDir,"refSeqs.json");
			if(referenceGenome.exists()){
				Files.copy(referenceGenome.toPath(),refSeqPath.toPath());
			}

			//write new trackList json file
			BufferedWriter writer = new BufferedWriter(new FileWriter(jsonPath));
			writer.write("{\"tracks\" : [\n],\n\n");
			writer.write(String.format("\"dataset_id\" : <taskId>,\n",taskId));
			writer.write("\"formatVersion\" : 1\n}");
			writer.close();
		}

		updateJson(jsonPath);

		//writeGFF();

	}

	private void updateJson(File jsonFile) throws Exception{
		BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(jsonFile), "utf-8"));
		String message;
		StringBuffer sb = new StringBuffer();

		message = reader.readLine();
		sb.append(message+"\n");

		String currInfo = jsonSetting.replaceAll("<accession>",accession).replaceAll("<taskId>",taskId);
		sb.append(currInfo);

		while((message = reader.readLine()) != null) {
			message+="\n";
			sb.append(message);
		}
		reader.close();

		BufferedWriter writer = new BufferedWriter(new FileWriter(jsonFile));
		writer.write(sb.toString());
		writer.close();

		return;
	}

	private void writeGFF(File gffDir){

	}
	*/

	private void setGenome(){
		if(this.species.equals("Homo_sapiens")){
			this.genome = "hg38";
		}else if(this.species.equals("Mus_musculus")){
			this.genome = "mm10";
		}else if(this.species.equals("Macaca_mulatta")){
			this.genome = "rheMac10";
		}
	}
	//addTracks=%5B%7B%22label%22%3A%22mytrack%22%2C%22type%22%3A%22JBrowse%2FView%2FTrack%2FHTMLFeatures%22%2C%22urlTemplate%22%3A%221610951422953%2Ftracks%2FHEPI000028_cLoops%22%7D%5D
	//addStores={"url":{"type":"JBrowse/Store/SeqFeature/GFF3","urlTemplate":"1610951422953/tracks/HEPI00028_cLoops"}}&addTracks=[{"label":"genes","type":"JBrowse/View/Track/CanvasFeatures","store":"url"}]
	//addStores={"url":{"type":"JBrowse/Store/SeqFeature/GFF3","baseUrl":".","urlTemplate":"{dataRoot}/../1610951422953/tracks/HEPI000028_cLoops/{refseq}/arc.gff3"}}&addTracks=[{"label":"mytrack","type":"JBrowse/View/Track/CanvasFeatures","store":"url"}]
	private void setAccession(){
		this.accession = String.format("HEPI%06d",this.accessionVal);
	}

	public String getGenome() {
		return genome;
	}

	public String getAccession() {
		return accession;
	}

	public List<InteractionInfoBean> getInteractionInfoList() {
		return interactionInfoList;
	}

	public void setInteractionInfoList(List<InteractionInfoBean> interactionInfoList) {
		this.interactionInfoList = interactionInfoList;
	}

	public String getSpecies() {
		return species;
	}

	public void setSpecies(String species) {
		this.species = species;
	}



	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public int getAccessionVal() {
		return accessionVal;
	}

	public void setAccessionVal(int accessionVal) {
		this.accessionVal = accessionVal;
	}

	public void setAccession(String accession) {
		this.accession = accession;
	}

	public String getCellLine() {
		return cellLine;
	}

	public void setCellLine(String cellLine) {
		this.cellLine = cellLine;
	}

	public String getTrackString() {
		return trackString;
	}

	public void setTrackString(String trackString) {
		this.trackString = trackString;
	}

	public void setDisplayPair(int displayPair) {
		this.displayPair = displayPair;
	}

	public void setUseDataset(int useDataset) {
		this.useDataset = useDataset;
	}
}