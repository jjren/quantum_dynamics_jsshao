program gaussian
! this program is to transfer gaussian function in coordinate space to
! momentum space
! the gaussian function is f(x)=aexp(-(x-b)^2/2*c^2)
	use,intrinsic :: iso_c_binding
	use blas95
	use f95_precision
	
	implicit none
	include 'fftw3.f03'
	

	type(C_PTR) :: plan

	real(kind=8),parameter :: a=1.0D0,b=0.0D0,c=1.0D0
	real(kind=8),parameter :: pi=atan(1.0D0)*4.0D0,hbar=1.05457D-34
	integer,parameter :: ngrids=1000
	real(kind=8),parameter :: bleft=-20.0D0,bright=20.0D0
	! boundary left/right 
	complex(C_DOUBLE_COMPLEX) :: fx(ngrids),momentum(ngrids),fx1(ngrids)
	! fx in coordinate space; p in momentum space
	real(kind=8) :: deltax,x,y,deltap,integral
	complex(kind=8) :: norm
	integer :: i

	deltax=(bright-bleft)/DBLE(ngrids)
	deltap=2.0D0*pi*hbar/DBLE(ngrids)/deltax
	write(*,*) "deltax=",deltax
	write(*,*) "deltap=",deltap,pi


	do i=1,ngrids,1
		x=deltax*DBLE(i-1)+bleft
		call fgaussian(a,b,c,x,y)
		fx(i)=CMPLX(y,0.0D0)
	end do
	!fx=fx/sqrt(sqrt(pi))
	norm=dotc(fx,fx)
	norm=norm*deltax
	write(*,*) "norm=",norm

	call swap(fx(1:ngrids/2),fx(ngrids/2+1:ngrids))
	

	open(unit=11,file="fx.out",status="replace")
	do i=1,ngrids,1
		write(11,*) i,real(fx(i)),aimag(fx(i))
	end do
	close(11)
	plan=fftw_plan_dft_1d(ngrids,fx,momentum,FFTW_FORWARD,FFTW_ESTIMATE)
	call fftw_execute_dft(plan,fx,momentum)
	call fftw_destroy_plan(plan)
	

	norm=dotc(momentum,momentum)
	write(*,*) "norm=",norm
	norm=norm*deltap
	integral=0.0D0
	do i=1,ngrids,1
		integral=integral+(real(momentum(i)))**2
	end do
	write(*,*) "integral=",integral
	write(*,*) sqrt(real(norm))
!	momentum=momentum/sqrt(integral*deltap)

	call swap(momentum(1:ngrids/2),momentum(ngrids/2+1:ngrids))

	plan=fftw_plan_dft_1d(ngrids,momentum,fx1,FFTW_BACKWARD,FFTW_ESTIMATE)
	call fftw_execute_dft(plan,momentum,fx1)
	call fftw_destroy_plan(plan)
	open(unit=13,file="fx1.out",status="replace")
	do i=1,ngrids,1
		write(13,*) i,real(fx1(i)),aimag(fx1(i))
	end do
	close(13)

	open(unit=12,file="momentum.out",status="replace")
	do i=1,ngrids,1
		write(12,*) deltap*(i-1),real(momentum(i)),aimag(momentum(i))
	!	write(12,*) momentum(i)
	end do
	close(12)





end program

subroutine fgaussian(a,b,c,x,y)
! this subroutine is to calculate the f(x)
	implicit none
	real(kind=8) :: a,b,c,x,y
	
	y=a*exp(-(x-b)**2/2.0D0/c**2)
return
end subroutine









