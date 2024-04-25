# need to implement the generation of a circular .geo file mesh here

export create_circle_geo

# This works with FerriteGmsh but not with GridapGmsh:
function create_circle_geo(cellsize::Float64=0.05)
    all = 
    "cellSize = "*string(cellsize)*";
    radius = 1;
    Point(1) = {0, 0, 0,cellSize};
    Point(2) = {-radius, 0, 0,cellSize};
    Point(3) = {0, radius,  0,cellSize};
    Point(4) = {radius, 0,  0,cellSize};
    Point(5) = {0, -radius,  0,cellSize};
    Circle(6) = {2, 1, 3};
    Circle(7) = {3, 1, 4};
    Circle(8) = {4, 1, 5};
    Circle(9) = {5, 1, 2};
    Line Loop(10) = {6, 7, 8, 9};
    Plane Surface(11) = {10};

    // Mark the boundary of the circular mesh
    Physical Line(\"Boundary\") = {6, 7, 8, 9};
    Physical Surface(\"Disk\") = {11};
    // Mesh generation commands (if needed)
    Mesh 2;"

    write("circle.geo", all)
end