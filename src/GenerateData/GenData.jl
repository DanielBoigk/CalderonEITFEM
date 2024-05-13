
    # This function uses white noise and filters it.
    export gen_cont_data_1D, gen_cont_data_2D, gen_cont_data_3D
    export gauß_filter
    export gen_discrete_data_2D, gen_single_points_1D

    export combine_cont_dicrete_2D
    # Scipy's filter seems to be better. Images.jl has this annoying gridlike anomalies:
    function gauß_filter(A,σ_g, mode::String="circular", scipy::Bool=false)
        if scipy == true
            if mode == "circular"
                scipy_mode = "wrap"
            elseif mode =="replicate"
                scipy_mode = "nearest"
            end
            return SciPy.ndimage.gaussian_filter(A, σ_g, mode =scipy_mode)
        else
            return imfilter(A, Kernel.gaussian(σ_g), mode)
        end
    end

    function gen_cont_data_1D( n_elem::Int=100,σ::Float64=5.0,;is_periodic::Bool=true, mean_zero::Bool=true, use_scipy::Bool=true)
        if is_periodic
            A = randn(1, n_elem)
            # Apply the Gaussian filter with circular padding
            #A = imfilter(A, Kernel.gaussian((σ, σ)), "circular")
            A = gauß_filter(A, (σ, σ), "circular", use_scipy)
            # Convert back to 1D
            A = dropdims(A, dims=1)
        else
            A = randn(1, 3*n_elem)
            #A = imfilter(A, Kernel.gaussian((σ, σ)), "replicate")
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
    

    function gen_cont_data_2D( n_elem::Int=100, σ1::Float64=5.0, σ2::Float64=5.0,; pos_only::Bool=true, mode::String="abs", min_val::Float64=1.0e-10, is_periodic::Bool=false, mean_zero::Bool=false, use_scipy::Bool=true)
        # Initialize array with random entries
        if is_periodic
            A = randn(n_elem, n_elem)
            if pos_only
                if mode == "abs"
                    A = abs.(A)
                    #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "circular")
                    A = gauß_filter(A, (σ1, σ2), "circular", use_scipy)
                elseif mode == "exp"
                    #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "circular")
                    A = gauß_filter(A, (σ1, σ2), "circular", use_scipy)
                    A = exp.(A)
                else
                    #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "circular")
                    A = gauß_filter(A, (σ1, σ2), "circular", use_scipy)
                end
                A .+=  -minimum(A)+ min_val
            else
                #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "circular")
                A = gauß_filter(A, (σ1, σ2), "circular", use_scipy)
                if mean_zero
                    A .-= Statistics.mean(A)
                end
            end
    
        
        else # The nonperiodic case
            A = randn(3*n_elem, 3*n_elem)    
            if pos_only
                if mode == "abs"
                    A = abs.(A)
                    #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "replicate")
                    A = gauß_filter(A, (σ1, σ2), "replicate", use_scipy)
                    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                elseif mode == "exp"
                    #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "replicate")
                    A = gauß_filter(A, (σ1, σ2), "replicate", use_scipy)
                    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                    A = exp.(A)
                else
                    #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "replicate")
                    A = gauß_filter(A, (σ1, σ2), "replicate", use_scipy)
                    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                end
                A .+= - minimum(A)+ min_val
            else # In case negative values are allowed
                #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "replicate")
                A = gauß_filter(A, (σ1, σ2), "replicate", use_scipy)
                A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                if mean_zero
                    A .-= Statistics.mean(A)
                end
            end
        end
        if pos_only
            #Scale it to useable value
            mean_A = Statistics.mean(A)
            
        else
            mean_A = Statistics.mean(abs.(A))
        end
        return (1 / mean_A) * A
    end
    
    #The 3dimensional case... for Later
    function gen_cont_data_3D( n_elem::Int=100, σ1::Float64=5.0, σ2::Float64=5.0, σ3::Float64=5.0,; pos_only::Bool=true, mode::String="abs", min_val::Float64=1.0e-10, is_periodic::Bool=false, mean_zero::Bool=false)
        # Initialize array with random entries
        if is_periodic
            A = randn(n_elem, n_elem, n_elem)
            if pos_only
                if mode == "abs"
                    A = abs.(A)
                    #A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "circular")
                    A = gauß_filter(A, (σ1, σ2, σ3), "circular", use_scipy)
                elseif mode == "exp"
                    #A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "circular")
                    A = gauß_filter(A, (σ1, σ2, σ3), "circular", use_scipy)
                    A = exp.(A)
                else
                    #A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "circular")
                    A = gauß_filter(A, (σ1, σ2, σ3), "circular", use_scipy)
                end
                A .+=  -minimum(A)+ min_val
            else
                #A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "circular")
                A = gauß_filter(A, (σ1, σ2, σ3), "circular", use_scipy)
                if mean_zero
                    A .-= Statistics.mean(A)
                end
            end
    
        
        else # The nonperiodic case
            A = randn(3*n_elem, 3*n_elem, n_elem)    
            if pos_only
                if mode == "abs"
                    A = abs.(A)
                    A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "replicate")
                    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                elseif mode == "exp"
                    A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "replicate")
                    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                    A = exp.(A)
                else
                    A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "replicate")
                    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                end
                A .+= - minimum(A)+ min_val
            else # In case negative values are allowed
                A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "replicate")
                A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                if mean_zero
                    A .-= Statistics.mean(A)
                end
            end
        end
    
        #Scale it to useable value
        mean_A = Statistics.mean(A)
        return (1 / mean_A) * A
    end

# Add some more functions that can create some data:


#The discrete case:

function gen_discrete_data_2D(n_elem::Int=100, σ1::Float64=5.0, σ2::Float64=5.0,; pos_only::Bool=true, mode::String="abs", threshold::Float64=0.0, is_periodic::Bool=false, set_one_zero::Bool=false, use_scipy::Bool=true)
    if set_one_zero
        a = 0
        b = randn()
    else
        a = randn()
        b = randn()
    end
    if pos_only
        a = abs(a)
        b = abs(b)
    end    
    if set_one_zero
        a = 0
    end
    # Initialize array with random entries
    if is_periodic
        A = randn(n_elem, n_elem)
        #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "circular")
        A = gauß_filter(A, (σ1, σ2), "circular", use_scipy)
    else
        A = randn(3*n_elem, 3*n_elem)
        #A = imfilter(A, Kernel.gaussian((σ1, σ2)), "replicate")
        #A = SciPy.ndimage.gaussian_filter(A, (5.0,5.0))
        A = gauß_filter(A, (σ1, σ2), "replicate", use_scipy)
        A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
    end
    for i in eachindex(A)
        A[i] = A[i] > threshold ? a : b
    end
    
    return A
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



# This function combines data 
function combine_cont_dicrete_2D(D::Array{Float64,2},C1::Array{Float64,2},C2::Array{Float64,2}, is_zero::Bool = false, ensure_positive = false)
    A = copy(D)
    values = unique(A)
    values = sort(values)
    if is_zero
        for i in eachindex(A)
            A[i] = A[i] == 0.0 ? A[i]+C1[i] : A[i]+C2[i]
        end
    else
        for i in eachindex(A)
            A[i] = A[i] == values[1] ? A[i]+C1[i] : A[i]+C2[i]
        end
    end
    return A
end