module nli_0010
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_b_2_a_2(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_b_2_a_2

    select case(get_species(cell + (/0, 0, 0, default_b_2/)))
      case default
        nli_b_2_a_2 = 0; return
      case(ion)
        select case(get_species(cell + (/0, 0, 0, default_a_2/)))
          case default
            nli_b_2_a_2 = 0; return
          case(empty)
            nli_b_2_a_2 = b_2_a_2; return
        end select
    end select

end function nli_b_2_a_2

end module
