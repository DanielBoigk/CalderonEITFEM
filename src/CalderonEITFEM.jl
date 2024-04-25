module CalderonEITFEM

    using Random, Statistics, LinearAlgebra, Images, Interpolations, SciPy
    using Gridap, GridapGmsh
    

    # GridapGmsh does not work in the same enviroment with gmsh_jll.jl which FerriteGmsh unfortunately includes. Thus I need to write another module in another enviroment to have a solution run in Ferrite.
    #using Ferrite, FerriteGmsh
    
    # This file contains various functions to create data suited for Conductitivity and boundary conditions. 
    include("GenData.jl")
    
    include("interpolate.jl")

    include("SqrBoundary.jl")

    include("CircBoundary.jl")

    include("GridapFEM.jl")

    include("GridapGradient.jl")

    #include("FerriteFEM.jl")

    include("CircGridapGmsh.jl")


    #export Gradient_to_Normal, gen_EIT_training_sqr
    #export EIT_FEM_neumann_to_dirichlet, EIT_FEM_dirichlet_to_neumann

    #export FEM_data


    
end