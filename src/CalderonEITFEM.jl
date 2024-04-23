module CalderonEITFEM

    using Random, Statistics, LinearAlgebra, Images, Gridap, Interpolations

    
    # This file contains various functions to create data suited for Conductitivity and boundary conditions. 
    include("GenData.jl")

    #export gen_cont_data_1D, gen_cont_data_2D, gen_cont_data_3D
    #export interpolate_array_1D, interpolate_array_2D
    #export square_to_boundary, boundary_to_square, extract_gradient
    #export Gradient_to_Normal, gen_EIT_training_sqr
    #export EIT_FEM_neumann_to_dirichlet, EIT_FEM_dirichlet_to_neumann

    #export FEM_data


    
end