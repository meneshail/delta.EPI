package cn.ac.big.hepi.po;

/*********************************************
 * this used to process chromosome information
 * @author sweeter
 *
 */
public class GeneInfoBean {
	private int entrezId;

	private String speciesName;
	private String geneName;
	private String geneSymbol;
	private String goBp;
	private String goCc;
	private String goMf;



	public int getEntrezId() {
		return entrezId;
	}

	public void setEntrezId(int entrezId) {
		this.entrezId = entrezId;
	}

	public String getSpeciesName() {
		return speciesName;
	}

	public void setSpeciesName(String speciesName) {
		this.speciesName = speciesName;
	}

	public String getGeneName() {
		return geneName;
	}

	public void setGeneName(String geneName) {
		this.geneName = geneName;
	}

	public String getGoBp() {
		return goBp;
	}

	public void setGoBp(String goBp) {
		this.goBp = goBp;
	}

	public String getGoCc() {
		return goCc;
	}

	public void setGoCc(String goCc) {
		this.goCc = goCc;
	}

	public String getGoMf() {
		return goMf;
	}

	public void setGoMf(String goMf) {
		this.goMf = goMf;
	}

	public String getGeneSymbol() {
		return geneSymbol;
	}

	public void setGeneSymbol(String geneSymbol) {
		this.geneSymbol = geneSymbol;
	}
}
