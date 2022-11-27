/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package cn.ac.big.hepi.service.impl;

import java.util.List;

import cn.ac.big.hepi.dao.BaseDao;
import cn.ac.big.hepi.service.IBaseService;

/**
 * 
 * @author tangbx
 */
public class BaseServiceImpl implements IBaseService {
    private BaseDao baseDao;

    public BaseServiceImpl(){

    }

    public void setBaseDao(BaseDao baseDao) {
        this.baseDao = baseDao;
    }

    public  Object findObjectById(String mappername,int id){
        return baseDao.findObjectById(mappername, id);
    }
    public  Object findObjectByName(String name){
        return baseDao.findObjectByName(name);
    }
    
    public  List findResultListByWhereLike(String mappername,String param){
        return baseDao.findResultListByWhereLike(mappername, param);
    }

     public List findResultList(String mappername,Object param){
        return baseDao.findResultList(mappername, param);
    }
     public List findResultList(String mappername,Object param,int offset,int limit){
    	 return baseDao.findResultList(mappername, param,offset,limit);
     }

     public int getRecordCount(String mappername,Object param){
        return baseDao.getRecordCount(mappername, param);
     }
     
     public int insertObjectToTable(String mappername,Object param){
    	 return baseDao.insertObjectToTable(mappername, param);
     }
     public int updateObjectToTable(String mappername,Object param)
     {
    	 return baseDao.updateObjectToTable(mappername, param);
     }
     public int deleteObjectFromTable(String mappername,Object param){
    	 return baseDao.deleteObjectFromTable(mappername, param);
     }
     
     public  Object findObjectByObject(String mappername,Object param){
    	 return baseDao.findObjectByObject(mappername, param);
    	 
     }

     
  
}
