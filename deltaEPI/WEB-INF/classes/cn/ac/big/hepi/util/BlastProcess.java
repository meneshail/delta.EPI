package cn.ac.big.hepi.util;

import java.io.*;


import cn.ac.big.hepi.action.EntryResultAction;
import cn.ac.big.hepi.po.BlastResultBean;


public class BlastProcess implements Serializable
{

    private static final long serialVersionUID = 1L;
    private static final File classDir = new File(EntryResultAction.class.getProtectionDomain().getCodeSource().getLocation().getPath());
    private static final File dataDir =new File(classDir,"./../../data");
    private static final File blastResultDir = new File(dataDir,"blast");
    private static final File blastScriptPath = new File(dataDir,"utils/blast.sh");
    //Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts
    ///'Program Files'/'Apache Software Foundation'/'Tomcat 8.5'/webapps

    //private static final String blastResultShellDir = "/mnt/c/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/hepi/data/blast";
    //private static final String blastShellPath = "/mnt/c/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/hepi/data/utils/blast.sh";
    private static final String blastResultShellDir = winToLinux(blastResultDir.getAbsolutePath());
    private static final String blastShellPath = winToLinux(blastScriptPath.getAbsolutePath());


    private String taskId;
    private String chrom;
    private String sequence;

    private BlastResultBean blastResult = new BlastResultBean();



    private File taskDir;
    private String taskShellDir;



    public BlastProcess(String chrom, String sequence, String taskId){
        this.chrom = chrom;
        this.sequence = sequence;
        this.taskId = taskId;



        this.taskDir = new File(blastResultDir,taskId);
        this.taskShellDir = String.format("%s/%s",blastResultShellDir,taskId);

    }



    public void createFA() throws IOException {
        taskDir.mkdirs();
        File sequenceFilePath = new File(taskDir,"target.fa");
        //System.out.println(sequenceFilePath);
        String sequenceInfo = String.format(">Tag\n%s\n", this.sequence);
        PrintWriter output = new PrintWriter(sequenceFilePath);
        output.println(sequenceInfo);
        output.close();
        //System.out.println(sequenceFilePath.isFile());
    }

    public int runProcess() throws IOException{

        createFA();
        String[] blastCmdString;
        if(isWindows()){
            blastCmdString = new String[]{"wsl", "-e", "bash", "-i", String.format("%s", blastShellPath), "-i", String.format("%s", taskShellDir), "-c", String.format("%s", chrom)};
        }else{
            blastCmdString = new String[]{String.format("%s", blastScriptPath), "-i", String.format("%s", taskDir), "-c", String.format("%s", chrom)};
        }
        //String.format("wsl -e bash -i %s -i %s -c %s",blastShellPath,taskShellDir,chrom);
        System.out.println("Executing cmd: "+ myToString(blastCmdString));
        ExecCmd blastCmd = new ExecCmd(blastCmdString);
        blastCmd.runCmd();

        File resultPath = new File(taskDir,"result.txt");

        BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(resultPath), "utf-8"));
        String line = null;
        line=reader.readLine();
        System.out.println(line);
        if(line==null){
            blastResult.setExitStatus(1);
            return 1;
        }
        else{
            String item[] = line.split("\t");
            System.out.println("result:"+item[1]+item[8]+item[9]);
            blastResult.setChromosome(item[1]);
            blastResult.setStart(Integer.parseInt(item[8]));
            blastResult.setEnd(Integer.parseInt(item[9]));
            blastResult.setExitStatus(0);
            blastResult.setIdentity(Float.parseFloat(item[2]));
            blastResult.setqValue(Float.parseFloat(item[10]));
            blastResult.setScore(Float.parseFloat(item[11]));
        }
        return 0;

    }

    private static String winToLinux(String path){
        String path1 =  path.replaceFirst("C:","/mnt/c").replace("\\","/");
        /*
        String folders[] = path1.split("/");
        String finalPath = "";
        for(String folder : folders){
            if(folder.length()>0){
                finalPath += "/" + "'" + folder +"'";
            }
        }

         */
        return path1;
    }

    private String myToString(String[] a){
        String result = "";
        for (String s : a){
            result += s+" ";
        }
        return result;
    }

    private boolean isWindows(){
        String OS = System.getProperty("os.name").toLowerCase();
        return OS.indexOf("windows")>=0;
    }

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String tastId){
        this.taskId=taskId;
    }

    public String getSequence() {
        return sequence;
    }

    public void setSequence(String sequence) {
        this.sequence = sequence;
    }

    public String getChrom() {
        return chrom;
    }

    public void setChrom(String chrom){
        this.chrom=chrom;
    }

    public BlastResultBean getBlastResult() {
        return blastResult;
    }
}
