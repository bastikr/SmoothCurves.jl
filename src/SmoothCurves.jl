module SmoothCurves


module curves
    include("curve.jl")
    include("geometry.jl")
    include("polycurve.jl")
    include("line.jl")
    include("clothoid.jl")
end

using .curves: Pose


include("control.jl")

module controllers
    using ..curves, ..Control
    using ..curves: Pose

    include("controller_rio.jl")
end

include("plotrecipes.jl")

end
