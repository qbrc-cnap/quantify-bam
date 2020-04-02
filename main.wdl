import "feature_counts.wdl" as feature_counts

workflow QuantifyWorkflow{

    Array[File] bams
    File gtf
    String output_counts_filename
    String git_repo_url
    String git_commit_hash

    scatter(bam in bams){
        call feature_counts.count_reads as quantify {
            input:
                input_bam = bam,
                gtf = gtf
        }
    }

    call feature_counts.concatenate as merge_counts {
        input:
            count_files = quantify.count_output,
            output_filename = output_counts_filename
    }

    output {
        File final_counts = merge_counts.count_matrix
        Array[File] summaries = quantify.count_output_summary
    }

    meta {
        workflow_title : "BAM file quantification"
        workflow_short_description : "Run featureCounts on BAM files"
        workflow_long_description : "Use this workflow for creating a count matrix in TSV format."
    }

}
