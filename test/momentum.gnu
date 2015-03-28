set terminal gif animate delay 5
set output "momentum.gif"
set yrange [0:30]
set xrange [0:1000]
do for [i=0:100] {
set label 1 sprintf("t=%i",i) at 500,15
plot "momentum.out" index i using 1:2 with linespoints linewidth 2 
}
set output
