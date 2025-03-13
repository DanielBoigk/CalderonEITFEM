




function gen_cont_data_1D( n_elem::Int=100,σ::Float64=5.0,;is_periodic::Bool=true, mean_zero::Bool=true, use_scipy::Bool=true)
    if is_periodic
        A = randn(1, n_elem)
        # Apply the Gaussian filter with circular padding
        A = gauß_filter(A, (σ, σ), "circular", use_scipy)
        # Convert back to 1D
        A = dropdims(A, dims=1)
    else
        A = randn(1, 3*n_elem)
        A = gauß_filter(A, (σ, σ), "replicate", use_scipy)  
        A = dropdims(A, dims=1)
        A = A[n_elem+1:2*n_elem]
    end
    if mean_zero
        #This is to ensure that is sums up to 0
        A .-= Statistics.mean(A)
    end
    # Maybe I should still scale it such that it integrates to an average of one.
    sumA  = sum(abs.(A))
    return (2/sumA)*A
end

function gen_single_points_1D(n_elem::Int=100, n_points::Int64=2,; mean_zero::Bool= true, use_filter= false, σ::Float64 = 5.0, mode::String = "circular")
    point_values = randn(n_points)
    if mean_zero
        point_values .-= Statistics.mean(point_values)  
    end

    A = zeros(n_elem)
    A[1:n_points] = point_values
    
    A = shuffle(A)
    if use_filter
        if mode == "circular"
            A = SciPy.ndimage.gaussian_filter1d(A, σ, mode= "wrap")
        else
            A = SciPy.ndimage.gaussian_filter1d(A, σ, mode= "constant")
        end
    end
    return A
end
