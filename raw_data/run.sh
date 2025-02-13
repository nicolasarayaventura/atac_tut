set -x -e
fastqc_raw="/sc/arion/scratch/arayan01/projects/atac_tut/raw_data/fastqc_initial"
	cat url_links2.txt | while read sample url
        do
	wget -c -O "${fastqc_raw}/${sample}.fastq.gz" "${url}"
        done < url_links2.txt
