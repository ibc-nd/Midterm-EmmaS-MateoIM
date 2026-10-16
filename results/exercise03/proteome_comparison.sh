{
echo "Proteome,hsp70_hits,mcrA_hits"
join -t, -1 1 -2 1 \
	<(sort -t, -k1,1 pipeline_results_hsp70gene.csv) \
	<(sort -t, -k1,1 pipeline_results_mcrAgene.csv) |
	awk -F',' '$3 > 0'
} > proteome_comparison.csv
