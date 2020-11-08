!  This file was generated by kmcos (kMC modelling on steroids)
!  written by Max J. Hoffmann mjhoffmann@gmail.com (C) 2009-2013.
!  The model was written by Thomas Danielson.

!  This file is part of kmcos.
!
!  kmcos is free software; you can redistribute it and/or modify
!  it under the terms of the GNU General Public License as published by
!  the Free Software Foundation; either version 2 of the License, or
!  (at your option) any later version.
!
!  kmcos is distributed in the hope that it will be useful,
!  but WITHOUT ANY WARRANTY; without even the implied warranty of
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!  GNU General Public License for more details.
!
!  You should have received a copy of the GNU General Public License
!  along with kmcos; if not, write to the Free Software
!  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
!  USA
!****h* kmcos/proclist
! FUNCTION
!    Implements the kMC process list.
!
!******


module proclist
use kind_values
use base, only: &
    update_accum_rate, &
    update_integ_rate, &
    determine_procsite, &
    update_clocks, &
    avail_sites, &
    null_species, &
    increment_procstat

use lattice, only: &
    Site, &
    Site_coord, &
    allocate_system, &
    nr2lattice, &
    lattice2nr, &
    add_proc, &
    can_do, &
    set_rate_const, &
    replace_species, &
    del_proc, &
    reset_site, &
    system_size, &
    spuck, &
    get_species


implicit none



 ! Species constants



integer(kind=iint), parameter, public :: nr_of_species = 8
integer(kind=iint), parameter, public :: A1 = 0
integer(kind=iint), parameter, public :: B1 = 1
integer(kind=iint), parameter, public :: B2 = 2
integer(kind=iint), parameter, public :: C1 = 3
integer(kind=iint), parameter, public :: C2 = 4
integer(kind=iint), parameter, public :: D1 = 5
integer(kind=iint), parameter, public :: D2 = 6
integer(kind=iint), parameter, public :: E1 = 7
integer(kind=iint), public :: default_species = A1


! Process constants

integer(kind=iint), parameter, public :: pF1p0 = 1
integer(kind=iint), parameter, public :: pF2p0 = 2
integer(kind=iint), parameter, public :: pF3p0 = 3
integer(kind=iint), parameter, public :: pF4p0 = 4
integer(kind=iint), parameter, public :: pF5p0 = 5
integer(kind=iint), parameter, public :: pF6p0 = 6
integer(kind=iint), parameter, public :: pF7p0 = 7
integer(kind=iint), parameter, public :: pR1p0 = 8
integer(kind=iint), parameter, public :: pR2p0 = 9
integer(kind=iint), parameter, public :: pR3p0 = 10
integer(kind=iint), parameter, public :: pR4p0 = 11
integer(kind=iint), parameter, public :: pR5p0 = 12
integer(kind=iint), parameter, public :: pR6p0 = 13
integer(kind=iint), parameter, public :: pR7p0 = 14


integer(kind=iint), parameter, public :: representation_length = 0
integer(kind=iint), public :: seed_size = 33
integer(kind=iint), public :: seed ! random seed
integer(kind=iint), public, dimension(:), allocatable :: seed_arr ! random seed


integer(kind=iint), parameter, public :: nr_of_proc = 14


contains

subroutine do_kmc_steps(n)

!****f* proclist/do_kmc_steps
! FUNCTION
!    Performs ``n`` kMC step.
!    If one has to run many steps without evaluation
!    do_kmc_steps might perform a little better.
!    * first update clock
!    * then configuration sampling step
!    * last execute process
!
! ARGUMENTS
!
!    ``n`` : Number of steps to run
!******
    integer(kind=ilong), intent(in) :: n

    integer(kind=ilong) :: i
    real(kind=rsingle) :: ran_proc, ran_time, ran_site
    integer(kind=iint) :: nr_site, proc_nr

    do i = 1, n
    call random_number(ran_time)
    call random_number(ran_proc)
    call random_number(ran_site)
    call update_accum_rate
    call update_clocks(ran_time)

    call update_integ_rate
    call determine_procsite(ran_proc, ran_site, proc_nr, nr_site)
    call run_proc_nr(proc_nr, nr_site)
    enddo

end subroutine do_kmc_steps

subroutine do_kmc_step()

!****f* proclist/do_kmc_step
! FUNCTION
!    Performs exactly one kMC step.
!    *  first update clock
!    *  then configuration sampling step
!    *  last execute process
!
! ARGUMENTS
!
!    ``none``
!******
    real(kind=rsingle) :: ran_proc, ran_time, ran_site
    integer(kind=iint) :: nr_site, proc_nr

    call random_number(ran_time)
    call random_number(ran_proc)
    call random_number(ran_site)
    call update_accum_rate
    call update_clocks(ran_time)

    call update_integ_rate
    call determine_procsite(ran_proc, ran_site, proc_nr, nr_site)
    call run_proc_nr(proc_nr, nr_site)
