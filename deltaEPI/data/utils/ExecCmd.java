package utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;


public class ExecCmd {
    
    private String myCmd;
    
    public ExecCmd(String myCmd){
        this.myCmd=myCmd;
    }
    
    
    public void runCmd() {
        String cmdStr = myCmd;
        Runtime run = Runtime.getRuntime();
        try {
            Process process = run.exec(cmdStr);
            InputStream in = process.getInputStream();
            InputStreamReader reader = new InputStreamReader(in);
            BufferedReader br = new BufferedReader(reader);
            StringBuffer sb = new StringBuffer();
            String message;
            while((message = br.readLine()) != null) {
                message+='\n';
                sb.append(message);
            }
            System.out.println(sb);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}

