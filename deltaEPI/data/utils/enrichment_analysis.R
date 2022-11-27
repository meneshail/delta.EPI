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
  INPUT_DIR=normalizePath(opt$i)
  SCRIPT_DIR=file.path(INPUT_DIR,'utils')
  load(file.path(SCRIPT_DIR,'data.RData'))
  sprintf("Source data directory set as %s" ,INPUT_DIR)
}

if (is.null(opt$a) | is.null(opt$t)){
  print("Accession number and task ID could not be empty!")
  quit('no',2)
}else{
  RESULT_DIR=file.path(INPUT_DIR,'temp',opt$t,opt$a)
  RESULT_PATH=file.path(RESULT_DIR,'result.bedpe')
  sprintf("Result file directory %s" ,RESULT_DIR)
}

#####OUT_PUT
RESULT_INFO_PATH=file.path(RESULT_DIR,'genes.bedpe')
ENRICH_PNG_PATH=file.path(RESULT_DIR,'genes_enrichment.png')
ENRICH_PDF_PATH=file.path(RESULT_DIR,'genes_enrichment.pdf')

if(opt$c=='hg38'){
  library(org.Hs.eg.db)
  my_orgdb=org.Hs.eg.db
  my_species='human'
  my_background_keys=as.array(eval(parse(text = paste('hg38_bg_entrez_keys'))))
}else if(opt$c=='mm10'){
  library(org.Mm.eg.db)
  my_orgdb=org.Mm.eg.db
  my_species='mouse'
  my_background_keys=as.array(eval(parse(text = paste('mm10_bg_entrez_keys'))))
}else if(opt$c=='rheMac10'){
  library(org.Mmu.eg.db)
  my_orgdb=org.Mmu.eg.db
  my_species='rhesus'
  my_background_keys=as.array(eval(parse(text = paste('rheMac10_bg_entrez_keys'))))
}

suppressWarnings(library(stringr))
suppressWarnings(library(dplyr))




#RESULT_INFO_PATH="C:/Users/meneshail/Desktop/lab/bioinfo/ehancer-promoter/work/web/HEPI_JSP/HEPI/out/artifacts/hepi/data/temp/1607849597623/HEPI000015/genes.bedpe"

########################################################
#Read result info
print("Reading result info file...")
result2=read.csv(RESULT_INFO_PATH,encoding  = 'UTF-8',sep = ',',header = T)


if(nrow(result2)==0){
  print("No interactions found.")
  quit('no',0)
}


my_genes <- apply(as.array(unique(result2$gene_id)),1,as.character)



#######################################################
#Doing enrichment analysis
suppressWarnings(library(clusterProfiler))
suppressWarnings(library(AnnotationDbi))
suppressWarnings(library(ggplot2))
print("Doing enrichment analysis")
display_number = c(10, 10, 10)
## GO enrichment with clusterProfiler

ego_MF <- enrichGO(OrgDb=my_orgdb,
                   gene = my_genes,
                   pvalueCutoff = 0.5,
                   ont = "MF",
                   universe = my_background_keys,
                   readable=TRUE)
ego_result_MF <- as.data.frame(ego_MF)[1:display_number[1], ]
#ego_MF
# ego_result_MF <- ego_result_MF[order(ego_result_MF$Count),]

ego_CC <- enrichGO(OrgDb=my_orgdb,
                   gene = my_genes,
                   pvalueCutoff = 0.5,
                   ont = "CC",
                   universe = my_background_keys,
                   readable=TRUE)
ego_result_CC <- as.data.frame(ego_CC)[1:display_number[2], ]
#ego_CC
#ego_result_CC <- ego_result_CC[order(ego_result_CC$Count),]

ego_BP <- enrichGO(OrgDb=my_orgdb,
                   gene = my_genes,
                   pvalueCutoff = 0.5,
                   ont = "BP",
                   universe = my_background_keys,
                   readable=TRUE)
ego_result_BP <- as.data.frame(ego_BP)[1:display_number[3], ]
#ego_BP
# ego_result_BP <- ego_result_BP[order(ego_result_BP$Count),]

go_enrich_df <- data.frame(ID=c(ego_result_BP$ID, ego_result_CC$ID, ego_result_MF$ID),
                           Description=c(ego_result_BP$Description, ego_result_CC$Description, ego_result_MF$Description),
                           GeneNumber=c(ego_result_BP$Count, ego_result_CC$Count, ego_result_MF$Count),
                           type=factor(c(rep("biological process", display_number[1]), rep("cellular component", display_number[2]),
                                         rep("molecular function", display_number[3])), levels=c("molecular function", "cellular component", "biological process")))
go_enrich_df=na.omit(go_enrich_df)
## numbers as data on x axis
go_enrich_df$number <- factor(rev(1:nrow(go_enrich_df)))
## shorten the names of GO terms
shorten_names <- function(x, n_word=4, n_char=40){
  if (length(strsplit(x, " ")[[1]]) > n_word || (nchar(x) > 40))
  {
    if (nchar(x) > 40) x <- substr(x, 1, 40)
    x <- paste(paste(strsplit(x, " ")[[1]][1:min(length(strsplit(x," ")[[1]]), n_word)],
                     collapse=" "), "...", sep="")
    return(x)
  } 
  else
  {
    return(x)
  }
}

#go_enrich_df
labels=(sapply(
  unique(go_enrich_df$Description)[as.numeric(as.factor(go_enrich_df$Description))],
  shorten_names))
names(labels) = rev(1:nrow(go_enrich_df))

## colors for bar // green, blue, orange
CPCOLS <- c("#8DA1CB", "#FD8D62", "#66C3A5")

p <- ggplot(data=go_enrich_df, aes(x=number, y=GeneNumber, fill=type)) +
  geom_bar(stat="identity", width=0.8) + coord_flip() + 
  scale_fill_manual(values = CPCOLS) + theme_bw() + 
  scale_x_discrete(labels=labels) +
  xlab("GO term") + 
  theme(axis.text=element_text(face = "bold", color="gray50")) +
  labs(title = "The Most Enriched GO Terms")

#p

print("Creating pdf for enrichment analysis...")
pdf(ENRICH_PDF_PATH)
p
dev.off()

print("Creating png for enrichment analysis...")
png(ENRICH_PNG_PATH,width = 8,height = 6,units ="in",res = 150)
p
dev.off()
##############################################################################

print("All work finished successfully! Exiting...")
quit('no',0)


