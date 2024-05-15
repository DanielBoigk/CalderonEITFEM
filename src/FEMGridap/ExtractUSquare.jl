export extract_U_square

function extract_U(uh, x_dim::Int64=100, y_dim::Int64=100)
    x_range = range(0.0, stop=1.0, length=x_dim)
    y_range = range(0.0, stop=1.0, length=y_dim)
    grid_points = [Point((x, y)) for x in x_range, y in y_range]
    # This is the really really bad part:
    @time begin
    Grid_U = uh.(grid_points)
    end
    G = [Grid_U[x,y] for x in 1:x_dim, y in 1:y_dim]
    return G
end

function extract_U_square(uh,x_dim::Int64=100,y_dim::Int64=100, ; mode = "dirichlet", l_order::Int64=1 )
    if l_order==1
        if mode == "dirichlet"
            S = copy(uh.free_values)
            #I don't want this thing to be somewhere completely outside:
            S .-= Statistics.mean(S)
            S = reshape(S, (x_dim,y_dim))
            return S
        else
            # Extract Matrix Valued solution:
            Out = zeros(x_dim,y_dim)
            S = copy(uh.free_values)
    
            S = reshape(S, (x_dim-2,y_dim-2))
            Out[2:x_dim-1,2:x_dim-1]= S
        return Out
        end
    end
    return extract_U(uh,x_dim,y_dim)
end