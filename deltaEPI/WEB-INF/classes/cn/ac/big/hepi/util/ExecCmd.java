package cn.ac.big.hepi.util;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;


public class ExecCmd {

    private String[] myCmd;

    public ExecCmd(String[] myCmd){
        this.myCmd=myCmd;
    }


    public void runCmd() {
        //String[] cmdStr = myCmd;
        Runtime run = Runtime.getRuntime();
        System.out.println(String.format("\n\nIn ExecCmd : Running command %s\n",myToString(myCmd)));
        try {
            Process process = run.exec(myCmd);
            InputStream in1 = process.getInputStream();
            InputStreamReader reader1 = new InputStreamReader(in1);
            BufferedReader br1 = new BufferedReader(reader1);
            InputStream in2 = process.getErrorStream();
            InputStreamReader reader2 = new InputStreamReader(in2);
            BufferedReader br2 = new BufferedReader(reader2);
            StringBuffer sb = new StringBuffer();
            String message;
            while((message = br1.readLine()) != null) {
                message+="\n";
                sb.append(message);
                System.out.println("Get output line: " + message);
            }
            while((message = br2.readLine()) != null) {
                message+="\n";
                sb.append(message);
                System.out.println("Get error line: " + message);
            }
            int exitCode = process.waitFor();
            System.out.println(String.format("Command exits with status %d\n",exitCode));
            System.out.println(sb);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (InterruptedException i) {
            System.out.println("Command is interrupted due to unknown reason, please check the log file.");
        }
    }

    private String myToString(String[] a){
        String result = "";
        for (String s : a){
            result += s + "\",\"";
        }
        return result;
    }
}