module nli_0008
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_destruct7(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_destruct7

    select case(get_species(cell + (/0, -1, 0, PdO_hollow2/)))
      case default
        nli_destruct7 = 0; return
      case(CO)
        select case(get_species(cell + (/0, -1, 0, PdO_bridge2/)))
          case default
            nli_destruct7 = 0; return
          case(CO)
            select case(get_species(cell + (/0, 0, 0, PdO_hollow1/)))
              case default
                nli_destruct7 = 0; return
              case(empty)
                select case(get_species(cell + (/0, 0, 0, PdO_bridge1/)))
                  case default
                    nli_destruct7 = 0; return
                  case(CO)
                    nli_destruct7 = destruct7; return
                end select
            end select
        end select
    end select

end function nli_destruct7

end module
