#!/bin/bash
if [ $# -lt 3 ] 
then
    echo "Usage: $0 <test-name> <type> <concurrency>";
    exit 1;
else
    extra="Arquitectura no escalable (prueba de concepto)"
    if [ $2 == "flex" ]
    then
        extra="Arquitectura escalable"
    fi
    gnuplot -e "plotname='[$1-$3] $extra';filename='$1/$2/$3/$1-$2-$3.dat';set term pngcairo dashed size 750,500; set output 'results/$1-$2-$3-scatter.png';" scatter.p &> /dev/null
    gnuplot -e "plotname='[$1-$3] $extra';filename='$1/$2/$3/$1-$2-$3.dat';set term pngcairo dashed size 750,500; set output 'results/$1-$2-$3-monotonous.png';" monotonous.p &> /dev/null
    python merge.py $1 $2 $3
    gnuplot -e "plotname='[$1-$3] $extra';filename='$1/$2/$3/${1/p/n}-$2-$3.dat';set term pngcairo dashed size 750,500; set output 'results/$1-$2-$3-replicas.png';" replicas.p &> /dev/null
fi