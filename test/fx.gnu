set terminal gif animate delay 5 optimize
set output "fx.gif"
#set multiplot layout 2,1
do for [i=0:1000] {
#frame1
set yrange [0:1.0]
set xrange [-21.0:21.0]
set label 1 sprintf("t=%f",i*0.02) at 0,2  
plot "fx.out" index i using 1:2 with linespoints pointsize 0.1 linewidth 1 , \
#   "potential.out" using 1:2 with lines linewidth 3
}
set output
