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
    default, &
    default_a, &
    get_species


implicit none



 ! Species constants



integer(kind=iint), parameter, public :: nr_of_species = 3
integer(kind=iint), parameter, public :: A = 0
integer(kind=iint), parameter, public :: B = 1
integer(kind=iint), parameter, public :: empty = 2
integer(kind=iint), public :: default_species = empty


! Process constants

integer(kind=iint), parameter, public :: AB_react_down = 1
integer(kind=iint), parameter, public :: AB_react_left = 2
integer(kind=iint), parameter, public :: AB_react_right = 3
integer(kind=iint), parameter, public :: AB_react_up = 4
integer(kind=iint), parameter, public :: A_adsorption = 5
integer(kind=iint), parameter, public :: A_desorption = 6
integer(kind=iint), parameter, public :: B_adsorption = 7
integer(kind=iint), parameter, public :: B_desorption = 8


end module
