#!/bin/bash
# runs repeat masking for the genome after constructing custom repeat library
# uses repeat modeler for building custom db and RepeatMasking for masking
# run it as:
# runRepeatModeler.sh Genome.fasta
# based on Rick's guide https://intranet.gif.biotech.iastate.edu/doku.php/people:remkv6:genome738polished_repeatmodeler_--de_novo_repeat_identification

if [ $# -lt 1 ] ; then
        echo "usage: runRepeatModeler <genome.fasta>"
        echo ""
        echo "To build custom repeat library and mask the repeats of the genome"
        echo ""
exit 0
fi


GENOME="$1"
module use /shared/software/GIF/modules/
module purge
module load parallel

module load GIF2/repeatmasker/4.0.6
module load GIF2/repeatmodeler/1.0.8
module load GIF2/perl/5.22.1
DATABASE="$(basename ${GENOME%.*}).DB"
BuildDatabase -name ${DATABASE} -engine ncbi ${GENOME}
RepeatModeler -database ${DATABASE}  -engine ncbi -pa 16
ln -s $(find $(pwd) -name "consensi.fa.classified")
RepeatMasker -pa 16 -gff -lib consensi.fa.classified ${GENOME}

