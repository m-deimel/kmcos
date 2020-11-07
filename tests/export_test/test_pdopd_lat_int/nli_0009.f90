module nli_0009
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_destruct8(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_destruct8

    select case(get_species(cell + (/0, -1, 0, PdO_hollow2/)))
      case default
        nli_destruct8 = 0; return
      case(empty)
        select case(get_species(cell + (/0, -1, 0, PdO_bridge2/)))
          case default
            nli_destruct8 = 0; return
          case(empty)
            select case(get_species(cell + (/0, 0, 0, PdO_hollow1/)))
              case default
                nli_destruct8 = 0; return
              case(CO)
                select case(get_species(cell + (/0, 0, 0, PdO_bridge1/)))
                  case default
                    nli_destruct8 = 0; return
                  case(empty)
                    nli_destruct8 = destruct8; return
                end select
            end select
        end select
    end select

end function nli_destruct8

end module
