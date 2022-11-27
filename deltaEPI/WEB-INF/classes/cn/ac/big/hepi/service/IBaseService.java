/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package cn.ac.big.hepi.service;

import java.util.List;
/**
 *
 * @author tangbx
 */
public interface IBaseService {
    public abstract Object findObjectById(String mappername,int id);
    public abstract Object findObjectByName(String name);
    public abstract Object findObjectByObject(String mappername,Object param);
    public abstract List findResultListByWhereLike(String mappername,String param);
    public abstract List findResultList(String mappername,Object param);
    //added by wang,fenye
    public abstract List findResultList(String mappername,Object param,int offset,int limit);
    public abstract int getRecordCount(String mappername,Object param);
    
    //add by tangbx 20120306
    public abstract int insertObjectToTable(String mappername,Object param);
    public abstract int updateObjectToTable(String mappername,Object param);
    public abstract int deleteObjectFromTable(String mappername,Object param);

}
