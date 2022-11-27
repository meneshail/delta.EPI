package cn.ac.big.hepi.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.ac.big.hepi.po.EntryBean;

import cn.ac.big.hepi.service.IBaseService;
import com.opensymphony.xwork2.ActionSupport;

import javax.annotation.Resource;


public class EntryAction extends ActionSupport{

	/**
	 *
	 */
	private static final long serialVersionUID = -2872302807193011121L;

	private List<EntryBean> entryList;

	private String speciesName;
	private String tissueType;
	private String cellType;
	private String cellLine;

	@Resource(name="baseService")
	private IBaseService baseService;
	/***********************************************
	 * this used to get all cell line from tb_cell_line
	 * @return
	 */
	public String execGetAllSpeciesFunc(){
		try{
			entryList = baseService.findResultList("cn.ac.big.hepi.entry.selectAllSpecies", null);
		} catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}return SUCCESS;
	}

	public String execGetAllTissueFunc(){
		try{
			entryList = baseService.findResultList("cn.ac.big.hepi.entry.selectAllTissue", null);
		} catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}return SUCCESS;
	}

	public String execGetAllCellTypeFunc(){
		try{
			entryList = baseService.findResultList("cn.ac.big.hepi.entry.selectAllCellType", null);
		} catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}

	public String execGetAllCellLineFunc(){
		try {
			entryList = baseService.findResultList("cn.ac.big.hepi.entry.selectAllCellLine", null);
		} catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}

	public String execGetConditionalTissueFunc(){
		try{
			Map map = new HashMap();
			if(! "All".equals(speciesName)){
				map.put("speciesName",this.speciesName);
			}
			if(! "All".equals(cellType)){
				map.put("cellType",this.cellType);
			}
			if(! "All".equals(cellLine)){
				map.put("cellLine",this.cellLine);
			}
			entryList = baseService.findResultList("cn.ac.big.hepi.entry.conditionalTissue", map);
		} catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}

	public String execGetConditionalCellTypeFunc(){
		try{
			Map map = new HashMap();
			if(! "All".equals(speciesName)){
				map.put("speciesName",this.speciesName);
			}
			if(! "All".equals(tissueType)){
				map.put("tissueType",this.tissueType);
			}
			if(! "All".equals(cellLine)){
				map.put("cellLine",this.cellLine);
			}
			entryList = baseService.findResultList("cn.ac.big.hepi.entry.conditionalCellType", map);
		} catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}

	public String execGetConditionalCellLineFunc(){
		try {
			Map map = new HashMap();
			if (!"All".equals(speciesName)) {
				map.put("speciesName", this.speciesName);
			}
			if (!"All".equals(tissueType)) {
				map.put("tissueType", this.tissueType);
			}
			if (!"All".equals(cellType)) {
				map.put("cellType", this.cellType);
			}
			entryList = baseService.findResultList("cn.ac.big.hepi.entry.conditionalCellLine", map);
		} catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}


	public List<EntryBean> getEntryList() {
		return entryList;
	}

	public void setEntryList(List<EntryBean> entryList) {
		this.entryList = entryList;
	}

	public String getSpeciesName() {
		return speciesName;
	}

	public void setSpeciesName(String speciesName) {
		this.speciesName = speciesName;
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

	public void setCellType(String cellType) {
		this.cellType = cellType;
	}

	public String getCellLine() {
		return cellLine;
	}

	public void setCellLine(String cellLine) {
		this.cellLine = cellLine;
	}


}
