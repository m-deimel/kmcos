module nli_0007
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_B_desorption(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_B_desorption

    select case(get_species(cell + (/0, 0, 0, default_a/)))
      case default
        nli_B_desorption = 0; return
      case(B)
        nli_B_desorption = B_desorption; return
    end select

end function nli_B_desorption

end module
