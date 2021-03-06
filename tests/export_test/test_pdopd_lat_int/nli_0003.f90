module nli_0003
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_destruct2(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_destruct2

    select case(get_species(cell + (/0, -1, 0, PdO_hollow2/)))
      case default
        nli_destruct2 = 0; return
      case(empty)
        select case(get_species(cell + (/0, -1, 0, PdO_bridge2/)))
          case default
            nli_destruct2 = 0; return
          case(CO)
            select case(get_species(cell + (/0, 0, 0, PdO_hollow1/)))
              case default
                nli_destruct2 = 0; return
              case(empty)
                select case(get_species(cell + (/0, 0, 0, PdO_bridge1/)))
                  case default
                    nli_destruct2 = 0; return
                  case(empty)
                    nli_destruct2 = destruct2; return
                end select
            end select
        end select
    end select

end function nli_destruct2

end module
