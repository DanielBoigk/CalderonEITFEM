# It is quite complicated to extract the gradient from a Gridap solution. 
#I will do that here:

#export Gradient_to_Normal #, gen_EIT_training_sqr

export extract_gradient
#=
function Gradient_to_Normal(G::Array{Float64, 3})
    n = size(G)[1]
    m = size(G)[2]

    Out = zeros(n,m)

    Out[2:n-1,1] = -G[2:n-1,1,2]
    Out[2:n-1,m] = G[2:n-1,m,2]

    Out[1, 2:m-1] = -G[1, 2:m-1,1]
    Out[n, 2:m-1] = G[n, 2:m-1,1]
    #This is slightly incorrect, but I'm lazy:
    Out[1,1] = 0.5*(-G[1,1,2]-G[1, 1,1])
    Out[1,m] = 0.5*( G[1,m,2]-G[1, m,1])
    Out[n,1] = 0.5*(-G[n,1,2]+G[n, 1,1])
    Out[n,m] = 0.5*( G[n,m,2]+G[n, m,1])
    return Out
end

=#


# Will extract gradient given FEM solution u on domain [0,1]×[0,1]
function extract_gradient(u, x_dim::Int64=100, y_dim::Int64=100)
    # This is slow af: improve when time
    x_range = range(0.0, stop=1.0, length=x_dim)
    y_range = range(0.0, stop=1.0, length=y_dim)
    grid_points = [Point((x, y)) for x in x_range, y in y_range]
    grad_u= ∇(u)
    Grid_Gradient = grad_u.(grid_points)
    G = [Grid_Gradient[x,y][i] for x in 1:x_dim, y in 1:y_dim, i in 1:2]
    return G
end
