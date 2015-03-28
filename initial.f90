subroutine initial
	use module_array
	use module_para

	implicit none

	integer :: i
	real(kind=8) :: x,y,xp,yp
	
	momentum=(0.0D0,0.0D0)

	open(unit=15,file="potential.out",status="replace")
	do i=1,ngrids,1
		x=deltax*DBLE(i-1)+bleft
		! the initial wavefunction in x space
		call init_func(x,y)
		fx(i)=CMPLX(y,0.0D0)
		! the potential expV at every grid
		call potentialV(x,y)
		! output the potential
		write(15,'(2E20.7)') x,y

		expV(i)=CMPLX(cos(deltat*y/hbar),-sin(deltat*y/hbar))
		! the expT(ngrids) at every grid in p space
		if(i<=ngrids/2) then
			xp=deltap*(i-1)
		else
			xp=deltap*(i-1-ngrids)
		end if
		call kineticT(xp,yp)
		if(mode=='2nd') then
			expT(i)=CMPLX(cos(deltat*yp/hbar/2.0D0),-sin(deltat*yp/hbar/2.0D0))
		else if(mode=='1st') then
			expT(i)=CMPLX(cos(deltat*yp/hbar),-sin(deltat*yp/hbar))
		else 
			write(*,*) "============================"
			write(*,*) "mode is not supported",mode
			write(*,*) "============================"
			stop
		end if
	end do
	close(15)
		
		
end subroutine initial


subroutine init_func(x,y)
	!psai(x,t=0)=exp(-4*(x+x0)^2)
	use module_para
	implicit none
	real(kind=8) :: x,y
	y=exp(-4.0D0*(x+x0)**2)
return
end subroutine

subroutine potentialV(x,y)
	!V(x)=(x^2-x0^2)^2
	use module_para
	implicit none
	real(kind=8) :: x,y
! the project potential
	y=(x*x-x0*x0)**2
! the bench potential
!	if(x<=bleft .or. x>=bright) then
!		y=1.0D30
!	else
!		y=0.0D0
!	end if
return
end subroutine

subroutine kineticT(px,py)
	use module_para
	implicit none
	real(kind=8) :: px,py
	py=px*px/2.0D0/m
return
end subroutine

