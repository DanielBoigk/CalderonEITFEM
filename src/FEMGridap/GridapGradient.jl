# It is quite complicated to extract the gradient from a Gridap solution. 
#I will do that here:

#export Gradient_to_Normal #, gen_EIT_training_sqr

export extract_gradient #, extract_gradient_border
export gradient_atPoints, normals_atBoundary
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

#Will extract gradient at given points:
function gradient_atPoints(u, coordinates)
    # This is slow af: improve when time
    n = size(coordinates,1)
    grid_points = [Point((coordinates[i,1], coordinates[i,2])) for i in 1:n]
    grad_u= ∇(u)
    # This is the really really bad part:
    @time begin
    Grid_Gradient = grad_u.(grid_points)
    end
    return [Grid_Gradient[i][j] for i in 1:n, j in 1:2]
end

# Need to construct n_grad_u via ∇(u) ⋅ n_Γ before and pass it as an argument: returns vector with normal gradients at boundary given suitable coordinates
function normals_atBoundary(n_grad_u, coordinates)
    n = size(coordinates,1)
    grid_points = [Point((coordinates[i,1], coordinates[i,2])) for i in 1:n]
    @time begin
    Grid_Normals = n_grad_u.(grid_points)
    end
    return [Grid_Normals[i] for i in 1:n]
end

# Will extract gradient given FEM solution u on domain [0,1]×[0,1]
#=function extract_gradient(u, x_dim::Int64=100, y_dim::Int64=100)
    # This is slow af: improve when time
    x_range = range(0.0, stop=1.0, length=x_dim)
    y_range = range(0.0, stop=1.0, length=y_dim)
    grid_points = [Point((x, y)) for x in x_range, y in y_range]
    grad_u= ∇(u)
    # This is the really really bad part:
    @time begin
    Grid_Gradient = grad_u.(grid_points)
    end
    G = [Grid_Gradient[x,y][i] for x in 1:x_dim, y in 1:y_dim, i in 1:2]
    return G
end


function extract_gradient_border(u, x_dim::Int64=100, y_dim::Int64=100)
    # This is slow af: improve when time
    coordinates = sqr_boundary_coordinates(x_dim,y_dim)
    n = size(coordinates)[1]
    grid_points = [Point((coordinates[i][1], coordinates[i][2])) for i in 1:n]
    grad_u= ∇(u)
    # This is the really really bad part:
    @time begin
    Grid_Gradient = grad_u.(grid_points)
    end
    G = [Grid_Gradient[j][i] for j in 1:n, i in 1:2]
    return G
end
=#
function extract_gradient(uh, points)
    grad_u = ∇(uh)
    grid_points = [Point( (points[i,1], points[i,2])) for i in 1:size(points,1)]
    Grid_Gradient = grad_u(grid_points)
    return Grid_Gradient
end