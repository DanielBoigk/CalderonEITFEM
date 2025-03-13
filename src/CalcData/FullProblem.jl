struct EITSolution # Ideally keep it immutable
    mesh    # Triangulation of the mesh
    free_points::Int64
    boundary_points::Int64
    boundary_vals
    V_n_space
    U_n_space
    V_d_space
    U_d_space
    γ   # FEFunction of conductivity
    γ_vec # free values of conductivity
    K_n     # Stiffness matrix for Neumann problem
    K_d # Stiffness matrix for Dirichlet problem
    G::Dict # Orthonormal basis for current pattern
    F::Dict # Corresponding voltage measurements
    u_f::Dict # FEFunctions of voltage measurements
    g_f::Dict # FEFunctions of current measurements
    singular::AbstractVector # Singular values of NtD map
    NtD # NtD map
    DtN # DtN map (Moore-Penrose inverse of NtD)
    deleted_rows # What rows are to be deleted in F
end




