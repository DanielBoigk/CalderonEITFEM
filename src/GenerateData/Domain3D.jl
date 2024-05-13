#The 3dimensional case... for Later
function gen_cont_data_3D( n_elem::Int=100, σ1::Float64=5.0, σ2::Float64=5.0, σ3::Float64=5.0,; pos_only::Bool=true, mode::String="abs", min_val::Float64=1.0e-10, is_periodic::Bool=false, mean_zero::Bool=false)
    # Initialize array with random entries
    if is_periodic
        A = randn(n_elem, n_elem, n_elem)
        if pos_only
            if mode == "abs"
                A = abs.(A)

                A = gauß_filter(A, (σ1, σ2, σ3), "circular", use_scipy)
            elseif mode == "exp"
                A = gauß_filter(A, (σ1, σ2, σ3), "circular", use_scipy)
                A = exp.(A)
            else
                A = gauß_filter(A, (σ1, σ2, σ3), "circular", use_scipy)
            end
            A .+=  -minimum(A)+ min_val
        else
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