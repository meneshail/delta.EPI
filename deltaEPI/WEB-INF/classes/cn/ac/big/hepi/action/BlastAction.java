package cn.ac.big.hepi.action;


import cn.ac.big.hepi.po.BlastResultBean;
import cn.ac.big.hepi.service.IBaseService;
import cn.ac.big.hepi.util.BlastProcess;
import com.opensymphony.xwork2.ActionSupport;

import javax.annotation.Resource;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/***********************************************
 * this used to get all entry with detailed information using searchform
 * @zyy
 */
/*
 */

public class BlastAction extends ActionSupport {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Resource(name = "baseService")
	private IBaseService baseService;

	private BlastResultBean blastResult = new BlastResultBean() ;


	private String species;
	private String chrom;
	private String sequence;
	private String taskId;

	/*****************************************
	 * THIS USED TO DO SEARCH operation from custom_search.jsp
	 * @return
	 */
	public String execBlastFunc(){
		try {

			setChrom();
			taskId = new Date().getTime() + "";

			System.out.println("Sequence: " + sequence);
			System.out.println("species: " + species);
			System.out.println("chrom: " + chrom);
			System.out.println("taskId: " + taskId);

			BlastProcess curr = new BlastProcess(this.chrom, this.sequence, this.taskId);
			int exitStatus = curr.runProcess();


			if (exitStatus == 1) {
				System.out.println("Error occured when doing blast, please check the outout.");
			} else if (exitStatus == 0) {
				System.out.println("Successfully doing the analysis. Proceeding to outputfile reading..");
			}

			this.blastResult = curr.getBlastResult();

		}catch(Exception e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}



	private void setChrom(){
		if(this.species.equals("Homo_sapiens")){
			this.chrom = "hg38";
		}else if(this.species.equals("Mus_musculus")){
			this.chrom = "mm10";
		}else if(this.species.equals("Macaca_mulatta")){
			this.chrom = "rheMac10";
		}
	}


	public String getChrom() {
		return chrom;
	}

	public String getSpecies() {
		return species;
	}

	public void setSpecies(String species) {
		this.species = species;
	}

	public void setChrom(String chrom) {
		this.chrom = chrom;
	}

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public BlastResultBean getBlastResult() {
		return blastResult;
	}

	public void setBlastResult(BlastResultBean blastResult) {
		this.blastResult = blastResult;
	}

	public String getSequence() {
		return sequence;
	}

	public void setSequence(String sequence) {
		this.sequence = sequence;
	}
}