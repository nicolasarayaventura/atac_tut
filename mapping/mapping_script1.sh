set -x -e

data_dir="/sc/arion/scratch/arayan01/projects/atac_tut/raw_data/trimming"
sample="/sc/arion/scratch/arayan01/projects/atac_tut/raw_data/trimming/sample_ids.txt"

function indexing {
	rm -r ${data_dir}/indexing
	mkdir ${data_dir}/indexing
	sc="/sc/arion/scratch/arayan01/projects/atac_tut/mapping/SC/SC"
	hybrid="/sc/arion/scratch/arayan01/projects/atac_tut/mapping/hybrid/hybrid"
	samfiles="/sc/arion/scratch/arayan01/projects/atac_tut/raw_data/trimming/indexing"
	while read sample; do
		if [ ${sample} == SRR10261591 ] || [ ${sample} == SRR10261592 ] || [ ${sample} == SRR10261593 ]; then
			ref_gen="${sc}"
			else
			ref_gen="${hybrid}"
		fi
	bsub -P acc_oscarlr -q premium -n 2 -W 24:00 -R "rusage[mem=8000]" -o "job1_${sample}.txt" \
		"bwa mem -t 2 ${ref_gen} ${data_dir}/${sample}_tr_1P.fastq.gz ${data_dir}/${sample}_tr_2P.fastq.gz \
		| samtools sort -@2 -o ${samfiles}/${sample}.bam - \
		&& samtools index ${samfiles}/${sample}.bam \
		&& samtools flagstat ${samfiles}/${sample}.bam > ${samfiles}/${sample}_map_stats.txt"

done < "${sample}"
}
function index_qc {
index_dir="/sc/arion/scratch/arayan01/projects/atac_tut/raw_data/trimming/indexing"
	while read sample; do
		bsub -P acc_oscarlr -q premium -n 2 -W 24:00 -R "rusage[mem=8000]" -o "job2_${sample}.txt" \
			"samtools view -bh ${index_dir}/${sample}.bam I II III IV V VI VII VIII IX X XI XII XIII XIV XV XVI > ${index_dir}/${sample}_SC_subset.bam
			&& picard MarkDuplicates I=${index_dir}/${sample}_SC_subset.bam O=${index_dir}/${sample}_SC_subset_dedup.bam M=${index_dir}/${sample}_markdup_metrics.txt \
			& samtools index ${index_dir}/${sample}_SC_subset_dedup.bam \
			&& samtools flagstat ${index_dir}/${sample}_SC_subset_dedup.bam > ${index_dir}/${sample}_SC_subset_dedup_map_stats.txt"
done < "${sample}"
}

#indexing
index_qc
