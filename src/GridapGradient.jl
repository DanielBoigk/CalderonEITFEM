# It is quite complicated to extract the gradient from a Gridap solution. 
#I will do that here:

#export Gradient_to_Normal #, gen_EIT_training_sqr

#=
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

=#