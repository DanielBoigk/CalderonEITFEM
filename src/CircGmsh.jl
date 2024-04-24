# need to implement the generation of a circular .geo file mesh here

export create_circle_geo

function create_circle_geo(charlength::Float64=0.1)
    all = "SetFactory(\"OpenCASCADE\");\n
Circle(1) = {0, 0, 0, 1, 0, 2*Pi};\n
Physical Surface(\"Circle\") = {1};\n
Mesh.CharacteristicLengthMax = " * string(charlength) * ";  // Adjust mesh density\n
Mesh 2;\n
Save \"circle.msh\";"

write("circle.geo", all)

end

