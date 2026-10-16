#! /bin/bash


#run_pipeline will take an example gene fasta file and a directory of proteomes and align, create an HMM profile, and se>

#To use the script run_pipeline.sh, there are 2 arguments that need to be provided:
#1- Path for example gene file
#2- Path for directory with all of the proteomes

#bash run_pipeline.sh $1 $2

#In the scripts directory, this is an example of how run_pipeline.sh will be formatted. Here it processes proteomes agai>

#bash run_pipeline.sh /users/micazama/Midterm-EmmaS-MateoIM/bioinformatics_project/ref_sequences/mcrAgene_01.fasta /user>


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
echo "$name,$count" >> ../results/exercise03/pipeline_results_$gene_name.csv
done
