
export extract_at_coordinates

function extract_at_coordinates(u, coordinates, extract_gradient::Bool =false, try_catch::Bool = false)
    
    
    if !try_catch

        if extract_gradient
            return gradient_atPoints(u, coordinates)
        else 
            n = size(coordinates,1)
            grid_points = [Point((coordinates[i,1], coordinates[i,2])) for i in 1:n]
            grid_points = [Point((coordinates[i,1], coordinates[i,2])) for i in 1:n]
            @time begin
                Grid_U = u.(grid_points)
            end
            return [Grid_U[i][j] for i in 1:n, j in 1:2]
        end
    else

        println!("To be implemented")
    end
end