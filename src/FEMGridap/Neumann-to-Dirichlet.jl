export Neumann_to_Dirichlet

function Neumann_to_Dirichlet(mesh,γ,b,; is_linear::Bool=true, order::Int64=1)
    domain = (-1.0, 1.0, -1.0, 1.0)
    reffe = ReferenceFE(lagrangian, Float64, order)
    V = TestFESpace(mesh, reffe, conformity=:H1)
    U = TrialFESpace(V) 

    #Define Triangulation:
    Ω = Triangulation(mesh)
    dΩ = Measure(Ω,2)
    Γ = BoundaryTriangulation(mesh)
    dΓ = Measure(Γ,2) 

    if is_linear
        # Weak problem:
        a(u, v) = ∫( γ * ∇(v) ⋅ ∇(u) )dΩ
        l(v) = ∫( b * v )dΓ  # Neumann condition

        # And Solve
        lop = AffineFEOperator(a,l,U,V)
        lsolver = LUSolver()
        ls= LinearFESolver(lsolver)
        @time begin
            luh = solve(ls,lop)
        end
        return luh
    else
        # Weak problem:
        res(u,v) = ∫(  γ * ∇(v) ⋅ ∇(u) )dΩ -  ∫( b * v )dΓ
        jac(u,du,v) =  ∫(  γ * ∇(v) ⋅ ∇(du) )dΩ
        # And Solve

        nsolver = NLSolver(show_trace=true, method=:newton, linesearch=BackTracking())
        nls = FESolver(nsolver)
        nop = FEOperator(res,jac,U,V)
        @time begin
            nuh = solve(nls,nop)
        end
        return nuh 
    end
end