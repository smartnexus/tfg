if (!exists("filename")) filename='out.dat'
if (!exists("plotname")) plotname='{plotname}'

# This sets the aspect ratio of the graph
set size 1, 1
# The graph title
set title sprintf("{/:Bold %s}\nDispersión de tiempos por petición", plotname)
# Where to place the legend/key
set key off
# Draw gridlines oriented on the y axis
set grid y
set grid x
# Label the x-axis
set xlabel 'Duración del experimento (s)'
# Label the y-axis
set ylabel "Tiempo de respuesta (ms)"
# Tell gnuplot to use tabs as the delimiter instead of spaces (default)
set datafile separator '\t'
offset=system(sprintf("sort -n -k 2 %s | awk 'FNR == 1 {print $6}'", filename))
# Plot the data
plot filename every ::2 using ($2-offset):5 title 'tiempo de respuesta por petición' with points pt 4 ps 0.5 
exit
