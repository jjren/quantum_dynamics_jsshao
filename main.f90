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
	! FFTW plan: planf x to p ; planb p to x
	integer :: i
	real(kind=8) :: t,averagex
	! t is the simulation time
	! avaragex is the <psai|x|psai>
	character(len=10) :: nowdata,nowtime,nowzone
	integer :: begintime(8),endtime(8)


	call DATE_AND_TIME(nowdata,nowtime,nowzone,begintime)

	if(mod(ngrids,2)/=0) then
		write(*,*) "====================="
		write(*,*) "ngrids should be even",ngrids
		write(*,*) "====================="
		stop
	end if

	planf=fftw_plan_dft_1d(ngrids,fx,momentum,FFTW_FORWARD,FFTW_MEASURE)
	planb=fftw_plan_dft_1d(ngrids,momentum,fx,FFTW_BACKWARD,FFTW_MEASURE)
	
	call initial

	write(*,*) "In Atomic Units"
	write(*,*) "pi=",pi
	write(*,*) "m=",m
	write(*,*) "hbar=",hbar
	write(*,*) "ngrids=",ngrids
	write(*,*) "bleft=",bleft,"bright=",bright
	write(*,*) "deltax=",deltax
	write(*,*) "deltap=",deltap
	write(*,*) "deltat=",deltat
	write(*,*) "ntimesteps=",ntimesteps
	write(*,*) "totaltime=",ntimesteps*deltat

	
	open(unit=16,file="averagex.out",status="replace")
	t=0.0D0
	call dft(planf,fx,momentum)
	call stdprint(t,averagex)
	write(16,'(2E20.7)') t,averagex
	
	do i=1,ntimesteps,1
		! in 2nd split operator mode
		if(mode=='2nd') then
			momentum=momentum*expT
		end if

		call dft(planb,momentum,fx)
		fx=fx/DBLE(ngrids)
		fx=fx*expV

		call dft(planf,fx,momentum)
		momentum=momentum*expT
		
		t=t+deltat

		if(mod(i,writestep)==0) then
			call dft(planb,momentum,fx)
			fx=fx/DBLE(ngrids)
			call stdprint(t,averagex)
			write(16,'(2E20.7)') t,averagex
		end if
	end do
	close(16)

	call DATE_AND_TIME(nowdata,nowtime,nowzone,endtime)
	write(*,*) "walltime=",endtime(6)-begintime(6),"mins",endtime(7)-begintime(7),"secs"

end program

