package cn.ac.big.hepi.po;

/*********************************************
 * this used to process chromosome information
 * @author sweeter
 *
 */
public class TrackBean {
	private int index;
	private String name;
	private String track;

	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTrack() {
		return track;
	}

	public void setTrack(String track) {
		this.track = track;
	}

	@Override
	public String toString() {
		return "TrackBean{" +
				"index=" + index +
				", name='" + name + '\'' +
				", default tracks to show ='" + track + '\'' +
				'}';
	}
}