end subroutine do_kmc_step

subroutine get_next_kmc_step(proc_nr, nr_site)

!****f* proclist/get_kmc_step
! FUNCTION
!    Determines next step without executing it.
!
! ARGUMENTS
!
!    ``none``
!******
    real(kind=rsingle) :: ran_proc, ran_time, ran_site
    integer(kind=iint), intent(out) :: nr_site, proc_nr

    call random_number(ran_time)
    call random_number(ran_proc)
    call random_number(ran_site)
    call update_accum_rate
    call determine_procsite(ran_proc, ran_time, proc_nr, nr_site)

end subroutine get_next_kmc_step

subroutine get_occupation(occupation)

!****f* proclist/get_occupation
! FUNCTION
!    Evaluate current lattice configuration and returns
!    the normalized occupation as matrix. Different species
!    run along the first axis and different sites run
!    along the second.
!
! ARGUMENTS
!
!    ``none``
!******
    ! nr_of_species = 8, spuck = 1
    real(kind=rdouble), dimension(0:7, 1:1), intent(out) :: occupation

    integer(kind=iint) :: i, j, k, nr, species

    occupation = 0

    do k = 0, system_size(3)-1
        do j = 0, system_size(2)-1
            do i = 0, system_size(1)-1
                do nr = 1, spuck
                    ! shift position by 1, so it can be accessed
                    ! more straightforwardly from f2py interface
                    species = get_species((/i,j,k,nr/))
                    if(species.ne.null_species) then
                    occupation(species, nr) = &
                        occupation(species, nr) + 1
                    endif
                end do
            end do
        end do
    end do

    occupation = occupation/real(system_size(1)*system_size(2)*system_size(3))
end subroutine get_occupation

subroutine init(input_system_size, system_name, layer, seed_in, no_banner)

!****f* proclist/init
! FUNCTION
!     Allocates the system and initializes all sites in the given
!     layer.
!
! ARGUMENTS
!
!    * ``input_system_size`` number of unit cell per axis.
!    * ``system_name`` identifier for reload file.
!    * ``layer`` initial layer.
!    * ``no_banner`` [optional] if True no copyright is issued.
!******
    integer(kind=iint), intent(in) :: layer, seed_in
    integer(kind=iint), dimension(2), intent(in) :: input_system_size

    character(len=400), intent(in) :: system_name

    logical, optional, intent(in) :: no_banner

    if (.not. no_banner) then
        print *, "+------------------------------------------------------------+"
        print *, "|                                                            |"
        print *, "| This kMC Model 'throttling_test_reaction' was written by   |"
        print *, "|                                                            |"
        print *, "|             Thomas Danielson (thomasd1@vt.edu)             |"
        print *, "|                                                            |"
        print *, "| and implemented with the help of kmcos,                     |"
        print *, "| which is distributed under GNU/GPL Version 3               |"
        print *, "| (C) Max J. Hoffmann mjhoffmann@gmail.com                   |"
        print *, "|                                                            |"
        print *, "| kmcos is distributed in the hope that it will be useful     |"
        print *, "| but WIHTOUT ANY WARRANTY; without even the implied         |"
        print *, "| waranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR     |"
        print *, "| PURPOSE. See the GNU General Public License for more       |"
        print *, "| details.                                                   |"
        print *, "|                                                            |"
        print *, "| If using kmcos for a publication, attribution is            |"
        print *, "| greatly appreciated.                                       |"
        print *, "| Hoffmann, M. J., Matera, S., & Reuter, K. (2014).          |"
        print *, "| kmcos: A lattice kinetic Monte Carlo framework.             |"
        print *, "| Computer Physics Communications, 185(7), 2138-2150.        |"
        print *, "|                                                            |"
        print *, "| Development http://mhoffman.github.org/kmcos                |"
        print *, "| Documentation http://kmcos.readthedocs.org                  |"
        print *, "| Reference http://dx.doi.org/10.1016/j.cpc.2014.04.003      |"
        print *, "|                                                            |"
        print *, "+------------------------------------------------------------+"
        print *, ""
        print *, ""
    endif
    call allocate_system(nr_of_proc, input_system_size, system_name)
    call initialize_state(layer, seed_in)
end subroutine init

subroutine initialize_state(layer, seed_in)

