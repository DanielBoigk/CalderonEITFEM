# Here is the GRidap FEM solution

export EIT_FEM_neumann_to_dirichlet, EIT_FEM_dirichlet_to_neumann


# Receives two mxn Matrices with on describing σ on the domain and the other one describing the neumann boundary condition 
function EIT_FEM_neumann_to_dirichlet(σ_function,j_function, x_dim::Int64=100, y_dim::Int64=100,; order::Int64=1, degree::Int64 = 2)

    @time begin
    # Once known define this correctly:
    domain = (0.0, 1.0, 0.0, 1.0)  # Define your domain

    n = (x_dim-1, y_dim-1)  # Number of divisions in each dimension

    # Then define all the other stuff needed:
    model = CartesianDiscreteModel(domain, n)
    reffe = ReferenceFE(lagrangian, Float64, order)
    V = TestFESpace(model, reffe, conformity=:H1)
    U = V 

    #Define Triangulation:
    Ω = Triangulation(model)
    dΩ = Measure(Ω,degree)
    Γ = BoundaryTriangulation(model)
    dΓ = Measure(Γ,degree) 

    # Weak problem:
    a(u, v) = ∫( σ_function * ∇(v) ⋅ ∇(u) )dΩ
    l(v) = ∫( j_function * v )dΓ  # Neumann condition
    
    # And Solve
    op = AffineFEOperator(a,l,U,V)
    end
    @time begin
    uh = solve(op)
    end
    @time begin
    # Extract Matrix Valued solution:
    S = uh.free_values
    #I don't want this thing to be somewhere completely outside:
    S .-= Statistics.mean(S)
    S = reshape(uh.free_values, (x_dim,y_dim))
    
    end
    return S, uh
end

function EIT_FEM_dirichlet_to_neumann(σ_function,j_function, x_dim::Int64=100, y_dim::Int64=100, order::Int64=1, degree::Int64 = 2)

  @time begin
    # Once known define this correctly:
    domain = (0.0, 1.0, 0.0, 1.0)  # Define your domain

    n = (x_dim-1, y_dim-1)  # Number of divisions in each dimension

    # Then define all the other stuff needed:
    model = CartesianDiscreteModel(domain, n)
    reffe = ReferenceFE(lagrangian, Float64, order)
    V = TestFESpace(model, reffe, conformity=:H1, dirichlet_tags="boundary")
    U = TrialFESpace(V, j_function) 

    #Define Triangulation:
    Ω = Triangulation(model)
    dΩ = Measure(Ω,degree)

    # Weak problem:
    a(u, v) = ∫( σ_function * ∇(v) ⋅ ∇(u) )dΩ
    l(v) =  0 
    
    # And Solve
    op = AffineFEOperator(a,l,U,V)
  end
  @time begin
    uh = solve(op)
  end
  @time begin
    # Extract Matrix Valued solution:
    Out = zeros(x_dim,y_dim)
    S = uh.free_values
    
    S = reshape(uh.free_values, (x_dim-2,y_dim-2))
    Out[2:x_dim-1,2:x_dim-1]=S
  end
    return Out, uh
end
