task count_reads {

    File input_bam
    File gtf

    # Extract the samplename from the fastq filename
    String sample_name_base = basename(input_bam, ".bam")

    String output_counts_name = sample_name_base + ".feature_counts.tsv"

    String strand_option = "0"

    Int disk_size = 200

    command {
        featureCounts \
            -s${strand_option} \
            -p \
            -t exon \
            -g gene_name \
            -a ${gtf} \
            -o ${output_counts_name} \
            ${input_bam}
    }

    output {
        File count_output = "${output_counts_name}"
        File count_output_summary = "${output_counts_name}.summary"
    }

    runtime {
        docker: "docker.io/blawney/star_quant_only:v0.1"
        cpu: 8
        memory: "12 G"
        disks: "local-disk " + disk_size + " HDD"
        preemptible: 0
    }
}

task concatenate {
    # This concatenates the featureCounts count files into a 
    # raw count matrix.

    Array[File] count_files
    String output_filename

    Int disk_size = 30

    command {
        concatenate_featurecounts.py -o ${output_filename} ${sep=" " count_files}
    }

    output {
        File count_matrix = "${output_filename}"
    }

    runtime {
        docker: "docker.io/blawney/star_quant_only:v0.1"
        cpu: 2
        memory: "4 G"
        disks: "local-disk " + disk_size + " HDD"
        preemptible: 0 
    }

}
