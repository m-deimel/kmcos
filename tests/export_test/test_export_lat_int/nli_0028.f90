module nli_0028
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_reaction_oxygen_bridge_co_bridge_down(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_reaction_oxygen_bridge_co_bridge_down

    select case(get_species(cell + (/0, -1, 0, ruo2_bridge/)))
      case default
        nli_reaction_oxygen_bridge_co_bridge_down = 0; return
      case(co)
        select case(get_species(cell + (/0, 0, 0, ruo2_bridge/)))
          case default
            nli_reaction_oxygen_bridge_co_bridge_down = 0; return
          case(oxygen)
            nli_reaction_oxygen_bridge_co_bridge_down = reaction_oxygen_bridge_co_bridge_down; return
        end select
    end select

end function nli_reaction_oxygen_bridge_co_bridge_down

end module