!****f* proclist/initialize_state
! FUNCTION
!    Initialize all sites and book-keeping array
!    for the given layer.
!
! ARGUMENTS
!
!    * ``layer`` integer representing layer
!******
    integer(kind=iint), intent(in) :: layer, seed_in

    integer(kind=iint) :: i, j, k, nr
    ! initialize random number generator
    allocate(seed_arr(seed_size))
    seed = seed_in
    seed_arr = seed
    call random_seed(size=seed_size)
    call random_seed(put=seed_arr)
    deallocate(seed_arr)
    do k = 0, system_size(3)-1
        do j = 0, system_size(2)-1
            do i = 0, system_size(1)-1
                do nr = 1, spuck
                    call reset_site((/i, j, k, nr/), null_species)
                end do
                select case(layer)
                case (Site)
                    call replace_species((/i, j, k, Site_coord/), null_species, A1)
                end select
            end do
        end do
    end do

    do k = 0, system_size(3)-1
        do j = 0, system_size(2)-1
            do i = 0, system_size(1)-1
                select case(layer)
                case(Site)
                    call touchup_Site_coord((/i, j, k, Site_coord/))
                end select
            end do
        end do
    end do


end subroutine initialize_state

subroutine run_proc_nr(proc, nr_site)

!****f* proclist/run_proc_nr
! FUNCTION
!    Runs process ``proc`` on site ``nr_site``.
!
! ARGUMENTS
!
!    * ``proc`` integer representing the process number
!    * ``nr_site``  integer representing the site
!******
    integer(kind=iint), intent(in) :: proc
    integer(kind=iint), intent(in) :: nr_site

    integer(kind=iint), dimension(4) :: lsite

    call increment_procstat(proc)

    ! lsite = lattice_site, (vs. scalar site)
    lsite = nr2lattice(nr_site, :)

    select case(proc)
    case(pF1p0)
        call put_B1_Site_coord(lsite)

    case(pF2p0)
        call take_B1_Site_coord(lsite)
        call put_C1_Site_coord(lsite)

    case(pF3p0)
        call take_C1_Site_coord(lsite)
        call put_D1_Site_coord(lsite)

    case(pF4p0)
        call take_D1_Site_coord(lsite)
        call put_E1_Site_coord(lsite)

    case(pF5p0)
        call take_B1_Site_coord(lsite)
        call put_B2_Site_coord(lsite)

    case(pF6p0)
        call take_C1_Site_coord(lsite)
        call put_C2_Site_coord(lsite)

    case(pF7p0)
        call take_D1_Site_coord(lsite)
        call put_D2_Site_coord(lsite)

    case(pR1p0)
        call take_B1_Site_coord(lsite)

    case(pR2p0)
        call take_C1_Site_coord(lsite)
        call put_B1_Site_coord(lsite)

    case(pR3p0)
        call take_D1_Site_coord(lsite)
        call put_C1_Site_coord(lsite)

    case(pR4p0)
        call take_E1_Site_coord(lsite)
        call put_D1_Site_coord(lsite)

    case(pR5p0)
        call take_B2_Site_coord(lsite)
        call put_B1_Site_coord(lsite)

    case(pR6p0)
        call take_C2_Site_coord(lsite)
        call put_C1_Site_coord(lsite)

    case(pR7p0)
        call take_D2_Site_coord(lsite)
        call put_D1_Site_coord(lsite)

    end select

end subroutine run_proc_nr

