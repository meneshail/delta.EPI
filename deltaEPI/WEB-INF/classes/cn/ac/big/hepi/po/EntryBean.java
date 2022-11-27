package cn.ac.big.hepi.po;

public class EntryBean {
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
}
