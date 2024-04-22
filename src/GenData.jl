module GenData
    using Random, Statistics, LinearAlgebra, Images, Gridap, Interpolations

        
    export gen_cont_data_1D, gen_cont_data_2D, gen_cont_data_3D    


    # This function uses white noise and filters it.

    function gen_cont_data_1D( n_elem::Int=100,σ::Float64=5.0,;is_periodic::Bool=true, mean_zero::Bool=true)
        if is_periodic
            A = randn(1, n_elem)
            # Apply the Gaussian filter with circular padding
            A = imfilter(A, Kernel.gaussian((σ, σ)), "circular")
            # Convert back to 1D
            A = dropdims(A, dims=1)
        else
            A = randn(1, 3*n_elem)
            A = imfilter(A, Kernel.gaussian((σ, σ)), "replicate") 
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
    

    function gen_cont_data_2D( n_elem::Int=100, σ1::Float64=5.0, σ2::Float64=5.0,; pos_only::Bool=true, mode::String="abs", min_val::Float64=1.0e-10, is_periodic::Bool=false, mean_zero::Bool=false)
        # Initialize array with random entries
        if is_periodic
            A = randn(n_elem, n_elem)
            if pos_only
                if mode == "abs"
                    A = abs.(A)
                    A = imfilter(A, Kernel.gaussian((σ1, σ2)), "circular")
                elseif mode == "exp"
                    A = imfilter(A, Kernel.gaussian((σ1, σ2)), "circular")
                    A = exp.(A)
                else
                    A = imfilter(A, Kernel.gaussian((σ1, σ2)), "circular")
                end
                A .+=  -minimum(A)+ min_val
            else
                A = imfilter(A, Kernel.gaussian((σ1, σ2)), "circular")
                if mean_zero
                    A .-= Statistics.mean(A)
                end
            end
    
        
        else # The nonperiodic case
            A = randn(3*n_elem, 3*n_elem)    
            if pos_only
                if mode == "abs"
                    A = abs.(A)
                    A = imfilter(A, Kernel.gaussian((σ1, σ2)), "replicate")
                    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                elseif mode == "exp"
                    A = imfilter(A, Kernel.gaussian((σ1, σ2)), "replicate")
                    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                    A = exp.(A)
                else
                    A = imfilter(A, Kernel.gaussian((σ1, σ2)), "replicate")
                    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                end
                A .+= - minimum(A)+ min_val
            else # In case negative values are allowed
                A = imfilter(A, Kernel.gaussian((σ1, σ2)), "replicate")
                A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
                if mean_zero
                    A .-= Statistics.mean(A)
                end
            end
        end
    
        #Scale it to useable value
        mean_A = Statistics.mean(A)
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
                    A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "circular")
                elseif mode == "exp"
                    A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "circular")
                    A = exp.(A)
                else
                    A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "circular")
                end
                A .+=  -minimum(A)+ min_val
            else
                A = imfilter(A, Kernel.gaussian((σ1, σ2, σ3)), "circular")
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


end