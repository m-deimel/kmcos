module run_proc_0002
use kind_values
use nli_0000
use nli_0001
use nli_0002
use nli_0003
use proclist_constants
implicit none
contains
subroutine run_proc_CO_diffusion_hollow1_right(cell)

    integer(kind=iint), dimension(4), intent(in) :: cell

    ! disable processes that have to be disabled
    call del_proc(nli_CO_adsorption(cell + (/+0, +0, +0, 0/)), cell + (/+0, +0, +0, 1/))
    call del_proc(nli_CO_diffusion_hollow1_right(cell + (/+0, +0, +0, 0/)), cell + (/+0, +0, +0, 1/))
    call del_proc(nli_CO_diffusion_hollow2_right(cell + (/+0, +0, +0, 0/)), cell + (/+0, +0, +0, 1/))

    ! update lattice
    call replace_species(cell + (/0, 0, 0, simple_cubic_hollow1/), CO, empty)
    call replace_species(cell + (/0, 0, 0, simple_cubic_hollow2/), empty, CO)

    ! enable processes that have to be enabled
    call add_proc(nli_CO_adsorption(cell + (/+0, +0, +0, 0/)), cell + (/+0, +0, +0, 1/))
    call add_proc(nli_CO_diffusion_hollow1_right(cell + (/+0, +0, +0, 0/)), cell + (/+0, +0, +0, 1/))
    call add_proc(nli_CO_diffusion_hollow2_right(cell + (/+0, +0, +0, 0/)), cell + (/+0, +0, +0, 1/))

end subroutine run_proc_CO_diffusion_hollow1_right

end module
