function interpolate_array_1D(data::Vector{Float64}, is_periodic::Bool = false)
    n = length(data)
    # Interpolation points (assumes data index starts from 1 to n)
    if is_periodic 
        x = 1:n+1
        data_2 = [data[1:n]; data[1]]

        # Create interpolation object
        itp = Interpolations.interpolate(data_2, BSpline(Linear()))
        return x -> itp(1+ x * n )
    else


    # Create interpolation object
    itp = Interpolations.interpolate(data, BSpline(Linear()))

    return x -> itp(1+ x * (n - 1))
    end
end






# This projects an arbitrary point unto the unit circle and approximates there over a given array.
function interpolate_circle_boundary(data::Vector{Float64})
    func = interpolate_array_1D(data, true)
    return x -> func( atan(x[2],x[1])  /(2*π) + 0.5)
end

# This is a bunch of functions that together do the same for 