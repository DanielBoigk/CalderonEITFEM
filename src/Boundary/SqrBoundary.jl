
export square_to_boundary, boundary_to_square

export Gradient_to_Normal, sqr_boundary_coordinates

# Maybe do it such that it also can use a function as an argument. It already intercepts the error with wrong size of input array by creating a 2x2 array of smaller size.
function boundary_to_square(boundary::Vector{Float64},n::Int=0)
    if n==0 
        size_n = size(boundary)[1] 
        n = (size_n+4)÷4
        if mod(size_n,4)≠0
            println("Warning: Given array has wrong size. information might be omitted")
        end        
    end
    G_boundary = zeros((n,n))

    G_boundary[1, 1:n] = boundary[1:n]

    # Right boundary
    G_boundary[1:n, n] = boundary[n:2*n-1]

    # Bottom boundary (reversing the order for correct orientation)
    G_boundary[n, n:-1:1] = boundary[2*n-1:3*n-2]
  
    # Left boundary (needs to assign values in reverse to align correctly)
    G_boundary[n:-1:2, 1] = boundary[3*n-2:4*n-4]
    return G_boundary
end



# This function does the exact opposite:
function square_to_boundary(Sqr::Matrix{Float64},n::Int=0, m::Int=0)
    if n==0 || m==0 
        n = size(Sqr)[1]
        m = size(Sqr)[2]
    end
    boundary = zeros(2*n+2*m-4)

    boundary[1:n] = Sqr[1, 1:n]

    # Right boundary
    boundary[n:n+m-1] = Sqr[1:m, n] 
    
    # Bottom boundary (reversing the order for correct orientation)
    boundary[n+m:n+m+n-2] = Sqr[m, n-1:-1:1]
 
    # Left boundary (needs to assign values in reverse to align correctly)
    boundary[n+m+n-1:2*n+2*m-4] = Sqr[m-1:-1:2, 1]
    return boundary
end

#Given the Gradient (as a matrix) this will create Neumann Boundary like values and return a matrix

function Gradient_to_Normal(G::Array{Float64, 3})
    n = size(G)[1]
    m = size(G)[2]

    Out = zeros(n,m)

    Out[2:n-1,1] = -G[2:n-1,1,2]
    Out[2:n-1,m] = G[2:n-1,m,2]

    Out[1, 2:m-1] = -G[1, 2:m-1,1]
    Out[n, 2:m-1] = G[n, 2:m-1,1]
    #This is slightly incorrect, but I'm lazy:
    Out[1,1] = 0.5*(-G[1,1,2]-G[1, 1,1])
    Out[1,m] = 0.5*( G[1,m,2]-G[1, m,1])
    Out[n,1] = 0.5*(-G[n,1,2]+G[n, 1,1])
    Out[n,m] = 0.5*( G[n,m,2]+G[n, m,1])
    return Out
end


# Will produce array with the coordinates along the square boundary.
function sqr_boundary_coordinates(x_dim::Int64=100,y_dim::Int64=100)
    x = ((1:x_dim) .- 1)/(x_dim - 1)
    y = ((1:y_dim) .- 1)/(y_dim - 1)
    x0 = result = [[x[i], 0.0] for i in 1:length(x)]
    x1 = result = [[x[i], 1.0] for i in 1:length(x)]
    y0 = result = [[0.0, y[i]] for i in 1:length(y)]
    y1 = result = [[1.0, y[i]] for i in 1:length(y)]
    return vcat(y0[1:(y_dim-1)], x1[1:(x_dim-1)], reverse(y1), reverse(x0)[2:(x_dim-1)] )
end