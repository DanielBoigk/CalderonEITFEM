# Write functions that access boundary values of a circle.

export get_mesh_coordinates
export extract_gradient_circle
MeshIO = pyimport("meshio")    
np = pyimport("numpy")


function rows_with_norm_close_to_one(matrix; tol=1e-5)
    # Filter and return the rows where the norm is approximately 1
    A = filter(row -> isapprox(norm(row), 1, atol=tol), eachrow(matrix))
    B = zeros(size(A,1),3)
    for i in 1:size(A,1)
        B[i,:] = A[i]
    end
    return B
end

function rows_with_norm_not_close_to_one(matrix; tol=1e-5)
    # Filter and return the rows where the norm is not approximately 1
    A = filter(row -> !isapprox(norm(row), 1, atol=tol), eachrow(matrix))
    B = zeros(size(A,1),3)
    for i in 1:size(A,1)
        B[i,:] = A[i]
    end
    return B
end

function get_mesh_coordinates()
    mesh = MeshIO.read("circle.msh")  
    #=try
        mesh = MeshIO.read("circle.msh")    
    catch
        try
            run(`gmsh -2 circle.geo -o circle.msh`)  
        catch
            create_circle_geo()
        end
        mesh = MeshIO.read("circle.msh")
    end =#
    # Extract coordinates of points from .msh and make them usable in Julia:
    points = mesh["points"]
    julia_points = np.asarray(points) |> Array{Float64}
    
    #Extract Boundary Values#
    boundary = rows_with_norm_close_to_one(julia_points, tol=0.00001)
    free_values = rows_with_norm_not_close_to_one(julia_points, tol=0.00001)
    
    return boundary, free_values, julia_points
end

function extract_gradient_circle(uh, Allpoints)
    grad_u = ∇(uh)
    grid_points = [Point(Allpoints[i]) for i in 1:size(Allpoints,1)]

    Grid_Gradient = grad_u.(grid_points)
    return Grid_Gradient
end