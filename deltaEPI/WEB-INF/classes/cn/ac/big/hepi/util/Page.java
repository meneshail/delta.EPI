package cn.ac.big.hepi.util;

import java.io.Serializable;

public class Page implements Serializable 
{
	
	private static final long serialVersionUID = 1L;
	
	public static final int DEFAULT_PAGE_NO = 1;
    public static final int DEFAULT_PAGE_SIZE = 20;
    public static final int DEFAULT_LINK_PAGE_COUNT = 15;
    private int rowCount;
    private int pageNo;
    private int pageSize;

    private int linkPageCount;
    private int firstPageNo;
    private int lastPageNo;
    private int rowFrom;
    private int rowTo;
    private int isHasNextPage;
    private int isHasPreviousPage;

    public Page(){}
   
    public Page(int rowCount, int pageNo, int pageSize, int linkPageCount) 
    {
        this.rowCount = rowCount < 0?0:rowCount;
        this.pageSize = pageSize < 1?DEFAULT_PAGE_SIZE:pageSize;
        this.linkPageCount = linkPageCount < 1?DEFAULT_LINK_PAGE_COUNT:linkPageCount;

        firstPageNo = 1;
        lastPageNo = (this.rowCount - 1) / this.pageSize + 1;

        if (pageNo < firstPageNo) 
        {
            this.pageNo = firstPageNo;
        }
        else if (pageNo > lastPageNo) 
        {
            this.pageNo = lastPageNo;
        } 
        else 
        {
            this.pageNo = pageNo;
        }
        
        this.rowFrom = this.pageNo==1?(this.pageNo - 1) * this.pageSize:(this.pageNo - 1) * this.pageSize + 1 ;
        this.rowTo = this.pageNo * this.pageSize > rowCount ? rowCount :
                     this.pageNo * this.pageSize;
    }
    public Page(int rowCount, int pageNo, int pageSize) 
    {
    	this.rowCount = rowCount < 0?0:rowCount;
        this.pageSize = pageSize < 1?DEFAULT_PAGE_SIZE:pageSize;

        firstPageNo = 1;
        lastPageNo = (this.rowCount - 1) / this.pageSize + 1;
        
        
        if (pageNo < firstPageNo) 
        {
            this.pageNo = firstPageNo;
        }
        else if (pageNo > lastPageNo) 
        {
            this.pageNo = lastPageNo;
        } 
        else 
        {
            this.pageNo = pageNo;
        }
        
        this.rowFrom = (this.pageNo - 1) * this.pageSize + 1 ;
        this.rowTo = this.pageNo * this.pageSize > rowCount ? rowCount :this.pageNo * this.pageSize;
        System.out.println("pageNo:"+this.pageNo);
        System.out.println("rowCount:"+this.rowCount);
        System.out.println("rowFrom:"+this.rowFrom);
        System.out.println("rowTo:"+this.rowTo);
    }

    public Page(int rowCount) {
        this(rowCount, DEFAULT_PAGE_NO, DEFAULT_PAGE_SIZE);
    }

    public int getRowCount() {
        return rowCount;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getPageNo() {
        return pageNo;
    }

    public int getFirstPageNo() {
        return firstPageNo;
    }

    public int getLastPageNo() {
        return lastPageNo;
    }

    public int getRowFrom() {
        return rowFrom;
    }

    public int getRowTo() {
        return rowTo;
    }

    public int getPreviousPageNo() 
    {
        if (getIsHasPreviousPage()==0) 
        {
            return firstPageNo;
        }
        return pageNo - 1;
    }

    public int getNextPageNo() 
    {
        if (getIsHasNextPage()==0) 
        {
            return lastPageNo;
        }
        return pageNo + 1;
    }

    public int getIsHasNextPage() 
    {
    	this.isHasNextPage = pageNo < lastPageNo?1:0;
        return this.isHasNextPage;
    }

    public int getIsHasPreviousPage() 
    {
    	isHasPreviousPage = pageNo > firstPageNo?1:0;
        return isHasPreviousPage;
    }
}
