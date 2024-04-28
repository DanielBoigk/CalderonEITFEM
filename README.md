# CalderonEITFEM

Creates Training Data for Calderon/EIT Problem using FEM-solver.

1. Contains Methods for generating conductivity, and boundary conditions:
   Based on white noise with gaussian filtering. 
   Alternatively uses Gaussian Random fields. 

2. Creates Rectangular/Square or circular Mesh with varying granularity.

3. Calculates FEM Solution of both Dirichlet-to-Neumann and Neumann-to-Dirichlet Map

4. Generates Full data set of Conductivity, Voltage, Neumann boundary (Current), dirichlet boundary(voltage). If specified will also calculate full gradient flow. 

Data created is meant as training Data for Solving the inverse problem of electrical impedance tomography.

Excludes Solution using Ferrite since Gridap and Ferrite do not run in the same environment.

## The EIT - Forward Problem

### Neumann-to-Dirichlet Map
Given the strong formulation:
$$\nabla\cdot(\gamma(x) * \nabla u(x)) = 0 \;\; \forall x in\Omega$$
with neumann boundary condiction
### Dirichlet-to-Neumann Map


## Example for a square domain:
Generates random Conductivity values of a medium: 
![Conductivity of a medium](images/conductivity.svg)

and given dirichlet boundary condition:

![Dirichlet Boundary](images/dirichlet.svg)

calculates the Voltage U over the medium:

![Voltage](images/Voltage.svg) 

with the option to also calculate the neumann boundary:

![Neumann Boundary](images/neumann.svg)

Or even the full gradient:

