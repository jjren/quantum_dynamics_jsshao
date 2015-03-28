module module_para

	implicit none
	
	! In atomic units
	real(kind=8),parameter :: pi=atan(1.0D0)*4.0D0,hbar=1.0D0  !hbar=1.054571596D-34

	integer,parameter :: ngrids=1000  ! total number of grids
	real(kind=8),parameter :: bleft=-10.0D0,bright=10.0D0    ! the left/right boundary
	real(kind=8),parameter :: deltax=(bright-bleft)/DBLE(ngrids) 
	real(kind=8),parameter :: deltap=2.0D0*pi*hbar/DBLE(ngrids)/deltax

	real(kind=8),parameter :: deltat=5.0D-2 ! the time step
	integer,parameter :: ntimesteps=2000,writestep=2
	character(len=3),parameter :: mode="2nd"  
	! "2nd" means second order split operator TVT
	! "1st" means first order split operator TV

!  the potential 
!  V(x)=(x^2-x0^2)^2
	real(kind=8),parameter :: x0=1.0D0  ! the parameter x0
	real(kind=8),parameter :: m=1.0D0   ! the mass
	complex(kind=8) :: expV(ngrids)     ! the potential V every grid exp(-i*deltat*V/hbar)
	complex(kind=8) :: expT(ngrids)     ! the T=P^2/2*m every grid 
	! exp(-i*deltat*T/hbar/2) in 2nd mode or exp(-i*deltat*T/hbar) in 1st mode
	


end module