subroutine put_B1_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, A1, B1)

    ! disable affected processes
    if(avail_sites(pF1p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF1p0, site)
    endif

    ! enable affected processes
    call add_proc(pF2p0, site)
    call add_proc(pF5p0, site)
    call add_proc(pR1p0, site)

end subroutine put_B1_Site_coord

subroutine take_B1_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, B1, A1)

    ! disable affected processes
    if(avail_sites(pF2p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF2p0, site)
    endif

    if(avail_sites(pF5p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF5p0, site)
    endif

    if(avail_sites(pR1p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pR1p0, site)
    endif

    ! enable affected processes
    call add_proc(pF1p0, site)

end subroutine take_B1_Site_coord

subroutine put_B2_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, A1, B2)

    ! disable affected processes
    if(avail_sites(pF1p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF1p0, site)
    endif

    ! enable affected processes
    call add_proc(pR5p0, site)

end subroutine put_B2_Site_coord

subroutine take_B2_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, B2, A1)

    ! disable affected processes
    if(avail_sites(pR5p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pR5p0, site)
    endif

    ! enable affected processes
    call add_proc(pF1p0, site)

end subroutine take_B2_Site_coord

subroutine put_C1_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, A1, C1)

    ! disable affected processes
    if(avail_sites(pF1p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF1p0, site)
    endif

    ! enable affected processes
    call add_proc(pF3p0, site)
    call add_proc(pF6p0, site)
    call add_proc(pR2p0, site)

end subroutine put_C1_Site_coord

subroutine take_C1_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, C1, A1)

    ! disable affected processes
    if(avail_sites(pF3p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF3p0, site)
    endif

    if(avail_sites(pF6p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF6p0, site)
    endif

    if(avail_sites(pR2p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pR2p0, site)
    endif

    ! enable affected processes
    call add_proc(pF1p0, site)

end subroutine take_C1_Site_coord

subroutine put_C2_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, A1, C2)

    ! disable affected processes
    if(avail_sites(pF1p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF1p0, site)
    endif

    ! enable affected processes
    call add_proc(pR6p0, site)

end subroutine put_C2_Site_coord

subroutine take_C2_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, C2, A1)

    ! disable affected processes
    if(avail_sites(pR6p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pR6p0, site)
    endif

    ! enable affected processes
    call add_proc(pF1p0, site)

end subroutine take_C2_Site_coord

subroutine put_D1_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, A1, D1)

    ! disable affected processes
    if(avail_sites(pF1p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF1p0, site)
    endif

    ! enable affected processes
    call add_proc(pF4p0, site)
    call add_proc(pF7p0, site)
    call add_proc(pR3p0, site)

end subroutine put_D1_Site_coord

subroutine take_D1_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, D1, A1)

    ! disable affected processes
    if(avail_sites(pF4p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF4p0, site)
    endif

    if(avail_sites(pF7p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF7p0, site)
    endif

    if(avail_sites(pR3p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pR3p0, site)
    endif

    ! enable affected processes
    call add_proc(pF1p0, site)

end subroutine take_D1_Site_coord

subroutine put_D2_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, A1, D2)

    ! disable affected processes
    if(avail_sites(pF1p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF1p0, site)
    endif

    ! enable affected processes
    call add_proc(pR7p0, site)

end subroutine put_D2_Site_coord

subroutine take_D2_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, D2, A1)

    ! disable affected processes
    if(avail_sites(pR7p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pR7p0, site)
    endif

    ! enable affected processes
    call add_proc(pF1p0, site)

end subroutine take_D2_Site_coord

subroutine put_E1_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, A1, E1)

    ! disable affected processes
    if(avail_sites(pF1p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pF1p0, site)
    endif

    ! enable affected processes
    call add_proc(pR4p0, site)

end subroutine put_E1_Site_coord

subroutine take_E1_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    ! update lattice
    call replace_species(site, E1, A1)

    ! disable affected processes
    if(avail_sites(pR4p0, lattice2nr(site(1), site(2), site(3), site(4)), 2).ne.0)then
        call del_proc(pR4p0, site)
    endif

    ! enable affected processes
    call add_proc(pF1p0, site)

end subroutine take_E1_Site_coord

subroutine touchup_Site_coord(site)

    integer(kind=iint), dimension(4), intent(in) :: site

    if (can_do(pF1p0, site)) then
        call del_proc(pF1p0, site)
    endif
    if (can_do(pF2p0, site)) then
        call del_proc(pF2p0, site)
    endif
    if (can_do(pF3p0, site)) then
        call del_proc(pF3p0, site)
    endif
    if (can_do(pF4p0, site)) then
        call del_proc(pF4p0, site)
    endif
    if (can_do(pF5p0, site)) then
        call del_proc(pF5p0, site)
    endif
    if (can_do(pF6p0, site)) then
        call del_proc(pF6p0, site)
    endif
    if (can_do(pF7p0, site)) then
        call del_proc(pF7p0, site)
    endif
    if (can_do(pR1p0, site)) then
        call del_proc(pR1p0, site)
    endif
    if (can_do(pR2p0, site)) then
        call del_proc(pR2p0, site)
    endif
    if (can_do(pR3p0, site)) then
        call del_proc(pR3p0, site)
    endif
    if (can_do(pR4p0, site)) then
        call del_proc(pR4p0, site)
    endif
    if (can_do(pR5p0, site)) then
        call del_proc(pR5p0, site)
    endif
    if (can_do(pR6p0, site)) then
        call del_proc(pR6p0, site)
    endif
    if (can_do(pR7p0, site)) then
        call del_proc(pR7p0, site)
    endif
    select case(get_species(site))
    case(C1)
        call add_proc(pF3p0, site)
        call add_proc(pF6p0, site)
        call add_proc(pR2p0, site)
    case(A1)
        call add_proc(pF1p0, site)
    case(D2)
        call add_proc(pR7p0, site)
    case(D1)
        call add_proc(pF4p0, site)
        call add_proc(pF7p0, site)
        call add_proc(pR3p0, site)
    case(E1)
        call add_proc(pR4p0, site)
    case(B1)
        call add_proc(pF2p0, site)
        call add_proc(pF5p0, site)
        call add_proc(pR1p0, site)
    case(C2)
        call add_proc(pR6p0, site)
    case(B2)
        call add_proc(pR5p0, site)
    end select

end subroutine touchup_Site_coord

end module proclist
