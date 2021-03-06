The kmcos data model
===================

The guide explains how kmcos handles represent
a kmc model internally, which is important to know
if one wants to write new functionality.

The different functions and front-ends of
kmcos all interact in some way or another
with instances of the Project class. A
Project instance is a representation of
a kmc model. If you fire up 'kmcos edit' (deprecated) with
an xml file, kmcos validates the XML file and
stores the content in a Project instance.
If you export source code, kmcos runs over the
Project and creates the necessary Fortran 90
source code.


So the following things are in a Project:

- meta
- lattice(layers)
- species
- parameters
- processes

The language used here stems from modelling atomic
movement on a fixed or evolving lattice like
structure. In a more general
context one may rephrase them as :

- meta -> information about project
- lattice -> geometry
- species -> states
- parameters
- processes -> transitions
