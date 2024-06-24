# Write functions that access boundary values of a circle.

export get_mesh_coordinates
export extract_gradient_circle
export VectorGradient_to_Array

export normalize_gradient, NORMALIZE_GRADIENT


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

function get_mesh_coordinates(file_name::String = "circle.msh")
    mesh = MeshIO.read(file_name)  
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
#This doesn't work quite because Gridap has a particular function still not implemented:
function extract_gradient_circle(uh, Allpoints)
    grad_u = ∇(uh)
    grid_points = [Point( (Allpoints[i,1], Allpoints[i,2])) for i in 1:size(Allpoints,1)]

    #This is the part where it says not yet implemented
    #grid_points = [Point( (Allpoints[i,1], Allpoints[i,2], Allpoints[i,3])) for i in 1:size(Allpoints,1)]
    Grid_Gradient = grad_u(grid_points)
    return Grid_Gradient
end


# Implement function that extracts value normal to gradient.
function normalize_gradient(point::Vector{Float64}, gradient::Vector{Float64})
    abs = norm(point)
    return (1/abs)*dot(point, gradient)
end
#Does the same just with an entire Array
function NORMALIZE_GRADIENT(point::Array{Float64,2}, gradient::Array{Float64,2})
    [ normalize_gradient(point[i,:], gradient[i,:]) for i in 1:size(point,1)]
end

function VectorGradient_to_Array(A)
    G = [A[j][i] for j in 1:size(A,1), i in 1:2]
    return G
end

function correct_order_circle(InArray)
    OutArray = copy(InArray)
    n = size(InArray,1)
    b = round(Int,n/4) 
    println(b)
    OutArray[2:b] = InArray[5:b+3]
    OutArray[b+1] = InArray[2]
    OutArray[b+2:2*b] = InArray[b+4:2*b+2]
    OutArray[2*b+1] = InArray[3]
    OutArray[2*b+2:3*b] = InArray[2*b+3:3*b+1]
    OutArray[3*b+1] = InArray[4]

    return OutArray
end