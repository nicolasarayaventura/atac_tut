set -x -e

scratch="/sc/arion/scratch/arayan01/projects/atac_tut"
sample_dir="/sc/arion/scratch/arayan01/projects/atac_tut/raw_data/fastqc_initial"

trimming() {
  rm -rf "${scratch}/raw_data/trimming"
  mkdir -p "${scratch}/raw_data/trimming"
  output="${scratch}/raw_data/trimming"
  mkdir -p "${output}/fastqc_trimming"

  for file in "${sample_dir}"/*_*.fastq.gz; do  # Correct globbing
    sample_id="${file%_*.fastq.gz}"
    sample_id="${sample_id##*/}"
    sample1="${sample_dir}/${sample_id}_1.fastq.gz"
    sample2="${sample_dir}/${sample_id}_2.fastq.gz"
    output1_paired="${output}/${sample_id}_tr_1P.fastq.gz" # Correct path
    output1_unpaired="${output}/${sample_id}_tr_1U.fastq.gz"
    output2_paired="${output}/${sample_id}_tr_2P.fastq.gz"
    output2_unpaired="${output}/${sample_id}_tr_2U.fastq.gz"
    adapter_path="/sc/arion/work/arayan01/test-env/envs/atacseq/share/trimmomatic-0.39-2/adapters/NexteraPE-PE.fa" # Correct path

    bsub -P acc_oscarlr -q premium -n 2 -W 24:00 -R "rusage[mem=6000]" -o "${output}/${sample_id}_trimming_job.txt" \
    	trimmomatic PE -threads 2 \
	"${sample1}" "${sample2}" \
	"${output1_paired}" "${output1_unpaired}"\
	"${output2_paired}" "${output2_unpaired}"\
	ILLUMINACLIP:${adapter_path}:2:30:10 MINLEN:30
done 
}
trimming

