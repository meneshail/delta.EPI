#!/bin/bash
# shellcheck shell=bash

function findInputOverlap {
    echo "Finding loops that overlap an enhancer..." ;
    echo "bedtools intersect -a $QUERY_PATH -b ${INTER_DIR}/${1}_loops.bedpe -sorted -wo -g  ${CHROM_PATH} > $OUTPUT_DIR/${1}_enhancer_over_loops.bed"
    bedtools intersect -a "$QUERY_PATH" -b "${INTER_DIR}"/${1}_loops.bedpe -sorted -wo -g  "${CHROM_PATH}"  >  "$OUTPUT_DIR"/${1}_enhancer_over_loops.bed || return 4
    
    cut -f 8-15 "${OUTPUT_DIR}"/${1}_enhancer_over_loops.bed | sort -k 1,1V -k 2,2n -k 4,4V -k 5,5n -k 7,7n -u | awk '{printf("%s\t%s\n",$0,method)}' method=$1 >> "${OUTPUT_DIR}"/raw_loops.bedpe
    
    cut -f 11-13 "$OUTPUT_DIR/${1}_enhancer_over_loops.bed" > "$OUTPUT_DIR/${1}_eol.temp1.bed" ;
    cut -f 11-13 --complement "$OUTPUT_DIR/${1}_enhancer_over_loops.bed" > "$OUTPUT_DIR/${1}_eol.temp2.bed" ;
    paste "$OUTPUT_DIR/${1}_eol.temp1.bed" "$OUTPUT_DIR/${1}_eol.temp2.bed"  | sort -k 1,1V -k 2,2n > "$OUTPUT_DIR/${1}_eol_reverse.bed"

    #rm "$OUTPUT_DIR/${1}_eol.temp1.bed" "$OUTPUT_DIR/${1}_eol.temp2.bed" ;

    return 0
}

function findResultOverlap(){
    echo "Finding target region that overlap a targetted loops..." ;
    echo "Target file : ${2}"
    echo "Category : ${3}"
    bedtools intersect -a "$OUTPUT_DIR/${1}_eol_reverse.bed" -b "${2}" -wo -sorted -g "${CHROM_PATH}" > "$OUTPUT_DIR/${1}_loops_over_${3}.bed"  || return 5
    
    echo "Creating result..." ;
    #awk 'BEGIN{FS="\t"; OFS="\t"} {print $4,$5,$6,$14,$15,$16,$7,$17,".",$19,$13,$20,$11,$12,method}' method="$1" "$OUTPUT_DIR/${1}_loops_over_${3}.bed"  | sort -k 1,1V -k 2,2n >> "$OUTPUT_DIR/result.bedpe" ;
    awk 'BEGIN{FS="\t"; OFS="\t"} {print $4,$5,$6,$17,$18,$19,$7,$20,$9,$22,$10,$23,$16,$24,$14,$15,method}' method="$1" "$OUTPUT_DIR/${1}_loops_over_${3}.bed" | awk '{printf("%s\t%s%s\n",$0, ($11=="QUERY")? "" : (($11=="TSS")? "P" : "E"),($12=="TSS")? "P" : "E")}' | sort -k 1,1V -k 2,2n -k 4,4V -k 5,5n >> "$OUTPUT_DIR/result.bedpe" ;

    #rm "$OUTPUT_DIR/${1}_loops_over_${3}.bed" 
    
    printf "Successfully created result file for %s\n" "${1}"
    
}

