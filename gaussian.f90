program gaussian
! this program is to transfer gaussian function in coordinate space to
! momentum space
! the gaussian function is f(x)=aexp(-(x-b)^2/2*c^2)
	use,intrinsic :: iso_c_binding
	include 'fftw3.f03'
	
	implicit none

	type(C_PTR) :: plan

	real(kind=8),parameter :: a=1.0D0,b=1.0D0,c=1.0D0
	integer,parameter :: ngrids
	real(kind=8),parameter :: bleft=-10.0D0,bright=10.0D0
	! boundary left/right 
	complex(C_DOUBLE_COMPLEX) :: fx(ngrids),momentum(ngrids)
	! fx in coordinate space; p in momentum space
	real(kind=8) :: deltax,x,y
	integer :: i

	deltax=(bright-bleft)/DBLE(ngrids)

	do i=1,ngrids,1
		x=deltax*(ngrids-1)+bleft
		call fgaussian(a,b,c,x,y)
		fx(ngrids)=CMPLX(y,0.0D0)
	end do

	plan=fftw_plan_dft_1d(ngrids,fx,momentum,FFTW_FORWARD,FFTW_ESTIMATE)
	call fftw_execute_dft(plan,fx,momentum)
	call fftw_destory_plan(plan)
	
	do i=1,ngrids,1
		write(*,*) momentum(i)
	end do



end program

subroutine fgaussian(a,b,c,x,y)
! this subroutine is to calculate the f(x)
	implicit none
	real(kind=8) :: a,b,c,x,y
	
	y=a*exp(-(x-b)**2/2.0D0/c**2)
return
end subroutine









