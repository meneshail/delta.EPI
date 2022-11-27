package cn.ac.big.hepi.util;

import cn.ac.big.hepi.action.EntryResultAction;

import java.io.File;
import java.io.Serializable;
import java.util.Map;


public class EntryProcess implements Serializable
{

    private static final long serialVersionUID = 1L;
    private static final File classDir = new File(EntryResultAction.class.getProtectionDomain().getCodeSource().getLocation().getPath());
    private static final File dataDir =new File(classDir,"./../../data");
    private static final File scriptDir = new File(dataDir,"utils");
    private static final File intersectPath = new File(scriptDir,"intersect.sh");
    private static final File getResultListPath = new File(scriptDir,"get_result_list.R");
    private static final File enrichmentAnalysisPath = new File(scriptDir,"enrichment_analysis.R");

    //private static final String dataShellDir = "/mnt/c/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/hepi/data";
    //private static final String intersectShellPath = "/mnt/c/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/hepi/data/utils/intersect.sh";

    private static final String dataShellDir = winToLinux(dataDir.getAbsolutePath());
    private static final String intersectShellPath = winToLinux(intersectPath.getAbsolutePath());

    private String chrom;
    private String accession;
    private String taskId;

    private File entryDir;
    private File taskDir;
    private File taskEntryDir;

    private File resultInfoFile ;
    private File resultDownloadFile;
    private File resultPDFFile ;
    private File resultPNGFile ;

    public EntryProcess (String chrom, String accession, String taskId){
        this.chrom = chrom;
        this.accession = accession;
        this.taskId = taskId;

        File interactionDir = new File(dataDir,"Interaction");
        this.entryDir = new File(interactionDir,accession);

        File tempDir = new File(dataDir,"temp");
        this.taskDir = new File(tempDir,taskId);
        this.taskEntryDir = new File(taskDir,accession);

        System.out.println(tempDir.getAbsolutePath());
        System.out.println(taskDir.getAbsolutePath());
        System.out.println(taskEntryDir.getAbsolutePath());
    }

    private int checkProcessed(){
        this.resultInfoFile = new File(taskEntryDir,"genes.bedpe");
        this.resultDownloadFile = new File(taskEntryDir,"download.bedpe");
        //this.resultPDFFile = new File(taskEntryDir,"genes_enrichment.pdf");
        //this.resultPNGFile = new File(taskEntryDir,"genes_enrichment.png");
        if( resultInfoFile.isFile() && resultDownloadFile.isFile()){
            return 0;
        }
        return 1;
    }

    private int checkExistence(){
        File enhancerFile = new File(taskDir,"enhancer.bed");

        System.out.println(enhancerFile.getAbsolutePath());
        System.out.println("Enhancer file:" +( (enhancerFile.isFile())? "True":"False"));
        System.out.println(entryDir.getAbsolutePath());
        System.out.println("Entry Dir:" + ((entryDir.isDirectory())? "True":"False"));

        if ( entryDir.isDirectory() && enhancerFile.isFile()){
            return 0;
        }
        else{
            return 1;
        }
    }

    public int runProcessOne(){
        if (checkProcessed()==0){
            return 0;
        }
        else{
            if(checkExistence()==1){
                return 1;
            }
            else{
                String[] intersectCmdString;
                if(isWindows()){
                    intersectCmdString = new String[]{"wsl", "-e", String.format("%s", intersectShellPath), "-i", String.format("%s", dataShellDir), "-c", String.format("%s", chrom), "-a", String.format("%s", accession), "-b", String.format("%s", taskId)};
                }else{
                    intersectCmdString = new String[]{String.format("%s", intersectPath), "-i", String.format("%s", dataDir), "-c", String.format("%s", chrom), "-a", String.format("%s", accession), "-b", String.format("%s", taskId)};
                }
                //String logDir = String.format("/mnt/c/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/hepi/data/temp/%s/%s/intersect_log.txt",taskId,accession);
                System.out.println("Executing cmd: "+ myToString(intersectCmdString));
                ExecCmd intersectCmd = new ExecCmd(intersectCmdString);
                intersectCmd.runCmd();

                String[] enrichCmdString = {"Rscript",String.format("%s",getResultListPath),"-i",String.format("%s",dataDir),"-c",chrom,"-a",accession,"-t",taskId};
                System.out.println("Executing cmd: "+ myToString(enrichCmdString));
                ExecCmd getResultCmd = new ExecCmd(enrichCmdString);
                getResultCmd.runCmd();

                /*
                if(checkProcessed()==0){
                    return 0;
                }
                else{
                    return 2;
                }
                 */
                return 0;
            }
        }
    }

    public int runProcessTwo(){
        if (checkProcessed()==0){
            return 0;
        }
        else{

            String[] enrichCmdString = {"Rscript",String.format("%s",enrichmentAnalysisPath),"-i",String.format("%s",dataDir),"-c",chrom,"-a",accession,"-t",taskId};
            System.out.println("Executing cmd: "+ myToString(enrichCmdString));
            ExecCmd enrichmentCmd = new ExecCmd(enrichCmdString);
            enrichmentCmd.runCmd();

            if(checkProcessed()==0){
                return 0;
            }
            else{
                return 2;
            }

        }
    }

    private boolean isWindows(){
        String OS = System.getProperty("os.name").toLowerCase();
        return OS.indexOf("windows")>=0;
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
            result += s + " ";
        }
        return result;
    }


    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String tastId){
        this.taskId=taskId;
    }

    public String getAccession() {
        return accession;
    }

    public void setAccession(String accession){
        this.accession=accession;
    }

    public String getChrom() {
        return chrom;
    }

    public void setChrom(String chrom){
        this.chrom=chrom;
    }

    public File getResultInfoFile() {
        return resultInfoFile;
    }

    public File getResultDownloadFile() {
        return resultDownloadFile;
    }

    public void setResultDownloadFile(File resultDownloadFile) {
        this.resultDownloadFile = resultDownloadFile;
    }
}
