package cn.ac.big.hepi.po;

/*********************************************
 * this used to process chromosome information
 * @author sweeter
 *
 */
public class GeneIdBean {
	private String entrezId;
	private String identifier;
	private String database;
	private String speciesName;
	private String geneName;

	public String getEntrezId() {
		return entrezId;
	}

	public void setEntrezId(String entrezId) {
		this.entrezId = entrezId;
	}

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public String getDatabase() {
		return database;
	}

	public void setDatabase(String database) {
		this.database = database;
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
}
