module nli_0040
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_o_COdif_h1h2up(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_o_COdif_h1h2up

    select case(get_species(cell + (/0, 0, 0, PdO_hollow1/)))
      case default
        nli_o_COdif_h1h2up = 0; return
      case(CO)
        select case(get_species(cell + (/0, 0, 0, PdO_hollow2/)))
          case default
            nli_o_COdif_h1h2up = 0; return
          case(empty)
            nli_o_COdif_h1h2up = o_COdif_h1h2up; return
        end select
    end select

end function nli_o_COdif_h1h2up

end module
