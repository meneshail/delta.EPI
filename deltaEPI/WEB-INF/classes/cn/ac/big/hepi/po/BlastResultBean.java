package cn.ac.big.hepi.po;

/*********************************************
 * this used to process chromosome information
 * @author sweeter
 *
 */
public class BlastResultBean {
	private String chromosome;
	private int start;
	private int end;

	private Float identity;
	private Float qValue;
	private Float score;

	private int exitStatus;

	public String getChromosome() {
		return chromosome;
	}

	public void setChromosome(String chromosome) {
		this.chromosome = chromosome;
	}

	public int getStart() {
		return start;
	}

	public void setStart(int start) {
		this.start = start;
	}

	public int getEnd() {
		return end;
	}

	public void setEnd(int end) {
		this.end = end;
	}

	public int getExitStatus() {
		return exitStatus;
	}

	public void setExitStatus(int exitStatus) {
		this.exitStatus = exitStatus;
	}

	public Float getIdentity() {
		return identity;
	}

	public void setIdentity(Float identity) {
		this.identity = identity;
	}

	public Float getqValue() {
		return qValue;
	}

	public void setqValue(Float qValue) {
		this.qValue = qValue;
	}

	public Float getScore() {
		return score;
	}

	public void setScore(Float score) {
		this.score = score;
	}
}
