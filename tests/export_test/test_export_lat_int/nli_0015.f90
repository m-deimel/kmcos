module nli_0015
use kind_values
use lattice
use proclist_constants
implicit none
contains
pure function nli_oxygen_adsorption_cus_cus(cell)
    integer(kind=iint), dimension(4), intent(in) :: cell
    integer(kind=iint) :: nli_oxygen_adsorption_cus_cus

    select case(get_species(cell + (/0, 0, 0, ruo2_cus/)))
      case default
        nli_oxygen_adsorption_cus_cus = 0; return
      case(empty)
        select case(get_species(cell + (/0, 1, 0, ruo2_cus/)))
          case default
            nli_oxygen_adsorption_cus_cus = 0; return
          case(empty)
            nli_oxygen_adsorption_cus_cus = oxygen_adsorption_cus_cus; return
        end select
    end select

end function nli_oxygen_adsorption_cus_cus

end module
