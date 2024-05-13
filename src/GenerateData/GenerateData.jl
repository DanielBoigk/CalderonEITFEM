
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


    

include("Boundary2D.jl")
include("Domain2D.jl")
include("Domain3D.jl")

