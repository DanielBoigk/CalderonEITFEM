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
    print("Boundary Points (indices):")
    print(boundary_points_list)

    # Get the coordinates of the boundary points
    boundary_points_coords = points[boundary_points_list, :]
    print("Boundary Points (coordinates):")
    print(boundary_points_coords)

    return boundary_points_coords

# Example usage
file_path = "path/to/your/meshfile.msh"
boundary_points = extract_boundary_points(file_path)
