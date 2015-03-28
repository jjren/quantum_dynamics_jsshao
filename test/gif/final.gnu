set terminal gif animate delay 5 size 800,600 optimize
set output "fx.gif"
set size 1.0,1.0
set xtics font ",20" 
set ytics font ",20" 
set key font ",15"
set border linewidth 1
#frame1
do for [i=0:5000] {
set multiplot layout 2,1
set size 1.0,0.7
set origin 0.0,0.0
unset xlabel
unset ylabel
set yrange [0:2.5]
set xrange [-3:3]
set label 1 sprintf("t=%f",i*0.02) at 0,2  
plot "fx.out" index i using 1:2 with linespoints linewidth 2 , \
   "potential.out" using 1:2 with lines linewidth 3
set yrange [-1.2:1.2]
set xrange [-0.1:102]
unset label 1
set size 1.0,0.3
set origin 0.0,0.7
set xlabel "time" font ",25"
set ylabel "X_average" font ",25"
plot "averagex.out" every ::0::i using 1:2 with linespoints pointsize 1 linewidth 1 linecolor rgb "blue", \

unset multiplot
}

set output

