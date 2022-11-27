package cn.ac.big.hepi.listener;

import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;
import javax.servlet.annotation.WebListener;
import java.lang.ref.Reference;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

@WebListener
public class ThreadLocalCleanListener implements ServletRequestListener {
    private void cleanUpThreadLocals() throws Exception {
        Thread thread = Thread.currentThread();
        Field threadLocalsField = Thread.class.getDeclaredField("threadLocals");
        threadLocalsField.setAccessible(true);
        Object threadLocalsInThread = threadLocalsField.get(thread);
        Class threadLocalMapClass = Class
                .forName("java.lang.ThreadLocal$ThreadLocalMap");
        Method removeInThreadLocalMap = threadLocalMapClass.getDeclaredMethod(
                "remove", ThreadLocal.class);
        removeInThreadLocalMap.setAccessible(true);

        Field tableField = threadLocalMapClass.getDeclaredField("table");
        tableField.setAccessible(true);
        Object table = tableField.get(threadLocalsInThread);
        for (int i = 0; i < Array.getLength(table); i++) {
            Object entry = Array.get(table, i);
            Method getMethod = Reference.class.getDeclaredMethod("get");
            if (entry != null) {
                ThreadLocal threadLocal = (ThreadLocal) getMethod.invoke(entry);
                removeInThreadLocalMap.invoke(threadLocalsInThread, threadLocal);
            }
        }
    }
    @Override
    public void requestDestroyed(ServletRequestEvent paramServletRequestEvent) {
        try {
            cleanUpThreadLocals();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public void requestInitialized(ServletRequestEvent paramServletRequestEvent) {
    }
}

