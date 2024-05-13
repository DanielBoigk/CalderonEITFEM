# need to implement the generation of a circular .geo file mesh here

export create_circle_geo, create_square_geo

# This works with FerriteGmsh but not with GridapGmsh:
# It works with both: 
# But for whatever reason 
function create_circle_geo(cellsize::Float64=0.05)
    all = 
"cellSize = "*string(cellsize)*";
radius = 1;
Point(1) = {0, 0, 0, cellSize};
Point(2) = {-radius, 0, 0, cellSize};
Point(3) = {0, radius, 0, cellSize};
Point(4) = {radius, 0, 0, cellSize};
Point(5) = {0, -radius, 0, cellSize};
Circle(6) = {2, 1, 3};
Circle(7) = {3, 1, 4};
Circle(8) = {4, 1, 5};
Circle(9) = {5, 1, 2};
Line Loop(10) = {6, 7, 8, 9};
Plane Surface(11) = {10};

// Mark the boundary of the circular mesh
Physical Line(\"boundary\") = {6, 7, 8, 9};
// Now also add points to the same \"Boundary\" physical group
Physical Point(\"boundary\") = {2, 3, 4, 5};

Physical Surface(\"disk\") = {11};
// Mesh generation commands (if needed)
Mesh 2;"


    write("circle.geo", all)
    # Requires Gmsh installed.
    run(`gmsh -2 circle.geo -o circle.msh`)  
end


function create_square_geo(cellsize::Float64=0.05)
    all = "cellSize = "*string(cellsize)*";
    radius = 1;
    Point(1) = {0, 0, 0, cellSize};    // Center point
    Point(2) = {-radius, -radius, 0, cellSize};  // Bottom left
    Point(3) = {-radius, radius, 0, cellSize};   // Top left
    Point(4) = {radius, radius, 0, cellSize};    // Top right
    Point(5) = {radius, -radius, 0, cellSize};   // Bottom right
    
    Line(6) = {2, 3};  // Left edge
    Line(7) = {3, 4};  // Top edge
    Line(8) = {4, 5};  // Right edge
    Line(9) = {5, 2};  // Bottom edge
    
    Line Loop(10) = {6, 7, 8, 9};  // Loop around the square
    Plane Surface(11) = {10};  // Define the square surface
    
    // Mark the boundary of the square mesh
    Physical Line(\"boundary\") = {6, 7, 8, 9};
    // Now also add points to the same \"Boundary\" physical group
    Physical Point(\"boundary\") = {2, 3, 4, 5};
    
    Physical Surface(\"disk\") = {11};  // Although named \"disk\", this is now a square
    // Mesh generation commands (if needed)
    Mesh 2;"
    
    write("square.geo", all)
    # Requires Gmsh installed.
    run(`gmsh -2 square.geo -o square.msh`) 
end