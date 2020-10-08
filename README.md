# HPV-EM

HPV-EM is an HPV genotyping tool that utilizes an expectation maximization algorithm to identify the presence of different HPV genotypes in a sample from RNA-seq data. 

## Prerequisites
  - [python](https://www.python.org/) (v 2.7 or 3+)
    - [NumPy](http://http://www.numpy.org/)
    - [Matplotlib](https://matplotlib.org/)
    - [whichcraft](https://pypi.org/project/whichcraft/)
  - [STAR](https://github.com/alexdobin/STAR)
    - to compile STAR, you may need to install [CMAKE](https://cmake.org/) or [gcc](https://gcc.gnu.org/)
  - [SAMtools](http://samtools.sourceforge.net/)
  
## Installation
First ensure the prerequisites have been installed on your system and that STAR and SAMtools appear in your PATH.  In order for STAR to align reads against the human genome, you will first need to obtain the human reference genome in FASTA format and a corresponding annotation file in GTF format (these can be downloaded from [Ensembl](https://ensembl.org/Homo_sapiens/Info/Index)).  You must then generate genome indexes for STAR aligner using its genomeGenerate command (see the STAR documentation for details).

You can then download HPV-EM from https://github.com/jin-wash-u/HPV-EM.  Click on "Clone or download" and then click on "Download ZIP".  Unzip the contents in the desired location.  

STAR must also generate indexes for the viral reference genome.  The packaged set of HPV genomes is found at reference/combined_pave_hpv.fa.  This default viral reference should be indexed using the command:
```
$ STAR --runMode genomeGenerate --genomeFastaFiles reference/combined_pave_hpv.fa --genomeSAindexNbases 9 --genomeDir reference/combined_pave_hpv_STAR
```

If you desire, you can include HPV-EM in your PATH by running:
```
$ export PATH=$INSTALLDIR:$PATH
```
where `$INSTALLDIR` is the folder into which you extracted the HPV-EM files.
  
  
## Input
Running HPV-EM with the -h option (or --help) will print a desciption of its optional and required input arguments.  A description of each follows.
```
HPV-EM.py [-h] [-t THREADS] [-r REFERENCE] [--starviral STARVIRAL] [-o OUTNAME]
          [-d] [--tpm TPM] [-p] [-k] [-v] -s STARGENOME reads1 [reads2]
```
### Optional arguments
- -h, --help  
      Prints the help menu, which contains an example of the function usage and abbreviated explanations of each of the options.
- -t THREADS, --threads THREADS  
     Some portions of the HPV-EM pipeline support multithreading; if you wish to use this feature, set this to the number of cores available (default: 1)
- -r REFERENCE, --reference REFERENCE  
     HPV-EM includes a comprehensive set of HPV reference genomes assembled by PaVE, the use of which is recommended.  However, if you wish to supply your own viral reference in FASTA format, use this option with the path to the file
- --starviral STARVIRAL  
     path to a directory containing STAR-generated viral genome indexes based on the reference FASTA
- -o OUTNAME, --outname OUTNAME  
     Prefix attached to output file names (default: ./hpvEM)
- -d, --disabledust  
     By default, HPV-EM filters low-complexity reads using the DUST algorithm.  Specify this option to disable filtering
- --tpm TPM  
     TPM threshold for identifying a true positive HPV genotype (default: 1.48)
- -p, --printem  
     Causes HPV-EM to print its results to STDOUT
- -k, --keepint  
     By default, HPV-EM removes files generated by intermediate steps of the pipeline. Specify this option to keep these files
- -v, --version  
     Print program's version number and exit

### Required arguments
- -s STARGENOME, --stargenome STARGENOME  
     Path to the directory containing STAR-generated human genome index files

### Positional arguments
- reads1 : A FASTQ file of single-end RNA-seq reads or the first of two paired-end FASTQs 
- reads2 : (optional) Second paired-end FASTQ file  
  Reads files may be gzipped; if so, the filename must end in ".gz".

## Output
  The output of the EM algorithm is written to OUTNAME.results.tsv (and, optionally, printed to stdout).  The first two lines indicate how may steps the algorithm took to converge and the maximum likelihood estimate (MLE) of the sequencing error rate.  The remaining lines have the format:
  
```
HPVtype   MappedReads   MappedProportion   MLE_Reads   MLE_Probability
```
This is a table including each HPV type with at least one read mapped to it, indicating the number of mapped reads, the proportion of all reads mapped to the HPV reference genomes mapped to this type, the MLE of the expected number of reads for this HPV type, and the MLE probability of this HPV type.

In addition to the results table, HPV-EM also generates read coverage maps for each HPV type with a non-zero MLE probability (OUTNAME.\*.cov.pdf) and a visualization of the difference between the mapped reads proportions and MLE probabilites (OUTNAME.props.pdf).  The reads aligned to the HPV references are also recorded in BAM format (OUTNAME.aligned.\*.bam).
