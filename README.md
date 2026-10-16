# Midterm-EmmaS-MateoIM
Midterm assignment for Emma Skelhorn and Mateo Icaza-Mastache.



HOW TO USE run_pipeline.sh

run_pipeline will take an example gene fasta file and a directory of proteomes and align, create an HMM profile, and search the proteoms in the directory against that HMM profile.

To use the script run_pipeline.sh, there are 2 arguments that need to be provided:
1- Path for example gene file
2- Path for directory with all of the proteomes

bash run_pipeline.sh $1 $2

In the current directory, this is an example of how run_pipeline.sh will be formatted. Here it processes proteomes against the mcrAgene.

bash run_pipeline.sh /users/micazama/Midterm-EmmaS-MateoIM/bioinformatics_project/ref_sequences/mcrAgene_01.fasta /users/micazama/Midterm-EmmaS-MateoIM/bioinformatics_project/proteomes/


