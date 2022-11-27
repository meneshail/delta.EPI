package cn.ac.big.hepi.dao.impl;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import cn.ac.big.hepi.dao.BaseDao;

public class BaseDaoImpl extends SqlSessionDaoSupport implements BaseDao{

	
	private SqlSessionFactory sessionFactory;
	
	
	public void setSessionFactory(SqlSessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	
	public  Object findObjectById(String mappername,int id){
	       // SqlSession session = sessionFactory.openSession();
	        Object obj=getSqlSessionTemplate().selectOne(mappername, id);
	      //  session.close();
	        return obj;
	    }

	    /**********************
	     * @param name
	     * @return
	     */
	    public  Object findObjectByName(String name){

	        return null;
	    }

	    /*********************
	     * @param param
	     * @return
	     */
	    public List findResultListByWhereLike(String mappername,String param){
	      //  SqlSession session = sessionFactory.openSession();
	        List list= getSqlSessionTemplate().selectList(mappername,param);
	      //  session.close();
	        return list;
	    }

	    /******************
	     * @param param
	     * @return
	     */
	    public List findResultList(String mappername,Object param){
	       // SqlSession session = sessionFactory.openSession();
	        List list= getSqlSessionTemplate().selectList(mappername,param);
	      //  session.close();
	        return list;
	    }
	    
	    public List findResultList(String mappername,Object param,int offset,int limit){
	    //	SqlSession session = sessionFactory.openSession();
	    	List list = getSqlSessionTemplate().selectList(mappername,param,new RowBounds(offset,limit));
	    //	session.close();
	    	return list;
	    }

	    public int getRecordCount(String mappername,Object param){
	       // SqlSession session = sessionFactory.openSession();
	        int count=Integer.parseInt(getSqlSessionTemplate().selectOne(mappername,param).toString());
	      //  session.close();
	        return count;
	    }
	    
	    //add by tangbx 20120306
	    public int insertObjectToTable(String mappername,Object param){
	    	// SqlSession session = sessionFactory.openSession();
	    //	 session.commit(false);
	    	 int res= getSqlSessionTemplate().insert(mappername, param);
	     //    session.close();
	         return res;
	    }
	    
	    public int updateObjectToTable(String mappername,Object param)
	    {
	    	// SqlSession session = sessionFactory.openSession();
	    	 int res= getSqlSessionTemplate().update(mappername, param);
	      //   session.close();
	         return res;
	    }
	    
	    public int deleteObjectFromTable(String mappername,Object param){
	    	//SqlSession session = sessionFactory.openSession();
	   	 	int res= getSqlSessionTemplate().delete(mappername, param);
	     //   session.close();
	        return res;
	    }
	    
	    public  Object findObjectByObject(String mappername,Object param){
	    	 Object obj=getSqlSessionTemplate().selectOne(mappername, param);
	    	 return obj;
	    }

}
