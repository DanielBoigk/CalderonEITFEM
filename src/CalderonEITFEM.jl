module CalderonEITFEM

    using Random, Statistics, LinearAlgebra, Images, Interpolations, SciPy
    using Gridap, GridapGmsh
    
    #Since I need to call some python functions:
    using PyCall
    const mymodule = pyimport("CalderonFEM")

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

    include("SqrTrain.jl")


    #export Gradient_to_Normal, gen_EIT_training_sqr
    #export EIT_FEM_neumann_to_dirichlet, EIT_FEM_dirichlet_to_neumann

    export FEM_data

    struct FEM_data 
        γ::Array{Float64, 2} 
        U::Array{Float64, 2}
        boundary::Array{Float64, 1}
        d_boundary::Array{Float64, 1}
        n_boundary::Array{Float64, 1}
        G::Array{Float64, 3}
    end
    
end