make_directory(){
    if [[ "$1" = /* ]]
    then
        echo "$1"
    else
        echo  "$curr_path/$1"
    fi
}

print_help(){
    echo "This is Post_Intersect_2.0"
    echo "-c for chrom used"
    echo "-i for data directory"
    echo "-a for entry accession"
    echo "-b for taskid"
    echo "-l for cell line"
    echo "-p for displayPair"
    echo "-u for useDataset"
    echo "-h for help"
}

help=0
curr_path=$(pwd)
TOTAL_METHOD=(cLoops Homer2 Hiccups FitHiC)
QUERY_WHOLE_FLAG=0
QUERY_P_FLAG=0
QUERY_E_FLAG=0
INTER_P_FLAG=0
INTER_E_FLAG=0
TSS_ALL_FLAG=0
TSS_PROTEIN_FLAG=0
FANTOM_FLAG=0
CHROMHMM_FLAG=0
CRE_FLAG=0
CELL_LINE=GM12878


while getopts :c:l:p:u:i:a:b:h opt
do
    case "$opt" in
    c) 
        echo "Found -c with value $OPTARG" 
        CHROM=$OPTARG ;;
    l)
        echo "Found -l with value $OPTARG"
        CELL_LINE=$OPTARG ;;
    p)  
        echo "Found -p with value $OPTARG"
        DISPLAY_PAIR=$OPTARG ;;
    u)  
        echo "Found -u with value $OPTARG"
        USE_DATASET=$OPTARG ;;
    i) 
        echo "Found -i with value $OPTARG" 
        DATA_PATH=$(make_directory "$OPTARG");;
    a) 
        echo "Found -a with value $OPTARG" 
        ACCESSION="$OPTARG" ;;
    b)
        echo "Found -b with value $OPTARG"
        TASKID=$OPTARG ;;
    h) help=1 ;;
    *)  ;;
    esac
done

CHROM_PATH=${DATA_PATH}/Chrom/${CHROM}.chrom.sizes
TSS_ALL_PATH=${DATA_PATH}/TSS/${CHROM}.TSS.bed
TSS_PROTEIN_PATH=${DATA_PATH}/TSS/${CHROM}.TSS2.bed
INPUT_PATH=${DATA_PATH}/temp/${TASKID}/enhancer.bed
QUERY_PATH=${DATA_PATH}/temp/${TASKID}/query.bed
INTER_DIR=${DATA_PATH}/Interaction/${ACCESSION}
OUTPUT_DIR=${DATA_PATH}/temp/${TASKID}/${ACCESSION}

FANTOM_PATH=${DATA_PATH}/Enhancer/FANTOM5/${CHROM}.enhancers.bed
CHROMHMM_PATH=${DATA_PATH}/Enhancer/ChromHMM/${CHROM}.${CELL_LINE}.enhancers.bed
CRE_PATH=${DATA_PATH}/Enhancer/cCRE-dELS/${CHROM}.${CELL_LINE}.enhancers.bed

echo "input query : ${INPUT_PATH}"
echo "output dir : ${OUTPUT_DIR}"
echo "interaction dir : ${INTER_DIR}"


echo "chrom.sizes : ${CHROM_PATH}"
echo "TSS : ${TSS_ALL_PATH}"
echo "FANTOM : ${FANTOM_PATH}"
echo "ChromHMM : ${CHROMHMM_PATH}"


if [ $help -eq 1 ]
then
    print_help
    exit 0
elif  [ ! -f "${CHROM_PATH}"  ] || ( [ ! -f $INPUT_PATH ] && [ ! -f $QUERY_PATH ] ) ||  [ ! -f $TSS_ALL_PATH ] || [ ! -f $TSS_PROTEIN_PATH ] || [ ! -d $INTER_DIR ] 
then
    if [ ! -f "$CHROM_PATH" ]
    then 
        echo "No chrom.sizes file found at CHROM_PATH !"
    fi
    if [ ! -f $INPUT_PATH ] && [ ! -f $QUERY_PATH ]
    then 
        echo "The input query file path is not valid !"
    fi
    if  [ ! -f "$TSS_ALL_PATH" ] 
    then 
        echo "No TSS file found at TSS_PATH !"
    fi
    if [ ! -d $INTER_DIR ]
    then 
        echo "The interaction files directory found at INTER_DIR !"
    fi
    print_help
    exit 1
else
################################   check result directory existence    #########################
    if [ -d "$OUTPUT_DIR" ]
    then
        echo "Warning : Output directory for this enhancer-entry pair already exists, removing..."
        rm -r "$OUTPUT_DIR"
    fi
    mkdir -p "$OUTPUT_DIR"

####################################    modify tag value  #####################################
    if ((DISPLAY_PAIR & (1<<0)))
    then
        QUERY_WHOLE_FLAG=1
    else 
        if ((DISPLAY_PAIR & (1<<1)))
        then 
            QUERY_P_FLAG=1
        fi
        if ((DISPLAY_PAIR & (1<<2)))
        then 
            QUERY_E_FLAG=1
        fi
    fi  
    if ((DISPLAY_PAIR & (1<<3)))
    then 
        INTER_P_FLAG=1
    fi
    if ((DISPLAY_PAIR & (1<<4)))
    then 
        INTER_E_FLAG=1
    fi
    if ((USE_DATASET & (1<<0)))
    then
        TSS_ALL_FLAG=1
    fi
    if ((USE_DATASET & (1<<1)))
    then 
        TSS_PROTEIN_FLAG=1
    fi
    if ((USE_DATASET & (1<<2)))
    then 
        FANTOM_FLAG=1
    fi
    if ((USE_DATASET & (1<<3)))
    then 
        CHROMHMM_FLAG=1
    fi
    if ((USE_DATASET & (1<<4)))
    then 
        CRE_FLAG=1
    fi
    
    
####################################     modify query file      #######################################

    mv "${INPUT_PATH}" "${INPUT_PATH}.temp"
    sort -k 1,1V -k 2,2n "${INPUT_PATH}.temp" > "${INPUT_PATH}"
    rm "${INPUT_PATH}.temp"

    if [ ! -f $QUERY_PATH ]
    then
        echo "Creating query file for interaction searching.."
        if ((QUERY_WHOLE_FLAG))
        then 
            echo "Using query region as a whole."
            cp ${INPUT_PATH} ${QUERY_PATH}
        else 
            echo "Spliting input query into smaller elements.."
            if ((QUERY_P_FLAG))
            then 
                echo "Finding promoter elements within query region."
                if ((TSS_ALL_FLAG))
                then 
                    bedtools intersect -a "${TSS_ALL_PATH}" -b "${INPUT_PATH}" -sorted -g "${CHROM_PATH}" >> "${QUERY_PATH}"
                fi
                if ((TSS_PROTEIN_FLAG))
                then 
                    bedtools intersect -a "${TSS_PROTEIN_PATH}" -b "${INPUT_PATH}" -sorted -g "${CHROM_PATH}" >> "${QUERY_PATH}"
                fi
            fi
            if ((QUERY_E_FLAG))
            then 
                echo "Finding enhancer elements within query region."
                if ((FANTOM_FLAG))
                then 
                    bedtools intersect -a "${FANTOM_PATH}" -b "${INPUT_PATH}" -sorted -g "${CHROM_PATH}" >> "${QUERY_PATH}"
                fi
                if ((CHROMHMM_FLAG))
                then 
                    bedtools intersect -a "${CHROMHMM_PATH}" -b "${INPUT_PATH}" -sorted -g "${CHROM_PATH}" >> "${QUERY_PATH}"
                fi  
                if ((CRE_FLAG))
                then 
                    bedtools intersect -a "${CRE_PATH}" -b "${INPUT_PATH}" -sorted -g "${CHROM_PATH}" >> "${QUERY_PATH}"
                fi 
            fi
        fi

    else  
        echo "Query file found."
    fi
    
    mv "${QUERY_PATH}" "${QUERY_PATH}.temp"
    sort -k 1,1V -k 2,2n "${QUERY_PATH}.temp" > "${QUERY_PATH}"
    rm "${QUERY_PATH}.temp"
    echo "Successfully created query file."

        

#########################     interaction searching      ######################################

    for method in "${TOTAL_METHOD[@]}"
    do
        findInputOverlap $method

        if ((INTER_P_FLAG))
        then 
            if ((TSS_ALL_FLAG))
            then
                echo "Finding interactions with TSS.."
                findResultOverlap "$method" "$TSS_ALL_PATH" All_TSS
            fi
            if ((TSS_PROTEIN_FLAG))
            then
                echo "Finding interactions with TSS.."
                findResultOverlap "$method" "$TSS_PROTEIN_PATH" Protein_encoding_TSS
            fi
        fi 
        if ((INTER_E_FLAG))
        then 
            if ((FANTOM_FLAG == 1))
            then
                echo "Finding interactions with FANTOM enhancers.."
                if [ ! -f ${FANTOM_PATH} ]
                then 
                    echo "Error : Fail to find FANTOM enhancer file for ${CHROM}, skipping.."
                else
                    findResultOverlap "$method" "$FANTOM_PATH" FANTOM5
                fi
            fi
            if ((CHROMHMM_FLAG == 1))
            then
                echo "Finding interactions with ChromHMM regions.."
                if [ ! -f ${CHROMHMM_PATH} ]
                then 
                    echo "Error : Fail to find ChromHMM enhancer file for ${CHROM} ${CELL_LINE}, skipping.."
                else 
                    findResultOverlap "$method" "$CHROMHMM_PATH" ChromHMM
                fi
            fi
            if ((CRE_FLAG == 1))
            then
                echo "Finding interactions with ENCODE cCRE-dELS.."
                if [ ! -f ${CRE_PATH} ]
                then 
                    echo "Error : Fail to find cCRE-dELS file for ${CHROM} ${CELL_LINE}, skipping.."
                else 
                    findResultOverlap "$method" "$CRE_PATH" cCRE
                fi
            fi
        fi
    done 

    echo "Successfully created all results. Exit with status code 0. "


fi