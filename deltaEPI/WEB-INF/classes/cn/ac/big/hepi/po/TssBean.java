package cn.ac.big.hepi.po;

/*********************************************
 * this used to process chromosome information
 * @author sweeter
 *
 */
public class TssBean {
	private int index;
	private String entrezId;
	private String chrom;
	private int tss;
	private int tssStart;
	private int tssEnd;

	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}

	public String getEntrezId() {
		return entrezId;
	}

	public void setEntrezId(String entrezId) {
		this.entrezId = entrezId;
	}

	public String getChrom() {
		return chrom;
	}

	public void setChrom(String chrom) {
		this.chrom = chrom;
	}

	public int getTss() {
		return tss;
	}

	public void setTss(int tss) {
		this.tss = tss;
	}

	public int getTssStart() {
		return tssStart;
	}

	public void setTssStart(int tssStart) {
		this.tssStart = tssStart;
	}

	public int getTssEnd() {
		return tssEnd;
	}

	public void setTssEnd(int tssEnd) {
		this.tssEnd = tssEnd;
	}

	@Override
	public String toString() {
		return "TssBean{" +
				"index=" + index +
				", entrezId='" + entrezId + '\'' +
				", chrom='" + chrom + '\'' +
				", tss=" + tss +
				", tssStart=" + tssStart +
				", tssEnd=" + tssEnd +
				'}';
	}
}
