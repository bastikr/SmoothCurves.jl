module SmoothCurves

export curves, Line, Arc, Clothoid, PolyCurve, Pose, Control,
       controllers


module curves
    include("curve.jl")
    include("geometry.jl")
    include("polycurve.jl")
    include("line.jl")
    include("arc.jl")
    include("clothoid.jl")
end

using .curves: Line, Arc, Clothoid, PolyCurve, Pose


include("dynamics.jl")
include("control.jl")

module controllers
    using ..curves, ..Control
    using ..curves: Pose

    include("controller_rio.jl")
end

using .controllers

include("plotrecipes.jl")

end
