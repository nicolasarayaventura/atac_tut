set -x -e

function raw_data {
    fastqc_raw="/sc/arion/scratch/arayan01/projects/atac_tut/raw_data/fastqc_initial"    
    while read sample url; do
        wget -O "${fastqc_raw}/${sample}.fastq.gz" "${url}"
    done < url_links.txt
}
raw_data

