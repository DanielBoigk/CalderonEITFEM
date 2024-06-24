module CalderonEITFEM

    using Random, Statistics, LinearAlgebra, Images, Interpolations
    using Gridap, GridapGmsh, ForwardDiff, SparseArrays
    using LineSearches: BackTracking
    
    #Since I need to call some python functions:
    using PyCall
    #const mymodule = pyimport("../python/CalderonFEM.py")
    using SciPy
    const MeshIO = pyimport("meshio")    
    const np = pyimport("numpy")

    # GridapGmsh does not work in the same enviroment with gmsh_jll.jl which FerriteGmsh unfortunately includes. Thus I need to write another module in another enviroment to have a solution run in Ferrite.
    #using Ferrite, FerriteGmsh
    
    # This file contains various functions to create data suited for Conductitivity and boundary conditions. 
    include("GenerateData/GenerateData.jl")
    
    include("Interpolation/Interpolation.jl")

    #include("Boundary/SqrBoundary.jl")

    include("MeshGen/CreateGeo.jl")

    #include("FEMGridap/GridapFEM.jl")
    
    #include("Boundary/BoundaryPoints.jl")
    #include("Boundary/CircBoundary.jl")

    #include("FEMGridap/GridapGradient.jl")

    #include("CreateGeoGmsh.jl")

    #include("SqrTrain.jl")

    try
        using Ferrite, FerriteGmsh
        include("FEMFerrite/FerriteFEM.jl")
    catch
        println("Ferrite not installed in environment")
    end

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