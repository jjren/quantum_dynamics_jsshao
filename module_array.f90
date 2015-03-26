module module_array
	use module_para

	implicit none
	! coordinate space and momentum space
	complex(kind=8) :: fx(ngrids),momentum(ngrids)
end module
