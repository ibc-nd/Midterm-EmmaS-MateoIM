#! /bin/bash

#The script will take input 1: a reference file, and input 2: a directory.
#The reference file will be in the format where and with its absolute path /path/path/path/gene_number.fasta. For example: hsp70gene_01.fasta.
#The regex code below will take this input, and convert the file name to omitt the number and look for all of the files with that gene.


#The script will also take input 2: a direc. Make sure the absolute path is provided.


#Getting the reference to run through the directory: genename_*.fasta
input_1=$1
wildcard_var=$(basename $input_1 | sed -E 's/_[0-9]+\.fasta$/_\*.fasta/')


#Making a varibale for the gene name
gene_name=$(echo $wildcard_var | sed -E  's/_\*.fasta//')


#Directory where intermediate and result files are placed
inter_dir="./run_pipeline_files"

#removing old compiled files just in case there script is run twice on the same gene. Using the f function because if its not there it causes an error. This prevents the error. 
rm -f "$inter_dir/compiled_$gene_name.fasta"

#Compiling the files into 1. Using driname to have the path but go through all the files using wilcard instead of original file name. 
for i in "$(dirname "$input_1")"/$wildcard_var; do cat $i >> $inter_dir/compiled_$gene_name.fasta; done


#Muscle align
muscle -align $inter_dir/compiled_$gene_name.fasta -output $inter_dir/aligned_$gene_name.afa


#Hmm build
hmmbuild $inter_dir/${gene_name}profile.hmm $inter_dir/aligned_$gene_name.afa

#Creating file with table labels
echo "proteome,num_hits" > pipeline_results.csv


for proteome in $2/proteome_*.fasta
do
name=$(basename "$proteome" .fasta) 
tbl="$inter_dir/$name.tbl"
hmmsearch -E 0.001 -o "$inter_dir/dump.txt" --tblout "$tbl" "$inter_dir/${gene_name}profile.hmm" "$proteome"
count=$(grep -vc '^#' "$tbl")
echo "$name,$count" >> pipeline_results.csv
done
