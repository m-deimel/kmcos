module nli_0010
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_co_diffusion_cus_cus_down(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_co_diffusion_cus_cus_down

    select case(get_species(cell + (/0, -1, 0, ruo2_cus/)))
      case default
        nli_co_diffusion_cus_cus_down = 0; return
      case(empty)
        select case(get_species(cell + (/0, 0, 0, ruo2_cus/)))
          case default
            nli_co_diffusion_cus_cus_down = 0; return
          case(co)
            nli_co_diffusion_cus_cus_down = co_diffusion_cus_cus_down; return
        end select
    end select

end function nli_co_diffusion_cus_cus_down

end module
