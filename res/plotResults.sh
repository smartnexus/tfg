if [ $# -lt 3 ] 
then
    echo "Usage: $0 <test-name> <type> <concurrency>";
    exit 1;
else
    gnuplot -persist -e "filename='$1/$2/$3/$1-$2-$3.dat'" scatter.p &> /dev/null
    gnuplot -persist -e "filename='$1/$2/$3/$1-$2-$3.dat'" monotonous.p &> /dev/null
    python merge.py $1 $2 $3
    gnuplot -persist -e "filename='$1/$2/$3/${1/p/n}-$2-$3.dat'" replicas.p &> /dev/null
fi