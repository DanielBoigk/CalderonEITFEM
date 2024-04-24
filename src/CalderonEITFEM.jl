module CalderonEITFEM

    using Random, Statistics, LinearAlgebra, Images, Gridap, Interpolations

    
    # This file contains various functions to create data suited for Conductitivity and boundary conditions. 
    include("GenData.jl")
    
    include("interpolate.jl")

    include("SqrBoundary.jl")

    include("CircBoundary.jl")

    include("GridapFEM.jl")

    include("GridapGradient.jl")

    include("FerriteFEM.jl")

    include("CircGmsh.jl")


    #export Gradient_to_Normal, gen_EIT_training_sqr
    #export EIT_FEM_neumann_to_dirichlet, EIT_FEM_dirichlet_to_neumann

    #export FEM_data


    
end