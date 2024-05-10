export gen_EIT_training_sqr

function extract_U_square(uh,x_dim::Int64=100,y_dim::Int64=100, ; mode = "dirichlet", l_order::Int64=1 )
    if l_order==1
        if mode == "dirichlet"
            S = copy(uh.free_values)
            #I don't want this thing to be somewhere completely outside:
            S .-= Statistics.mean(S)
            S = reshape(S, (x_dim,y_dim))
            return S
        else
            # Extract Matrix Valued solution:
            Out = zeros(x_dim,y_dim)
            S = copy(uh.free_values)
    
            S = reshape(S, (x_dim-2,y_dim-2))
            Out[2:x_dim-1,2:x_dim-1]= S
        return Out
        end
    end
end

#I'm gonna throw this solution overboard.
# This is the function which calculates everything
function gen_EIT_training_sqr(n::Int64=100, σ_b::Float64=10.0, σ_γ::Float64=5.0,; FEM_mode::String = "dirichlet", gen_mode::String="abs", min_value::Float64=1.0e-10, calc_gradient::String= "full" , lagrange_order::Int64= 1)
    #  generate conductivity:
    γ = gen_cont_data_2D(n,σ_γ,σ_γ, mode=gen_mode, min_val=min_value)
    γ_func = interpolate_array_2D(γ)
    # Now generate boundary conditions:
    if FEM_mode == "dirichlet"
        println(" Generating dirichlet boundary")
        boundary =  gen_cont_data_1D(4*n-4, σ_b, mean_zero=false)
    else
        println(" Generating neumann boundary")
        boundary =  gen_cont_data_1D(4*n-4, σ_b)
    end   
    B = boundary_to_square(boundary)
    b_func = interpolate_array_2D(B)

    # Solve FEM
    if FEM_mode == "dirichlet"
        u = EIT_FEM_dirichlet_to_neumann(γ_func,b_func,n,n, order = lagrange_order)
        U = extract_U_square(u,n,n, mode="dirichlet")
        U += B
        d_boundary = boundary 
    else
        u = EIT_FEM_neumann_to_dirichlet(γ_func,b_func,n,n, order = lagrange_order)
        U = extract_U_square(u,n,n)
        d_boundary = square_to_boundary(U)
    end
    
    # Extract Gradient
    # This is still just one big abomination:
    if calc_gradient =="full"
        println("FEM solved: Now calculating Gradient")
        #This is still slow af: 
        @time begin
        G = extract_gradient(u,n,n)
        end
        # Extract neumann boundary
        N = Gradient_to_Normal(G)
        n_boundary = square_to_boundary(N)
    elseif calc_gradient == "boundary"
        println("to be implemented")
        boundary_G = extract_gradient_border(u, n, n)
        G = zeros(n,n,2)
        G[:,:,1]= boundary_to_square(boundary_G[:,1])
        G[:,:,2]= boundary_to_square(boundary_G[:,2])
        println(size(G))
        N = Gradient_to_Normal(G)
        n_boundary = square_to_boundary(N)
    else
        n_boundary=zeros(4*n-4)
        G = zeros(n,n,2)
    end
    #return Everything:
    return FEM_data(γ, U, boundary, d_boundary, n_boundary, G)
end
