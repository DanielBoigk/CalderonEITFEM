
export extract_boundary_points_julia
#=
# Add the current directory to Python's sys.path
pushfirst!(PyVector(pyimport("sys")."path"), ".")

# Import the Python module
meshio_extractor = pyimport("Boundary_Points")

# Define a function in Julia to call the Python function
function extract_boundary_points(file_path::String)
    # Call the Python function
    boundary_points_coords = meshio_extractor.extract_boundary_points(file_path)
    
    # Convert the returned numpy array to a Julia array
    boundary_points_coords_julia = Array(boundary_points_coords)
    
    return boundary_points_coords_julia
end
=#

# Since I don't get the relative path thing to run:
function __init__()
    py"""
    import meshio

    def extract_boundary_points(file_path):
        # Read the .msh file
        mesh = meshio.read(file_path)
    
        # Extract points and cells from the mesh
        points = mesh.points
        cells = mesh.cells
    
        # Initialize a set to store boundary points
        boundary_points = set()
    
        # Iterate over cells to find boundary points
        for cell_block in cells:
            if cell_block.type == "line":
                for cell in cell_block.data:
                    for point_index in cell:
                        boundary_points.add(point_index)
    
        # Convert set to a sorted list
        boundary_points_list = sorted(boundary_points)
    
        # Print the boundary points (indices)
        #print("Boundary Points (indices):")
        #print(boundary_points_list)
    
        # Get the coordinates of the boundary points
        boundary_points_coords = points[boundary_points_list, :]
        #print("Boundary Points (coordinates):")
        #print(boundary_points_coords)
    
        return boundary_points_coords
    
    """
end

function extract_boundary_points_julia(file_path::String)
    # Call the Python function
    boundary_points_coords = py"extract_boundary_points"(file_path)
    
    # Convert the returned numpy array to a Julia array
    boundary_points_coords_julia = Array(boundary_points_coords)
    
    return boundary_points_coords_julia
end




#What I did somewhere else:
#=
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
    
=#

function reorder_boundary(input::Array{Float64,2})
    n  = size(input,1)
    output = copy(input)
    if n % 4 == 0
        m = n ÷ 4
        output[2:m,:]       = input[5:m+3,:] 
        output[m+2:2*m,:]   = input[m+4:2*m+2,:]
        output[2*m+2:3*m,:] = input[2*m+3:3*m+1,:]

        output[m+1,:] = input[2,:]
        output[2*m+1,:] = input[3,:]
        output[3*m+1,:] = input[4,:]
    else
        println("The case I tried to avoid happened. TRy to expand reorder function for boundary.")
    end
    return output
end


