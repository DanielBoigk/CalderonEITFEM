
# Given a square mesh write a function that extracts a 


export extract_gradient, extract_gradient_border

# Will extract gradient given FEM solution u on domain [-1,1]×[-1,1]
function extract_gradient(u, x_dim::Int64=100, y_dim::Int64=100)
    # This is slow af: improve when time
    x_range = range(-0.9999, stop=0.9999, length=x_dim)
    y_range = range(-0.9999, stop=0.9999, length=y_dim)
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



# Considerations for later that are now way to complicated.

#Ω = Triangulation(model)
#dΩ = Measure(Ω,2)
#Γ = BoundaryTriangulation(model)
#dΓ = Measure(Γ,2) 

#Γ.trian.model.grid.node_coords #Gives all the coordinates of the points in the mesh