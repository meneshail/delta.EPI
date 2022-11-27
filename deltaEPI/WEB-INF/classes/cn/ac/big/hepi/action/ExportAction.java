package cn.ac.big.hepi.action;


import cn.ac.big.hepi.po.EntryInfoBean;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class ExportAction extends ActionSupport implements ServletResponseAware, ServletRequestAware  {
    private static final long serialVersionUID = 1L;
    private int filetype;
    private int flag;
    private HttpServletResponse response;
    private HttpServletRequest request;
    private String[] checkbox;
    private int item;


    private int pagesize;



    public void exportToFile()
    {
        //StringBuilder sb = new StringBuilder();
        List<EntryInfoBean> entryResultList = null ;

        HttpSession session = ServletActionContext.getRequest().getSession();
        if(session.getAttribute("entryResultList")!=null){
            entryResultList =(List) session.getAttribute("entryResultList");
        }
        /*
        if(entryResultList !=null){
              sb.append("Research Series");
              sb.append("\t");
              sb.append("Locus1");
              sb.append("\t");
              sb.append("Fragment location");
              sb.append("\t");
              sb.append("Primer sequence");
              sb.append("\t");
              sb.append("Strand");
              sb.append("\t");
              sb.append("Locus2");
              sb.append("\t");
              sb.append("Fragment location");
              sb.append("\t");
              sb.append("Primer sequence");
              sb.append("\t");
              sb.append("Strand");
              sb.append("\r\n");

              if(this.item !=3){
                  for (int x = 0; x < this.checkbox.length; x++) {
                     int val_id=0;
                     int index = Integer.parseInt(this.checkbox[x]) ;
                     val_id = index-1;
                     InterlocusBean locbean = locusList.get(val_id) ;
                     String cur_str = processInterBean(locbean);
                     sb.append(cur_str);

                   }
              }else{
                  for(InterlocusBean locbean: locusList){
                      String cur_str = processInterBean(locbean);
                      sb.append(cur_str);
                  }
              }


            if (this.filetype == 2) {
                  this.response.reset();
                  this.response.setHeader("Content-Disposition",
                    "attachment;filename=test.txt");
                  this.response.setContentType("application/ms-txt");
                  try {
                    PrintWriter pr = this.response.getWriter();
                    pr.print(sb.toString());
                    pr.close();
                  } catch (IOException e) {
                    e.printStackTrace();
                  }
            }
            else {
                  this.response.reset();
                  try {
                    PrintWriter pr = this.response.getWriter();
                    pr.print(sb.toString());
                    pr.close();
                  } catch (IOException e) {
                    e.printStackTrace();
                  }
            }


        }
        */
    }

    /*
    private String processInterBean(InterlocusBean locbean){
        StringBuilder sb = new StringBuilder();
        sb.append(locbean.getName());
        sb.append("\t");
        sb.append(locbean.getLoconeName());
        sb.append("\t");
        String loc1frame = "";

        if(locbean.getLoconeStart()>0 && locbean.getLoconeEnd() >0){
        loc1frame = "chr"+locbean.getLoconeChrom()+":"+locbean.getLoconeStart()+"-"+locbean.getLoconeEnd() ;
        }else{
        loc1frame = "NA";
        }
        sb.append(loc1frame);


        sb.append("\t");
        if(locbean.getLoconePriseq().length()>0){
          sb.append(locbean.getLoconePriseq());
        }else{
          sb.append("NA") ;
        }

        sb.append("\t");
        if(locbean.getLoconeStrand().length()>0){
        sb.append(locbean.getLoconeStrand());
        }else{
        sb.append("NA");
        }
        sb.append("\t");

        sb.append(locbean.getLoctwoName());

        sb.append("\t");
        loc1frame = "";

        if(locbean.getLoctwoStart()>0 && locbean.getLoctwoEnd() >0){
        loc1frame = "chr"+locbean.getLoctwoChrom()+":"+locbean.getLoctwoStart()+"-"+locbean.getLoctwoEnd() ;
        }else{
        loc1frame = "NA";
        }
        sb.append(loc1frame);
        sb.append("\t");
        if(locbean.getLoctwoPriseq().length()>0){
        sb.append(locbean.getLoctwoPriseq());
        }else{
        sb.append("NA") ;
        }

        sb.append("\t");
        if(locbean.getLoctwoStrand().length()>0){
        sb.append(locbean.getLoctwoStrand());
        }else{
        sb.append("NA");
        }

        sb.append("\r\n");
        return sb.toString();

        }
     */

    public String[] getCheckbox() {
        return this.checkbox;
    }

    public void setCheckbox(String[] checkbox) {
        this.checkbox = checkbox;
    }

    public int getFlag() {
        return this.flag;
    }

    public void setFlag(int flag) {
        this.flag = flag;
    }

    public void setServletRequest(HttpServletRequest request) {
        this.request = request;
    }

    public int getFiletype() {
        return this.filetype;
    }

    public void setFiletype(int filetype) {
        this.filetype = filetype;
    }

    public void setServletResponse(HttpServletResponse response) {
        this.response = response;
    }

    public int getPagesize() {
        return pagesize;
    }

    public void setPagesize(int pagesize) {
        this.pagesize = pagesize;
    }

    public int getItem() {
        return item;
    }

    public void setItem(int item) {
        this.item = item;
    }



}