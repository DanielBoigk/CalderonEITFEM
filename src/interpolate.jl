
export interpolate_array_1D, interpolate_array_2D

function interpolate_array_1D(data::Vector{Float64})
    n = length(data)
    # Interpolation points (assumes data index starts from 1 to n)
    x = 1:n

    # Create interpolation object
    itp = interpolate(data, BSpline(Linear()))
    sitp = scale(itp, linspace(0, 1, n))  # Scale it to map from 0 to 1

    return sitp
end

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