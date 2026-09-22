#---------------------------------
#CiaraBriones_chr21.sh
#---------------------------------
# Author: Ciara Briones
# version 16 Sept. 2026
#
#For this class exercise, we:
#
#-  Download the human genome annotation (gtf file, the whole genome, all chromosomes).
#- Extract only the information for chromosome 21.
#- Extract the gene names and accession numbers on chromosome 21.
#- Randomly select 20 genes and download their actual sequences from NCBI, in a single loop.
#------------------------------------------------------------------
bash #Always make sure you are in the bash shell before running this script.
mkdir -p class_exercises/9_14_26/ class_exercises/input_data/ class_exercises/analysis/ #This command creates the directories for the exercise, if they do not already exist.
cd class_exercises
cd input_data

curl -o hg38.ncbiRefSeq.gtf.gz "https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz"   #This command downloads the URL to the directory you are currently in.

# Doesn't have to be included but "less hg38.ncbiRefSeq.gtf.gz"  allows you to view the contents of the file. You can use the arrow keys to scroll through the file, and press 'q' to quit.

gunzip hg38.ncbiRefSeq.gtf.gz #This command unzips the file.

cd ../ #This command moves you to the previous directory.
cd analysis #This command opens the analysis directory.

ln -s ../input_data/hg38.ncbiRefSeq.gtf #This command creates a soft link to the file in the current directory.

grep -c "chr21" hg38.ncbiRefSeq.gtf #This command counts the number of lines in the file that contain the string "chr21", which corresponds to chromosome 21.

grep "NM_" chr21.gtf > refseq_chr21.gtf #This command extracts all lines from the file that contain the string "NM_", which corresponds to accession numbers, and saves them to a new file called refseq_chr21.gtf.


awk -F '\t' '{print $9}' refseq_chr21.gtf  | awk -F'"' '!seen[$2]++ {print $2, $4}' refseq_chr21.gtf > gene_accession.txt #This command extracts only the first row from table 2 and 4 from column 9.

# To check this:

wc -l gene_accession.txt 
head gene_accession.txt  

head -n 10 gene_accession.txt > 10_genes.txt #This command extracts the first 10 lines from the file and saves them to a new file called 10_genes.txt.
cat 10_genes.txt #This command displays the contents of the file 10_genes.txt.

while read -r gene accession
do
    curl -o "${gene}.fasta" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${accession}&rettype=fasta&retmode=text"

done < 10_genes.txt
#This command reads each line from the file 10_genes.txt, and for each line, it extracts the gene name and accession number, and uses them to download the corresponding sequence in FASTA format from NCBI.

# To check the results:
ls -l *.fasta 





















