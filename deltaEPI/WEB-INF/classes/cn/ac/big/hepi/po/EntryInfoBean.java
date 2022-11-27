package cn.ac.big.hepi.po;

public class EntryInfoBean {
	private int accessionVal;
	private String title;
	private int speciesIndex;
	private String speciesName;
	private String tissueType;
	private String cellType;
	private String cellLine;
	private int cellLineIndex;
	private String enzymeName;
	private String GSE;
	private String GSM;
	private String growthProtocol;
	private String treatmentProtocol;
	private String extractionProtocol;
	private String dataProcessing;
	private String condDetail;
	private int validPairCount;

	public int getAccessionVal() {
		return accessionVal;
	}

	public void setAccessionVal(int accessionVal) {
		this.accessionVal = accessionVal;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

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

	public String getEnzymeName() {
		return enzymeName;
	}

	public void setEnzymeName(String enzymeName) {
		this.enzymeName = enzymeName;
	}

	public String getGSE() {
		return GSE;
	}

	public void setGSE(String GSE) {
		this.GSE = GSE;
	}

	public String getGSM() {
		return GSM;
	}

	public void setGSM(String GSM) {
		this.GSM = GSM;
	}

	public String getGrowthProtocol() {
		return growthProtocol;
	}

	public void setGrowthProtocol(String growthProtocol) {
		this.growthProtocol = growthProtocol;
	}

	public String getTreatmentProtocol() {
		return treatmentProtocol;
	}

	public void setTreatmentProtocol(String treatmentProtocol) {
		this.treatmentProtocol = treatmentProtocol;
	}

	public String getExtractionProtocol() {
		return extractionProtocol;
	}

	public void setExtractionProtocol(String extractionProtocol) {
		this.extractionProtocol = extractionProtocol;
	}

	public String getDataProcessing() {
		return dataProcessing;
	}

	public void setDataProcessing(String dataProcessing) {
		this.dataProcessing = dataProcessing;
	}

	public String getCondDetail() {
		return condDetail;
	}

	public void setCondDetail(String condDetail) {
		this.condDetail = condDetail;
	}

	public int getValidPairCount() {
		return validPairCount;
	}

	public void setValidPairCount(int validPairCount) {
		this.validPairCount = validPairCount;
	}
}
