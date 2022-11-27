package cn.ac.big.hepi.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.StrutsStatics;
import org.apache.struts2.dispatcher.HttpParameters;
import org.apache.struts2.dispatcher.Parameter;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.web.util.HtmlUtils;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import com.opensymphony.xwork2.util.ValueStack;

public class XssInterceptor extends AbstractInterceptor {
	private static final String[] HOST_LIST = {"127.0.0.1","192.168.164.17","192.168.117.41","0.0.0.0","bigd.big.ac.cn","ngdc.cncb.ac.cn","localhost"};

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public String intercept(ActionInvocation invocation) throws Exception {
		// TODO Auto-generated method stub
		String CHECKSQL =  "(?:')|(?:--)|(/\\*(?:.|[\\n\\r])*?\\*/)|(\\b(select|update|and|or|delete|insert|trancate|char|into|substr|ascii|declare|exec|count|master|into|drop|execute)\\b)";


		ActionContext actionContext = invocation.getInvocationContext();
		HttpServletRequest request= (HttpServletRequest) actionContext.get(StrutsStatics.HTTP_REQUEST);
		HttpServletResponse response=(HttpServletResponse) actionContext.get(StrutsStatics.HTTP_RESPONSE);

		String requestStr = getRequestString(request);

		if ("haha".equals(guolv2(requestStr))
				|| "haha".equals(guolv2(request.getRequestURL().toString()))) {

			return "error";
		}

		String host = request.getHeader("host");
		if(checkBlankList(host) == false){
			response.setStatus(HttpStatus.FORBIDDEN.value());
			return "error";
		}



		String referer=request.getHeader("Referer");
		System.out.println("============referer==="+referer);



		if(referer!=null){
			Map<String, Parameter> map = actionContext.getParameters();
			ValueStack stack = actionContext.getValueStack();
			for (Map.Entry<String, Parameter> entry : map.entrySet()) {
				//  String value = ((String[])(entry.getValue()))[0];
				//  entry.setValue(StringEscapeUtils.escapeHtml4(value));
				Parameter value = entry.getValue();
				String value_str = value.getValue();

				if (null != value_str && value_str.matches(CHECKSQL)) { // SQL inject
					System.out.println("===SQL invalid charater====");
					return "error";
				}


				String escape=  StringEscapeUtils.escapeHtml4(value_str);
				escape = HtmlUtils.htmlEscape(escape);
				escape=  xssEncode(escape);
				escape = guolv(escape);
				stack.setValue(entry.getKey(),escape);
			}



			if (HttpMethod.OPTIONS.toString().equals(request.getMethod())) {
				response.setStatus(HttpStatus.NO_CONTENT.value());
			}

			//response start OPTIONS
			response.setHeader("Access-Control-Allow-Origin", "*");
			response.setHeader("Access-Control-Allow-Credentials", "true");
			response.setHeader("Access-Control-Allow-Methods", "GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS");
			response.setHeader("Access-Control-Max-Age", "86400");
			response.setHeader("Access-Control-Allow-Headers", "*");
			response.setHeader("Strict-Transport-Security", "max-age=63072000;includeSubDomains") ;
			response.setHeader("X-Download-Options", "noopen");
			response.setHeader("X-Permitted-Cross-Domain-Policies", "master-only") ;

			response.addHeader("X-frame-options","SAMEORIGIN");
			response.addHeader("X-Content-Type-Options","nosniff");

			response.addHeader("Content-Security-Policy","worker-src * blob: ;default-src * data: 'self' 'unsafe-inline' ;script-src 'self' 'unsafe-inline' 'unsafe-eval' bigd.big.ac.cn ngdc.cncb.ac.cn;style-src 'self' 'unsafe-inline' bigd.big.ac.cn ngdc.cncb.ac.cn;script-src-elem 'self' 'unsafe-inline' bigd.big.ac.cn browse2.big.ac.cn ngdc.cncb.ac.cn;frame-src 'self';font-src 'self' bigd.big.ac.cn ngdc.cncb.ac.cn;img-src 'self' bigd.big.ac.cn ngdc.cncb.ac.cn");

			response.addHeader("X-XSS-Protection","1;mode=block");
			response.addHeader("Referrer-Policy","origin");

			return invocation.invoke();
		}else {
			return "error";
		}


	}

	private static String xssEncode(String value) {

		value = value.replaceAll("<", "<").replaceAll(">", ">");
		value = value.replaceAll("\\(", "(").replaceAll("\\)", ")");
		value = value.replaceAll("'", "'");
		value = value.replaceAll("eval\\((.*)\\)", "");
		value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
		value = value.replaceAll("script", "").trim();

		return value;

	}

	private  String guolv(String a) {
		a = a.replaceAll("%22", "");
		a = a.replaceAll("%27", "");
		a = a.replaceAll("%3E", "");
		a = a.replaceAll("%3e", "");
		a = a.replaceAll("%3C", "");
		a = a.replaceAll("%3c", "");
		a = a.replaceAll("<", "");
		a = a.replaceAll(">", "");
		a = a.replaceAll("\"", "");
		a = a.replaceAll("'", "");
		a = a.replaceAll("\\+", "");
		a = a.replaceAll("\\(", "");
		a = a.replaceAll("\\)", "");
		a = a.replaceAll(" and ", "");
		a = a.replaceAll(" or ", "");
		a = a.replaceAll(" 1=1 ", "");
		return a;
	}

	private boolean checkBlankList(String host){
		boolean isAllow = false;
		if(host == null){
			isAllow = true;

		}

		if(host != null && host.indexOf(":")> -1){
			int idex = host.indexOf(":");
			host = host.substring(0, idex);
		}
		for (String blankHost : HOST_LIST){
			if(blankHost != null && host != null && blankHost.contains(host)){
				isAllow = true;
			}
		}
		return isAllow;
	}

	private String guolv2(String a) {
		if (StringUtils.isNotEmpty(a)) {
			if (a.contains("%22") || a.contains("%3E") || a.contains("%3e")
					|| a.contains("%3C") || a.contains("%3c")
					|| a.contains("<") || a.contains(">") || a.contains("\"")
					|| a.contains("'") || a.contains("+") ||
					/*
					* a.contains("%27")
					* * ||
					* */
					a.contains(" and ") || a.contains(" or ")
					|| a.contains("1=1") || a.contains("(") || a.contains(")")) {
				return "haha";
			}
		}
		return a;
	}

	private String getRequestString(HttpServletRequest req) {
		String requestPath = req.getServletPath().toString();
		String queryString = req.getQueryString();
		if (queryString != null)
			return requestPath + "?" + queryString;
		else
			return requestPath;
	}


}