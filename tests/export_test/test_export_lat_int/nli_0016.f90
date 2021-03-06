module nli_0016
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_oxygen_desorption_bridge_bridge(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_oxygen_desorption_bridge_bridge

    select case(get_species(cell + (/0, 0, 0, ruo2_bridge/)))
      case default
        nli_oxygen_desorption_bridge_bridge = 0; return
      case(oxygen)
        select case(get_species(cell + (/0, 1, 0, ruo2_bridge/)))
          case default
            nli_oxygen_desorption_bridge_bridge = 0; return
          case(oxygen)
            nli_oxygen_desorption_bridge_bridge = oxygen_desorption_bridge_bridge; return
        end select
    end select

end function nli_oxygen_desorption_bridge_bridge

end module
