module nli_0023
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_oxygen_diffusion_bridge_cus_right(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_oxygen_diffusion_bridge_cus_right

    select case(get_species(cell + (/0, 0, 0, ruo2_bridge/)))
      case default
        nli_oxygen_diffusion_bridge_cus_right = 0; return
      case(oxygen)
        select case(get_species(cell + (/0, 0, 0, ruo2_cus/)))
          case default
            nli_oxygen_diffusion_bridge_cus_right = 0; return
          case(empty)
            nli_oxygen_diffusion_bridge_cus_right = oxygen_diffusion_bridge_cus_right; return
        end select
    end select

end function nli_oxygen_diffusion_bridge_cus_right

end module
