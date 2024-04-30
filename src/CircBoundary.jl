# Write functions that access boundary values of a circle.

export get_mesh_coordinates

MeshIO = pyimport("meshio")    
np = pyimport("numpy")


function rows_with_norm_close_to_one(matrix; tol=1e-5)
    # Filter and return the rows where the norm is approximately 1
    return filter(row -> isapprox(norm(row), 1, atol=tol), eachrow(matrix))
end

function rows_with_norm_not_close_to_one(matrix; tol=1e-5)
    # Filter and return the rows where the norm is not approximately 1
    return filter(row -> !isapprox(norm(row), 1, atol=tol), eachrow(matrix))
end

function get_mesh_coordinates()
    try
        mesh = MeshIO.read("circle.msh")    
    catch
        try
            run(`gmsh -2 circle.geo -o circle.msh`)  
        catch
            create_circle_geo()
        end
        mesh = MeshIO.read("circle.msh")
    end
    # Extract coordinates of points from .msh and make them usable in Julia:
    julia_points = np.asarray(points) |> Array{Float64}
    
    #Extract Boundary Values#
    boundary = rows_with_norm_close_to_one(julia_points, tol=0.00001)
    free_values = rows_with_norm_not_close_to_one(julia_points, tol=0.00001)
    return boundary, free_values
end