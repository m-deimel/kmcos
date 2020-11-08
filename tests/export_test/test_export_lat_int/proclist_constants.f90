!  This file was generated by kmcos (kMC modelling on steroids)
!  written by Max J. Hoffmann mjhoffmann@gmail.com (C) 2009-2013.
!  The model was written by Max J. Hoffmann.

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


module proclist_constants
use kind_values
use lattice, only: &
    ruo2, &
    ruo2_bridge, &
    ruo2_cus, &
    get_species


implicit none



 ! Species constants



integer(kind=iint), parameter, public :: nr_of_species = 3
integer(kind=iint), parameter, public :: co = 0
integer(kind=iint), parameter, public :: empty = 1
integer(kind=iint), parameter, public :: oxygen = 2
integer(kind=iint), public :: default_species = empty


! Process constants

integer(kind=iint), parameter, public :: co_adsorption_bridge = 1
integer(kind=iint), parameter, public :: co_adsorption_cus = 2
integer(kind=iint), parameter, public :: co_desorption_bridge = 3
integer(kind=iint), parameter, public :: co_desorption_cus = 4
integer(kind=iint), parameter, public :: co_diffusion_bridge_bridge_down = 5
integer(kind=iint), parameter, public :: co_diffusion_bridge_bridge_up = 6
integer(kind=iint), parameter, public :: co_diffusion_bridge_cus_left = 7
integer(kind=iint), parameter, public :: co_diffusion_bridge_cus_right = 8
integer(kind=iint), parameter, public :: co_diffusion_cus_bridge_left = 9
integer(kind=iint), parameter, public :: co_diffusion_cus_bridge_right = 10
integer(kind=iint), parameter, public :: co_diffusion_cus_cus_down = 11
integer(kind=iint), parameter, public :: co_diffusion_cus_cus_up = 12
integer(kind=iint), parameter, public :: oxygen_adsorption_bridge_bridge = 13
integer(kind=iint), parameter, public :: oxygen_adsorption_bridge_cus_left = 14
integer(kind=iint), parameter, public :: oxygen_adsorption_bridge_cus_right = 15
integer(kind=iint), parameter, public :: oxygen_adsorption_cus_cus = 16
integer(kind=iint), parameter, public :: oxygen_desorption_bridge_bridge = 17
integer(kind=iint), parameter, public :: oxygen_desorption_bridge_cus_left = 18
integer(kind=iint), parameter, public :: oxygen_desorption_bridge_cus_right = 19
integer(kind=iint), parameter, public :: oxygen_desorption_cus_cus = 20
integer(kind=iint), parameter, public :: oxygen_diffusion_bridge_bridge_down = 21
integer(kind=iint), parameter, public :: oxygen_diffusion_bridge_bridge_up = 22
integer(kind=iint), parameter, public :: oxygen_diffusion_bridge_cus_left = 23
integer(kind=iint), parameter, public :: oxygen_diffusion_bridge_cus_right = 24
integer(kind=iint), parameter, public :: oxygen_diffusion_cus_bridge_left = 25
integer(kind=iint), parameter, public :: oxygen_diffusion_cus_bridge_right = 26
integer(kind=iint), parameter, public :: oxygen_diffusion_cus_cus_down = 27
integer(kind=iint), parameter, public :: oxygen_diffusion_cus_cus_up = 28
integer(kind=iint), parameter, public :: reaction_oxygen_bridge_co_bridge_down = 29
integer(kind=iint), parameter, public :: reaction_oxygen_bridge_co_bridge_up = 30
integer(kind=iint), parameter, public :: reaction_oxygen_bridge_co_cus_left = 31
integer(kind=iint), parameter, public :: reaction_oxygen_bridge_co_cus_right = 32
integer(kind=iint), parameter, public :: reaction_oxygen_cus_co_bridge_left = 33
integer(kind=iint), parameter, public :: reaction_oxygen_cus_co_bridge_right = 34
integer(kind=iint), parameter, public :: reaction_oxygen_cus_co_cus_down = 35
integer(kind=iint), parameter, public :: reaction_oxygen_cus_co_cus_up = 36


end module
