if (!exists("filename")) filename='out.dat'
if (!exists("plotname")) plotname='{plotname}'

# Tell gnuplot to use tabs as the delimiter instead of spaces (default)
set datafile separator '\t'

# The graph title
set title sprintf("{/:Bold %s}\nCurva monótona de tiempos de respuesta", plotname)

# Where to place the legend/key
set key off

set ylabel "Tiempo de respuesta (ms)"

set xlabel "Porcentaje de peticiones"
set format x '%2.0f%%'

stats filename every ::2 using 5 prefix "A"

set grid x
set grid y

plot sprintf('<(tail -n +2 %s | sort -n -k 9)', filename) every ::2 using (100*$0/A_records):5 with lines lw 2 t 'Porcentaje de peticiones con un tiempo menor que'
