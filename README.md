# CalderonEITFEM

Creates Training Data for Calderon/EIT Problem using FEM-solver.

1. Contains Methods for generating conductivity, and boundary conditions:
   Based on white noise with gaussian filtering. 
   Alternatively uses Gaussian Random fields. 

2. Creates Rectangular/Square or circular Mesh with varying granularity.

3. Calculates FEM Solution of both Dirichlet-to-Neumann and Neumann-to-Dirichlet Map

4. Generates Full data set of Conductivity, Voltage, Neumann boundary (Current), dirichlet boundary(voltage). If specified will also calculate full gradient flow. 

5. Gives Matrix valued approximation of Forward operators on Boundary

Data created is meant as training Data for Solving the inverse problem of electrical impedance tomography.

**This repository is just a prerequisite for the actual training of Neural Operators, PINN's or similar architectures to both approximate the Forward solution and calculate the inverse solution from the boundary operators.** For actual solvers look for PyEIT or similar. (Stay tuned for another package.)

Excludes Solution using Ferrite since Gridap and Ferrite do not run in the same environment.

## The EIT - Forward Problem

Since the Electircal Impedance Problem is an Inverse Problem we have two choices given conductivity values $\gamma$ we can calculate the operator $\Lambda_n$ mapping from neumann boundary to dirichlet boundary or the inverse operator $\Lambda_d$. 
Given one of these Boundary operators we can start solving the inverse Problem which is Electrical Impedance Tomography.

### Neumann-to-Dirichlet Map

Given the strong formulation:

$$
\nabla\cdot(\gamma \nabla u) = 0 \text{    } \forall x\in\Omega
$$

with neumann boundary condiction

$$
\frac{\partial u(x)}{\partial \vec{n}(x)} = g(x) \forall x\in \partial \Omega 
$$

such that:

$$
\int\limits_{\partial\Omega} g(x) d\mathcal{S} =0 
$$

The weak problem thus becomes: 

$$ 
\int\limits_\Omega \gamma\nabla u\cdot\nabla v dx = \int\limits_{\partial\Omega} v d\mathcal{S} \forall v \in H^{-\frac{1}{2}}(\Omega) 
$$

### Dirichlet-to-Neumann Map

Here the strong formulation is:
$$\nabla \cdot (\gamma(x) \nabla u(x)) =0  \forall x \in \Omega $$
with dirichlet boundary condition:
$$u(x) = g(x)   \forall x \in \\partial\Omega$$

The Weak form then becomes: 

$$
\int\limits_\Omega \gamma\nabla u\cdot\nabla v dx = 0  \forall v \in H^{\frac{1}{2}}(\Omega) 
$$

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

![Gradient_x](images/Gradientx.svg)

![Gradient_x](images/Gradienty.svg)

## Example Conductivity Data generated:

Other Methods to produce random conductivity:

a version with just two different values.

![](images/2color.svg)

or a combination thereof:

![](images/Combined.svg)


## How to use:

1. Have a systemwide install of gmsh, for example via:



<blockquote>

```bash
sudo pacman -Syu gmsh
```

</blockquote>


2. Open a virtual env for Python

install requirements.txt ()

3. Start a virtual env for Julia:

install all dependencies in the Venv

add module via


<blockquote>

```Julia
using Pkg
Pkg.activate("/Path/to/Julia/Venv)
Pkg.instantiate()
ENV["PYTHON"] = "/home/.../path/to/python/venv"
Pkg.build("PyCall")

#Then do:
include("CalderonEITFEM/src/CalderonEITFEM.jl")
using .CalderonEITFEM

```

</blockquote>


Do not install gmsh_jll or FerriteGmsh, as this will break GridapGmsh ( as of 02nd May 2024)

## Todo:
