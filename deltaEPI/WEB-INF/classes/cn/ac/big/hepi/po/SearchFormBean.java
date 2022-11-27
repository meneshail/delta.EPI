package cn.ac.big.hepi.po;

public class SearchFormBean {
	private int speciesIndex;
	private String speciesName;
	private String tissueType;
	private String cellType;
	private String cellLine;
	private int cellLineIndex;
	private String chrom;
	private String start;
	private String end;
	private String taskId;
	private int searchMode;
	private int onlyVehicle;

	private String anchor;


	public String getSpeciesName() {
		return speciesName;
	}

	public void setSpeciesName(String speciesName){
		this.speciesName = speciesName;
	}

	public int getSpeciesIndex() {
		return speciesIndex;
	}

	public void setSpeciesIndex(int speciesIndex) {
		this.speciesIndex = speciesIndex;
	}

	public String getTissueType() {
		return tissueType;
	}

	public void setTissueType(String tissueType) {
		this.tissueType = tissueType;
	}

	public String getCellType() {
		return cellType;
	}

	public void setCellType(String cellType){
		this.cellType = cellType;
	}

	public int getCellLineIndex() {
		return cellLineIndex;
	}

	public void setCellLineIndex(int cellLineIndex) {
		this.cellLineIndex = cellLineIndex;
	}

	public String getCellLine() {
		return cellLine;
	}

	public void setCellLine(String cellLine){
		this.cellLine = cellLine;
	}

	public String getChrom() {
		return chrom;
	}

	public void setChrom(String chrom) {
		this.chrom = chrom;
	}

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

	public int getOnlyVehicle() {
		return onlyVehicle;
	}

	public void setOnlyVehicle(int onlyVehicle) {
		this.onlyVehicle = onlyVehicle;
	}

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public int getSearchMode() {
		return searchMode;
	}

	public void setSearchMode(int searchMode) {
		this.searchMode = searchMode;
	}

	public String getAnchor() {
		return anchor;
	}

	public void setAnchor(String anchor) {
		this.anchor = anchor;
	}
}
