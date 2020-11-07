module nli_0043
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_o_O2des_h1h2(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_o_O2des_h1h2

    select case(get_species(cell + (/0, 0, 0, PdO_hollow1/)))
      case default
        nli_o_O2des_h1h2 = 0; return
      case(oxygen)
        select case(get_species(cell + (/0, 0, 0, PdO_hollow2/)))
          case default
            nli_o_O2des_h1h2 = 0; return
          case(oxygen)
            nli_o_O2des_h1h2 = o_O2des_h1h2; return
        end select
    end select

end function nli_o_O2des_h1h2

end module
