> testing_hsp70gene.fasta
> alignedtest_hsp70gene.afa
> hsp70profiletest.hmm
> testresults.tbl
> test.txt

for i in hsp70gene_*.fasta
do
	cat $i >> testing_hsp70gene.fasta
done

muscle -align ./testing_hsp70gene.fasta -output alignedtest_hsp70gene.afa

hmmbuild hsp70profiletest.hmm alignedtest_hsp70gene.afa

for proteome in ../proteomes/proteome_*.fasta
do
	name=$(basename "$proteome" .fasta)
	hmmsearch --tblout testresults.tbl hsp70profiletest.hmm "$proteome"
	count=$(grep -v “#” -c "testresults.tbl")
	echo "$name, $count" >> test.txt
done

