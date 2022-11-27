suppressWarnings(require(optparse))

option_list <- list(
  make_option(c('-i','--input_dir'),action="store",type="character",default = NULL,
              help="Data directory"),
  make_option(c("-a","--accession"),action = "store",type = "character",default = NULL,
              help="Entry accession number"),
  make_option(c('-t','--taskid'),action = 'store',type = 'character',default = NULL,
              help = 'task(session) ID'),
  make_option(c('-c','--chrom'),action = 'store',type='character',default = NULL,
              help = 'Reference genome')
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

if (is.null(opt$i)){
  print("Data directory could not be empty!")
  quit('no',1)
}else{
  print(opt$i)
  print(".")
  print(normalizePath(opt$i))
  INPUT_DIR=normalizePath(opt$i)
  #SCRIPT_DIR=file.path(INPUT_DIR,'utils')
  #load(file.path(SCRIPT_DIR,'data.RData'))
  sprintf("Source data directory set as %s" ,INPUT_DIR)
}

if (is.null(opt$a) | is.null(opt$t)){
  print("Accession number and task ID could not be empty!")
  quit('no',2)
}else{
  RESULT_DIR=file.path(INPUT_DIR,'temp',opt$t,opt$a)
  RESULT_PATH=file.path(RESULT_DIR,'result.bedpe')
  RAW_PATH=file.path(RESULT_DIR,'raw_loops.bedpe')
  sprintf("Result file directory %s" ,RESULT_DIR)
}

#####OUT_PUT
RESULT_INFO_PATH=file.path(RESULT_DIR,'genes.bedpe')
GFF_DIR=file.path(RESULT_DIR,'GFF')
RAW_GFF_DIR=file.path(RESULT_DIR,'RAW')

#suppressWarnings(library(stringr))
suppressWarnings(library(dplyr))


#suppressWarnings(library(mygene))
#suppressWarnings(library(GOSim))



########################################################
#Analyzing result.bedpe
print("Analyzing result.bedpe")
print(RESULT_PATH)
#RESULT_PATH="C:/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/deltaEPI/data/temp/1618104412619/HEPI000015/result.bedpe"
#RAW_PATH="C:/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/deltaEPI/data/temp/1618104412619/HEPI000015/raw_loops.bedpe"
result=read.table(RESULT_PATH,header = F,
                  col.names = c("chr1",'start1','end1','chr2','start2','end2','query_id','inter_id','strand1','strand2','class1','class2','overlap1','overlap2','bin','sig','method_factor','inter_class'),sep = '\t')

result$method_factor=as.character(result$method_factor)
#print(typeof(result$method_factor))
#print(typeof(result$method_factor[1]))


result2 = distinct(result,result$query_id,result$inter_id,result$method_factor,result$bin,.keep_all = T)[,c(1:12,17,15,18)]

chrom_order <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY")
method_order <- c("Hiccups","FitHiC","cLoops","Homer2")
result2$chr1 = factor(result2$chr1,chrom_order,ordered = T)
result2$chr2 = factor(result2$chr2,chrom_order,ordered = T)
result2$method_factor = factor(result2$method_factor,method_order,ordered = T)


result2 = result2[order(result2$query_id,result2$inter_id,result2$method_factor,result2$bin),]
result2 = distinct(result2,result2$query_id,result2$inter_id,result2$method_factor,.keep_all = T)[,1:15]

if(nrow(result2)==0){
  print("No interactions found.")
  #result2$name=""
  #result2$Score=""
  write.csv(result2,RESULT_INFO_PATH,row.names = F,fileEncoding = 'UTF-8',quote = F)
  
}else{
  #result2=result2[order(result2$enhancer_name,result2$gene_id),]
  result2$method_count=0
  result2$drop=0
  #result2$min_bin=0
  result2$bin_chr=''
  result2$method=''
  pre_gene=result2$inter_id[1]
  pre_enhan=result2$query_id[1]
  pre_index=1
  #paste0(result2$method_factor[1:2],collapse = ' ; ')
  
  for(i in 1:nrow(result2)){
    if(result2$query_id[i]==pre_enhan & result2$inter_id[i]==pre_gene){  }
    else{
      result2$method[pre_index] = paste0(result2$method_factor[pre_index:(i-1)],collapse = " ; ")
      result2$bin_chr[pre_index] = paste0(result2$bin[pre_index:(i-1)],collapse = ";")
      result2$bin[pre_index]=min(result2$bin[pre_index:(i-1)])
      result2$method_count[pre_index] = i-pre_index
      if(pre_index+1<=i-1){
        result2$drop[(pre_index+1):(i-1)]=1
      }
      pre_enhan = result2$query_id[i]
      pre_gene = result2$inter_id[i]
      pre_index = i
    }
  }
  i=nrow(result2)+1
  result2$method[pre_index] = paste0(result2$method_factor[pre_index:(i-1)],collapse = " ; ")
  result2$bin_chr[pre_index] = paste0(result2$bin[pre_index:(i-1)],collapse = ";")
  result2$bin[pre_index]=min(result2$bin[pre_index:(i-1)])
  result2$method_count[pre_index] = i-pre_index
  if(pre_index+1<=i-1){
    result2$drop[(pre_index+1):(i-1)]=1
  }
  
  
  result2=result2[result2$drop==0,]
  
  #my_genes <- apply(as.array(unique(result2$gene_id)),1,as.character)
  
  ######################################################
  
  result2=result2[order(result2$bin,4-result2$method_count,result2$method_factor,result2$chr1,result2$start1,result2$start2),][,c(1:12,19,18,15)]
  colnames(result2)[14] = 'bin_size'
  
  #result2$Score=1
  
  print("Creating result info file...")
  write.csv(result2,RESULT_INFO_PATH,row.names = F,fileEncoding = 'UTF-8',quote = T)
  
  print("Successfully creating result file, proceeding to GFF file creating")
  
}



#############################################################################

swap_index = which(result2$start1>result2$start2)
result2[swap_index,c('chr1','start1','end1','chr2','start2','end2')] = result2[swap_index,c('chr2','start2','end2','chr1','start1','end1')]


result2 = result2[order(result2$chr1,result2$start1,result2$start2),]
result2$index = 1:nrow(result2)
result2$class1[which(result2$class1=="TSS")]=result2$query_id[which(result2$class1=="TSS")]
result2$class2[which(result2$class2=="TSS")]=result2$inter_id[which(result2$class2=="TSS")]

for(chr in chrom_order){
  sprintf("%s",chr)
  temp = result2[which(result2$chr1==chr & result2$chr2==chr),]
  row_count = nrow(temp)
  #print(nrow(temp))
  file_dir=sprintf('%s/%s',GFF_DIR,strsplit(chr,"chr")[[1]][2])
  file_path=sprintf("%s/arc.gff3",file_dir)
  dir.create(file_dir,recursive = T)
  if(nrow(temp)>0){
    temp$info = mapply(function(a,b,c,d,e,f,g,h) sprintf("ID=%d;Name=%s|%s*%s;Note=%s:%d-%d|%s:%d-%d",a,f,g,h,chr,b,c,chr,d,e),temp$index,temp$start1,temp$end1,temp$start2,temp$end2,temp$inter_class,temp$class1,temp$class2)
    #temp$info = mapply(function(a,b,c,d,e) sprintf("ID=%d;Name=%d;Note=%s:%d-%d|%s:%d-%d",a,a,chr,b,c,chr,d,e),temp$index,temp$start1,temp$end1,temp$start2,temp$end2)
    
    temp2 = temp[,c('chr1','start1','end2','info')]
    temp2$col2='hic' ; temp2$col3='arc' ;temp2$col6='.' ;temp2$col7='.';temp2$col8='.'
    temp2=temp2[,c('chr1','col2','col3','start1','end2','col6','col7','col8','info')]
    
    write.table(temp2,file = file_path,fileEncoding = 'UTF-8',col.names = F,row.names = F,quote = F,sep = '\t')
    
  }else{
    print("No row in current chrom")
    write.table(temp,file = file_path,fileEncoding = 'UTF-8',col.names = F,row.names = F,quote = F,sep = '\t')
  }
}

print("Successfully create gff files.")

###########################################################################################################################
print("Creating gff files of raw loops...")
#RAW_PATH="C:/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/deltaEPI/data/temp/test_0429_15_CRE/HEPI000015/raw_loops.bedpe"
#RAW_GFF_DIR="C:/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/deltaEPI/data/temp/test_0429_15_CRE/HEPI000015/RAW"

raw_loops=read.table(RAW_PATH,header = F,
                  col.names = c("chr1",'start1','end1','chr2','start2','end2','bin','sig','method_factor'),sep = '\t')

swap_index = which(raw_loops$start1>raw_loops$start2)
raw_loops[swap_index,c('chr1','start1','end1','chr2','start2','end2')] = raw_loops[swap_index,c('chr2','start2','end2','chr1','start1','end1')]


raw_loops$chr1=factor(raw_loops$chr1,chrom_order,ordered = T)
raw_loops$chr2 = factor(raw_loops$chr2,chrom_order,ordered = T)
raw_loops$method_factor = factor(raw_loops$method_factor,method_order,ordered = T)
raw_loops$mid1=(raw_loops$start1+raw_loops$end1)/2
raw_loops$mid2=(raw_loops$start2+raw_loops$end2)/2
raw_loops=raw_loops[order(raw_loops$chr1,raw_loops$mid1,raw_loops$mid2,raw_loops$bin),]
raw_loops=distinct(raw_loops,raw_loops$mid1,raw_loops$mid2,raw_loops$method_factor,.keep_all = T)[,1:9]
raw_loops=raw_loops[order(raw_loops$chr1,raw_loops$start1,raw_loops$start2,raw_loops$bin),]
raw_loops$index=1:nrow(raw_loops)

for(chr in chrom_order){
  sprintf("%s",chr)
  temp = raw_loops[which(raw_loops$chr1==chr & raw_loops$chr2==chr),]
  row_count = nrow(temp)
  #print(nrow(temp))
  file_dir=sprintf('%s/%s',RAW_GFF_DIR,strsplit(chr,"chr")[[1]][2])
  file_path=sprintf("%s/arc.gff3",file_dir)
  dir.create(file_dir,recursive = T)
  if(nrow(temp)>0){
    #temp$info = mapply(function(a,b,c,d,e,f,g,h) sprintf("ID=%d;Name=%s|%s*%s;Note=%s:%d-%d|%s:%d-%d",a,f,g,h,chr,b,c,chr,d,e),temp$index,temp$start1,temp$end1,temp$start2,temp$end2,temp$inter_class,temp$class1,temp$class2)
    temp$info = mapply(function(a,b,c,d,e,f,g,h) sprintf("ID=%d;Name=%s_loop;Note=%s:%d-%d|%s:%d-%d;Method=%s;Bin=%d;Sig=%s",a,f,chr,b,c,chr,d,e,f,g,h),temp$index,temp$start1,temp$end1,temp$start2,temp$end2,temp$method_factor,temp$bin,temp$sig)
    
    temp2 = temp[,c('chr1','start1','end2','info')]
    temp2$col2='hic' ; temp2$col3='arc' ;temp2$col6='.' ;temp2$col7='.';temp2$col8='.'
    temp2=temp2[,c('chr1','col2','col3','start1','end2','col6','col7','col8','info')]
    
    write.table(temp2,file = file_path,fileEncoding = 'UTF-8',col.names = F,row.names = F,quote = F,sep = '\t')
    
  }else{
    print("No row in current chrom")
    write.table(temp,file = file_path,fileEncoding = 'UTF-8',col.names = F,row.names = F,quote = F,sep = '\t')
  }
}

print("Successfully create raw gff files.")

################################################################################################

print("All work finished successfully! Exiting...")
quit('no',0)
