package cn.ac.big.hepi.action;


import cn.ac.big.hepi.service.IBaseService;
import com.opensymphony.xwork2.ActionSupport;

import javax.annotation.Resource;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;


import cn.ac.big.hepi.po.EntryInfoBean;
import cn.ac.big.hepi.po.SearchFormBean;
import cn.ac.big.hepi.po.TssBean;

import cn.ac.big.hepi.util.Page;
/***********************************************
 * this used to get all entry with detailed information using searchform
 * @zyy
 */
/*
public class EntryInfoAction extends ActionSupport{


	private static final long serialVersionUID = -2872302807193011121L;

	private List<EntryInfoBean> entryInfoList;

	private String speciesName;
	private String tissueType;
	private String cellType;
	private String cellLine;

	@Resource(name="baseService")
	private IBaseService baseService;


	public String execEntrySearchFunc(){
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
		if(! "All".equals(cellType)){
			map.put("cellType",this.cellType);
		}
		entryInfoList = baseService.findResultList("cn.ac.big.hepi.entry.entrySearch", map);
		return SUCCESS;
	}
	

	public List<EntryInfoBean> getEntryInfoList() {
		return entryInfoList;
	}

	public void setEntryInfoList(List<EntryInfoBean> entryInfoList) {
		this.entryInfoList = entryInfoList;
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
*/
//3.14159261111
public class EntryResultAction extends ActionSupport {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private static final File classDir = new File(EntryResultAction.class.getProtectionDomain().getCodeSource().getLocation().getPath());
	private static final File tempDir =new File(classDir,"./../../data/temp");
	private static final File currDir = new File(".");

	@Resource(name = "baseService")
	private IBaseService baseService;


	private SearchFormBean searchForm;
	private List<EntryInfoBean> entryResultList;


	//page list
	private int pageSize;
	private int rowCount;
	private int isFirstSearchFlag;
	private String entrezIdList;

	private Page page;
	private int pageNo;

