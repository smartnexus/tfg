if [ $# -eq 0 ] 
then
    echo "Missing HPA name";
    exit 1;
else
    echo "Fetching hpa/$1 data from Kubernetes API"
    echo "seconds,current,desired" > cluster-$1-status.dat
    for i in {0..300}; do
        unix=$(date '+%s')
        status=$(kubectl get horizontalpodautoscaler.autoscaling/$1 -o jsonpath='{.status.currentReplicas},{.status.desiredReplicas}') 
        echo "$unix,$status" >> cluster-$1-status.dat; 
        sleep 1; 
    done
fi