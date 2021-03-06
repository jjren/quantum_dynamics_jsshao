subroutine stdprint(time,averagex)
	! averagex is the position space wave average position
	use module_para
	use module_array
	
	implicit none

	integer :: i
	real(kind=8) :: time
	logical :: alive
	real(kind=8) :: averagex,normx,densityx,x


	inquire(file="fx.out",exist=alive)
	if(alive) then
		open(unit=10,file="fx.out",status="old",POSITION="append")
	else
		open(unit=10,file="fx.out",status="replace")
	end if
	
	write(10,*) 
	write(10,*) 
	averagex=0.0D0
	normx=0.0D0
	do i=1,ngrids,1
	! the wave density of every grid
		densityx=real(fx(i))**2+aimag(fx(i))**2
	! the average position of the wavefunction
		x=DBLE(i-1)*deltax+bleft
		averagex=averagex+densityx*deltax*x
	! the nomalization of the wavefunction
		normx=normx+densityx*deltax

		write(10,'(4E20.7)') x,sqrt(densityx),real(fx(i)),aimag(fx(i))
	end do
	close(10)

	averagex=averagex/normx
	
	inquire(file="momentum.out",exist=alive)
	if(alive) then
		open(unit=11,file="momentum.out",status="old",POSITION="append")
	else
		open(unit=11,file="momentum.out",status="replace")
	end if
	
	write(11,*) 
	write(11,*)
	do i=1,ngrids,1
		write(11,'(I8,3E20.7)') i,sqrt(real(momentum(i))**2+aimag(momentum(i))**2),real(momentum(i)),aimag(momentum(i))
	end do
	close(11)

return

end subroutine
