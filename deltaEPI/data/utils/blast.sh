#!/bin/bash
# shellcheck shell=bash


make_directory(){
    if [[ "$1" = /* ]]
    then
        echo "$1"
    else
        echo  "$curr_path/$1"
    fi
}

print_help(){
    echo "This is Blast_1.0"
    echo "-c for chrom used"
    echo "-i for fasta directory"

}

help=0
curr_path=$(pwd)

while getopts :c:i:h opt
do
    case "$opt" in
    c) 
        echo "Found -c with value $OPTARG" 
        CHROM=$OPTARG ;;
    i) 
        echo "Found -i with value $OPTARG" 
        INPUT_DIR=$(make_directory "$OPTARG");;
    h) help=1 ;;
    *)  ;;
    esac
done


FASTA_PATH=${INPUT_DIR}/target.fa
RESULT_PATH=${INPUT_DIR}/result.txt
RESULT_TEMP_PATH=${INPUT_DIR}/result_temp.txt


echo "$INPUT_DIR"
echo "$FASTA_PATH"
echo "$RESULT_PATH"


if [ $help -eq 1 ]
then
    print_help
    exit 0
elif  [[ ! -f $FASTA_PATH ]]
then
    echo "Error : Could not find input fasta file"
    print_help
    exit 1
else
    
    source /home/zyy/.bashrc
    #echo $PATH

    echo "Doing blast..."
    #blastn -db ${CHROM} -query ${FASTA_PATH} -task blastn -dust no -outfmt "6" -max_target_seqs "1"
    blastn -db ${CHROM} -query ${FASTA_PATH} -task blastn -dust no \
    -outfmt "6" -max_target_seqs "1" | grep Tag > ${RESULT_TEMP_PATH}
    sed '/chrM/d;/random/d;/chrUn/d;/chrEBV/d;/alt/d' <  ${RESULT_TEMP_PATH}  | sort -k 12Vr | head -n 5 > ${RESULT_PATH}

    echo "Successfully doing blast, exiting..."
fi