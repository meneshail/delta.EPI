package cn.ac.big.hepi.action;

import cn.ac.big.hepi.po.ChromBean;

import cn.ac.big.hepi.service.IBaseService;
import com.opensymphony.xwork2.ActionSupport;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChromAction extends ActionSupport{

	/**
	 *
	 */
	private static final long serialVersionUID = -2872302807193011121L;

	private List<ChromBean> chromList;

	private String speciesName;

	@Resource(name="baseService")
	private IBaseService baseService;
	/***********************************************
	 * this used to get all cell line from tb_cell_line
	 * @return
	 */

	public String execGetChromListFunc(){
		try{
			Map map = new HashMap();
			map.put("speciesName",this.speciesName);
			chromList = baseService.findResultList("cn.ac.big.hepi.chrom.selectChromBySpecies", map);

		} catch(Exception e){
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

	public List<ChromBean> getChromList() {
		return chromList;
	}

	public void setChromList(List<ChromBean> chromList) {
		this.chromList = chromList;
	}
}
