struct EITSolution # Ideally keep it immutable
    mesh    # Triangulation of the mesh
    V_n_space
    U_n_space
    V_d_space
    U_d_space
    γ   # FEFunction of conductivity
    γ_vec # free values of conductivity
    K_n     # Stiffness matrix for Neumann problem
    K_d # Stiffness matrix for Dirichlet problem
    G # Orthonormal basis for current pattern
    F # Corresponding voltage measurements
    singular # Singular values of NtD map
    NtD # NtD map
    DtN # DtN map (Moore-Penrose inverse of NtD)
    deleted_rows # What rows are to be deleted in F
end




