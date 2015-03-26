subroutine dft(plan,array1,array2)
! this subroutine do discrete fourier transform between fx and momentum
	use,intrinsic :: iso_c_binding

	implicit none
	include 'fftw3.f03'

	type(C_PTR) :: plan
	complex(kind=8) :: array1,array2

	call fftw_execute_dft(plan,array1,array2)
return
end subroutine
