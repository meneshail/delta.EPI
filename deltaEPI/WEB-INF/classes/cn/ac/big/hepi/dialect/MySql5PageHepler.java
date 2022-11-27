package cn.ac.big.hepi.dialect;

public class MySql5PageHepler {

	/**
	 * �õ���ҳ��SQL
	 * @param offset 	ƫ����
	 * @param limit		λ��
	 * @return	��ҳSQL
	 */
	public static String getLimitString(String querySelect,int offset, int limit) {
		querySelect		= getLineSql(querySelect);
		String sql = querySelect+" limit "+ offset +" ,"+ limit;
		return sql;
	}

	/**
	 * ��SQL�����һ����䣬����ÿ�����ʵļ�����ￄ1�7���ո�
	 * 
	 * @param sql SQL��ￄ1�7
	 * @return ���sql��NULL���ؿգ����򷵻�ת�����SQL
	 */
	private static String getLineSql(String sql) {
		return sql.replaceAll("[\r\n]", " ").replaceAll("\\s{2,}", " ");
	}


}
