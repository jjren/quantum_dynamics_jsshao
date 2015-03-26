program main
! this is a quantum dynamic code using split operator method
! H=px^2/2*m+V(x) V(x)=(x^2-x0^2)^2 
! psai(x,t=0)=exp(-4*(x+x0)^2)
	use module_para
	use module_array
	use,intrinsic :: iso_c_binding

	implicit none
	include 'fftw3.f03'

	type(C_PTR) :: planf,planb
	! planf x to p ; planb p to x
	integer :: i
	real(kind=8) :: t
	
	if(mod(ngrids,2)/=0) then
		write(*,*) "====================="
		write(*,*) "ngrids should be even",ngrids
		write(*,*) "====================="
		stop
	end if

	planf=fftw_plan_dft_1d(ngrids,fx,momentum,FFTW_FORWARD,FFTW_MEASURE)
	planb=fftw_plan_dft_1d(ngrids,momentum,fx,FFTW_BACKWARD,FFTW_MEASURE)
	
	call initial

	write(*,*) "pi=",pi
	write(*,*) "hbar=",hbar
	write(*,*) "ngrids=",ngrids
	write(*,*) "bleft=",bleft,"bright=",bright
	write(*,*) "deltax=",deltax
	write(*,*) "deltap=",deltap
	write(*,*) "deltat=",deltat
	write(*,*) "ntimesteps=",ntimesteps
	write(*,*) "totaltime=",ntimesteps*deltat


	
	t=0.0D0
	call dft(planf,fx,momentum)
	call stdprint(t)

	do i=1,ntimesteps,1
		momentum=momentum*expT
		call dft(planb,momentum,fx)
		fx=fx/DBLE(ngrids)
		fx=fx*expV
		call dft(planf,fx,momentum)
		momentum=momentum*expT
		t=t+deltat
		if(mod(i,1)==0) then
			call dft(planb,momentum,fx)
			fx=fx/DBLE(ngrids)
			call stdprint(t)
		end if
	end do

end program
