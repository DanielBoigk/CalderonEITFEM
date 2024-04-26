
export interpolate_array_1D, interpolate_array_2D
export interpolate_circle_2D, interpolate_circle_boundary

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

# This interpolates on intervall [0,1]×[0,1]
function interpolate_array_2D(arr::Array{Float64, 2})
    # Ensure the input array is n x n
    @assert size(arr, 1) == size(arr, 2) "The input array must be square (n x n)."

    # Define the range of the original array indices
    n = size(arr, 1)
    xs = 1:n
    ys = 1:n
    
    # Create an interpolation object
    itp = Interpolations.interpolate((xs, ys), arr, Gridded(Linear()))
    
    # Define a function to map the interval [0, 1] to the array index range [1, n]
    return x -> itp(1 + x[1] * (n - 1), 1 + x[2] * (n - 1))
end

# This interpolates on intervall [-1,1]×[-1,1]
function interpolate_circle_2D(arr::Array{Float64, 2})
    # Ensure the input array is n x n
    @assert size(arr, 1) == size(arr, 2) "The input array must be square (n x n)."

    # Define the range of the original array indices
    n = size(arr, 1)
    xs = 1:n
    ys = 1:n
    
    # Create an interpolation object
    itp = Interpolations.interpolate((xs, ys), arr, Gridded(Linear()))
    
    # Define a function to map the interval [0, 1] to the array index range [1, n]
    return x -> itp(1 + (0.5*x[1]+ 0.5) * (n - 1), 1 + (0.5*x[2]+0.5) * (n - 1))
end


# This projects an arbitrary point unto the unit circle and approximates there over a given array.
function interpolate_circle_boundary(data::Vector{Float64})
    func = interpolate_array_1D(data, true)
    return x -> func( atan(x[2],x[1])  /(2*π) + 0.5)
end