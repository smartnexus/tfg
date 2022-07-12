if (!exists("filename")) filename='out.dat'
if (!exists("plotname")) plotname='{plotname}'

# This sets the aspect ratio of the graph
set size 1, 1
# The graph title
set title sprintf("{/:Bold %s}\nEvolución del numero de instancias durante la ejecución de la prueba", plotname)
# Where to place the legend/key
set key top left box lt -1 lw 0.5
# Draw gridlines oriented on the y axis
set grid y
set grid x
# Label the x-axis
set xlabel 'Duración del experimento (s)'
# Label the y-axis
set ylabel "Número de instancias de cada Pod"
# Tell gnuplot to use tabs as the delimiter instead of spaces (default)
set datafile separator '\t'
offset=system(sprintf("sort -n -k 1 %s | awk 'FNR == 2 {print $1}'", filename))
# Plot the data
#plot filename every ::1 using ($1-offset):2 with lines lw 2 lt 1

set yrange [0:15]
set xrange [0:280]

plot filename using 2 title 'Instancias medidas del Pod' with lines lw 2, \
     filename using 3 title 'Instancias deseadas del Pod' with lines dt 2, \
     filename using 4 title 'Instancias medidas de Traefik' with lines lw 2, \
     filename using 5 title 'Instancias deseadas de Traefik' with lines dt 2
exit
