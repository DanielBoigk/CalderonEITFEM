function gen_cont_data_2D( n_elem::Int=100, σ1::Float64=5.0, σ2::Float64=5.0,; pos_only::Bool=true, mode::String="abs", min_val::Float64=1.0e-10, is_periodic::Bool=false, mean_zero::Bool=false, use_scipy::Bool=true)
    # Initialize array with random entries
    if is_periodic
        A = randn(n_elem, n_elem)
        if pos_only
            if mode == "abs"
                A = abs.(A)
                A = gauß_filter(A, (σ1, σ2), "circular", use_scipy)
            elseif mode == "exp"
                A = gauß_filter(A, (σ1, σ2), "circular", use_scipy)
                A = exp.(A)
            else
              
                A = gauß_filter(A, (σ1, σ2), "circular", use_scipy)
            end
            A .+=  -minimum(A)+ min_val
        else
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

    A = gauß_filter(A, (σ1, σ2), "circular", use_scipy)
else
    A = randn(3*n_elem, 3*n_elem)

    A = gauß_filter(A, (σ1, σ2), "replicate", use_scipy)
    A = A[n_elem+1:2*n_elem,n_elem+1:2*n_elem]
end
for i in eachindex(A)
    A[i] = A[i] > threshold ? a : b
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