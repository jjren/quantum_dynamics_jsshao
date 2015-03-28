set border linewidth 1
set yrange [-1.2:1.2] 
set xrange [-0.01:102.0]
set xlabel "time" font "Times,25"
set ylabel "X_average" font "Times,25"
set key font "Times,15"
set xtics font "Times,20" 
set ytics font "Times,20" 

plot    "average0.001" using 1:2 with linespoints title "1st" linewidth 2 pointsize 0.5,\
       "averagex.out" using 1:2 with linespoints title "2nd" linewidth 2 pointsize 0.5,\

