


function extract_at_coordinates(u, coordinates, extract_gradient::Bool =false)

    grid_points = [Point((coordinates[i,1], coordinates[i,2])) for i in eachindex(coordinates)]
    
    if extract_gradient
        grad_u= ∇(u)
        # This is the really really bad part:
        @time begin
        Grid_Gradient = grad_u.(grid_points)
        end
        G = [Grid_Gradient[x,y][i] for x in 1:x_dim, y in 1:y_dim, i in 1:2]
        return G
    
    else 
    
    end
end