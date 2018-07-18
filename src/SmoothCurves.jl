module SmoothCurves


module curves
    include("geometry.jl")
    include("curve.jl")
    include("polycurve.jl")
    include("line.jl")
    include("clothoid.jl")
end

include("pose.jl")
include("control.jl")

module controllers
    using ..curves, ..Pose, ..Control

    include("controller_rio.jl")
end

include("plotrecipes.jl")

end
