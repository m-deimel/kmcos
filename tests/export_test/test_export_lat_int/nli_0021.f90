module nli_0021
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_oxygen_diffusion_bridge_bridge_up(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_oxygen_diffusion_bridge_bridge_up

    select case(get_species(cell + (/0, 0, 0, ruo2_bridge/)))
      case default
        nli_oxygen_diffusion_bridge_bridge_up = 0; return
      case(oxygen)
        select case(get_species(cell + (/0, 1, 0, ruo2_bridge/)))
          case default
            nli_oxygen_diffusion_bridge_bridge_up = 0; return
          case(empty)
            nli_oxygen_diffusion_bridge_bridge_up = oxygen_diffusion_bridge_bridge_up; return
        end select
    end select

end function nli_oxygen_diffusion_bridge_bridge_up

end module