	/*****************************************
	 * THIS USED TO DO SEARCH operation from custom_search.jsp
	 * @return
	 */
	public String execEntryResultFunc(){
		try{
			HttpServletRequest request = ServletActionContext.getRequest();
			HttpSession session = request.getSession();
			Map map = new HashMap();
		/*
		System.out.println("Out of the searchForm Bean:");
		System.out.println(searchForm.speciesName);
		System.out.println(searchForm.tissueType);
		System.out.println(searchForm.cellType);
		System.out.println(searchForm.cellLine);

		 */

			System.out.println("temp Dir:" + tempDir.getAbsolutePath());
			System.out.println("curr Dir:" + currDir.getAbsolutePath());

			if ( searchForm.getTissueType()==null){
				searchForm.setTissueType("All");
			}
			if (searchForm.getCellType()==null){
				searchForm.setCellType("All");
			}
			if(searchForm.getCellLine()==null){
				searchForm.setCellLine("All");
			}
			System.out.println("In the searchForm Bean:");
			System.out.println(searchForm);
			System.out.println("Species:" + searchForm.getSpeciesName());
			System.out.println("Tissue:" + searchForm.getTissueType());
			System.out.println("Cell Type:" + searchForm.getCellType());
			System.out.println("Cell Line:" + searchForm.getCellLine());
			System.out.println("Chrom:" + searchForm.getChrom());
			System.out.println("Start:" + searchForm.getStart());
			System.out.println("End:" + searchForm.getEnd());
			System.out.println("displayPair:" + searchForm.getDisplayPair() + " (" + Integer.toBinaryString(searchForm.getDisplayPair()) + ")");
			System.out.println("useDataset:" + searchForm.getUseDataset() + " (" + Integer.toBinaryString(searchForm.getUseDataset()) + ")");
			System.out.println(""+ searchForm==null);
			if (searchForm != null) {
				if (! "All".equals(searchForm.getSpeciesName())) {
					map.put("speciesName", searchForm.getSpeciesName());
				}

				if (! "All".equals(searchForm.getTissueType())) {
					map.put("tissueType", searchForm.getTissueType());
				}

				if (! "All".equals(searchForm.getCellType())) {
					map.put("cellType", searchForm.getCellType());
				}

				if (! "All".equals(searchForm.getCellLine())) {
					map.put("cellLine", searchForm.getCellLine());
				}
			}


			String basePath = ServletActionContext.getServletContext().getContextPath();

			//String currTaskId = new Date().getTime() + "";
			//searchForm.setTaskId(currTaskId);
			String currTaskId = searchForm.getTaskId();

			if(isFirstSearchFlag==1) {
				System.out.println("Searchmode : " + searchForm.getSearchMode());
				if (searchForm.getSearchMode() == 3) {
					//entrezIdList="1,10,114483834";
					System.out.println(entrezIdList);

					String[] entrezIds = entrezIdList.split(",");
					System.out.println(entrezIds.toString());

					List<TssBean> tssList = new ArrayList<>();
					List<TssBean> currTssList;
					for (String entrezId : entrezIds) {
						Map entrezMap = new HashMap();
						entrezMap.put("entrezId", entrezId);
						currTssList = baseService.findResultList("cn.ac.big.hepi.entry.getTssByEntrezId", entrezMap);
						tssList.addAll(currTssList);
					}
					System.out.println(tssList.toString());

					TssBean firstInfo = new TssBean();
					System.out.println(tssList.get(0));
					firstInfo = tssList.get(0);
					searchForm.setAnchor(String.format("%s:%d", firstInfo.getChrom(), (firstInfo.getTssStart() + firstInfo.getTssEnd()) / 2));

					StringBuilder tssInfoList = new StringBuilder();
					for (TssBean tssInfo : tssList) {
						System.out.println(tssInfo.toString());
						tssInfoList.append(String.format("%s\t%d\t%d\t%s\t.\t.\tTSS\n", tssInfo.getChrom(), tssInfo.getTssStart(), tssInfo.getTssEnd(), tssInfo.getEntrezId()));
					}
					tssInfoList.deleteCharAt(tssInfoList.length()-1);
					//tssInfoList.delete(tssInfoList.length()-2,tssInfoList.length());
					File taskDir = new File(tempDir, currTaskId);
					taskDir.mkdirs();
					File enhancerFilePath = new File(taskDir, "query.bed");
					PrintWriter output = new PrintWriter(enhancerFilePath);
					output.println(tssInfoList);
					output.close();


				} else {
					searchForm.setAnchor(String.format("%s:%d", searchForm.getChrom(), (Integer.parseInt(searchForm.getStart()) + Integer.parseInt(searchForm.getEnd())) / 2));
					searchForm.setChrom("chr" + searchForm.getChrom());

					File taskDir = new File(tempDir, currTaskId);
					taskDir.mkdirs();
					File enhancerFilePath = new File(taskDir, "enhancer.bed");
					String enhancerInfo = String.format("%s\t%s\t%s\t%s\t.\t.\tQuery", searchForm.getChrom(), searchForm.getStart(), searchForm.getEnd(), "Query_region");
					PrintWriter output = new PrintWriter(enhancerFilePath);
					//output.println(enhancerInfo);
					output.print(enhancerInfo);
					output.close();
				}

				entryResultList = baseService.findResultList("cn.ac.big.hepi.entry.getEntryResult", map);
				/*List<InterlocusBean> sesslocusList = locusList;*/
				if (session.getAttribute("entryResultList") != null) {
					session.removeAttribute("entryResultList");
				}

				session.setAttribute("entryResultList", entryResultList);  // this used to store the result in the session and the result will be store in files

				rowCount = entryResultList.size();
				System.out.println("===list" + rowCount);
				page = new Page(rowCount);
				if (rowCount > Page.DEFAULT_PAGE_SIZE) {
					entryResultList = entryResultList.subList(0, Page.DEFAULT_PAGE_SIZE);
				}
			}else{
				page = new Page(this.rowCount,this.pageNo,this.pageSize);
				entryResultList = baseService.findResultList("cn.ac.big.hepi.entry.getEntryResult", map, page.getRowFrom() - 1, page.getPageSize());
			}


			request.setAttribute("myPage", page);
			//	request.setAttribute("searchcon", searchForm);
			System.out.println("map size=" + map.size());
			String params = "";

			//if(map.get("spId")!=null){
			params += "&searchForm.speciesName=" + searchForm.getSpeciesName();
			//}
			//if(map.get("clId") !=null){
			params += "&searchForm.tissueType=" + searchForm.getTissueType();
			//}
			//if(map.get("enzymeId")!=null){
			params += "&searchForm.cellType=" + searchForm.getCellType();
			//}

			params += "&searchForm.cellLine=" + searchForm.getCellLine();

			params += "&searchForm.taskId=" + searchForm.getTaskId();

			params += "&searchForm.searchMode=" + searchForm.getSearchMode();

			params += "&searchForm.onlyVehicle=" + searchForm.getOnlyVehicle();

			params += "&searchForm.anchor=" + searchForm.getAnchor();

			params += "&searchForm.displayPair=" + searchForm.getDisplayPair();

			params += "&searchForm.useDataset=" + searchForm.getUseDataset();


			request.setAttribute("myUrl", basePath + "/search/entrySearch.action?my=1" + params);



		/*
		//search parameters
		if(searchForm !=null){
			SpeciesBean spbean = (SpeciesBean)baseService.findObjectById("cn.ac.big.tcdb.species.selectOneSpecies", searchForm.getSpId());
			if(spbean!=null){
				searchForm.setSpeciesName(spbean.getLatinName());
			}
			if(searchForm.getSpId() ==0){
				searchForm.setSpeciesName("All");
			}

			EnzymeBean enzybean = (EnzymeBean)baseService.findObjectById("cn.ac.big.tcdb.enzyme.selectOneEnzyme", searchForm.getEnzymeId());
			if(enzybean!=null){
				searchForm.setEnzymeName(enzybean.getEnzymeName());
			}
			if(searchForm.getEnzymeId() ==0){
				searchForm.setEnzymeName("All");
			}


			CelllineBean cellbean = (CelllineBean)baseService.findObjectById("cn.ac.big.tcdb.cellline.selectOneCellLine", searchForm.getClId());
			if(cellbean !=null){
				searchForm.setCellName(cellbean.getCellName()) ;
			}


			if(searchForm.getLevelId()!=null &&searchForm.getLevelId().equals("All")==false){
				LevelBean levelBean = (LevelBean)baseService.findObjectByObject("cn.ac.big.tcdb.level.selectOneLevel", searchForm.getLevelId());
				if(levelBean!=null){
					searchForm.setLevelName(levelBean.getLevelName());
				}
			}else{
				searchForm.setLevelName("All");
			}


			if(searchForm.getClId() ==0){
				searchForm.setCellName("All");
			}
		}
		*/

		}catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}

	public SearchFormBean getSearchForm() {
		return searchForm;
	}

	public void setSearchForm(SearchFormBean searchForm) {
		this.searchForm = searchForm;
	}

	public List<EntryInfoBean> getEntryResultList() {
		return entryResultList;
	}

	public void setEntryResultList(List<EntryInfoBean> getEntryResultList) {
		this.entryResultList = entryResultList;
	}

	public int getPageSize() {
		return pageSize;
	}


	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}


	public int getRowCount() {
		return rowCount;
	}


	public void setRowCount(int rowCount) {
		this.rowCount = rowCount;
	}


	public int getIsFirstSearchFlag() {
		return isFirstSearchFlag;
	}


	public void setIsFirstSearchFlag(int isFirstSearchFlag) {
		this.isFirstSearchFlag = isFirstSearchFlag;
	}


	public Page getPage() {
		return page;
	}


	public void setPage(Page page) {
		this.page = page;
	}


	public int getPageNo() {
		return pageNo;
	}


	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public String getEntrezIdList() {
		return entrezIdList;
	}

	public void setEntrezIdList(String entrezIdList) {
		this.entrezIdList = entrezIdList;
	}
}