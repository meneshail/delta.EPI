package cn.ac.big.hepi.action;

import cn.ac.big.hepi.po.GeneIdBean;
import cn.ac.big.hepi.service.IBaseService;
import com.opensymphony.xwork2.ActionSupport;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GeneIdAction extends ActionSupport{

	/**
	 *
	 */
	private static final long serialVersionUID = -2872302807193011121L;

	private List<GeneIdBean> geneList;

	private String speciesName;
	private String identifier;

	@Resource(name="baseService")
	private IBaseService baseService;
	/***********************************************
	 * this used to get all cell line from tb_cell_line
	 * @return
	 */

	public String execGetEntrezIdFunc(){
		try {
			Map map = new HashMap();
			System.out.println(this.speciesName);
			System.out.println(this.identifier);
			map.put("speciesName",this.speciesName);
			map.put("identifier",this.identifier);
			geneList = baseService.findResultList("cn.ac.big.hepi.chrom.getEntrezId", map);
		}catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}

	public String getSpeciesName() {
		return speciesName;
	}

	public void setSpeciesName(String speciesName) {
		this.speciesName = speciesName;
	}

	public List<GeneIdBean> getGeneList() {
		return geneList;
	}

	public void setGeneList(List<GeneIdBean> geneList) {
		this.geneList = geneList;
	}

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}
}
