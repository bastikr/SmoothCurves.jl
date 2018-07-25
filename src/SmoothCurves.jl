module SmoothCurves

export Curve, Line, Arc, Clothoid, PolyCurve,
       smax, length, dlength,
       tangentangle,
       curvature, dcurvature,
       point, dpoint


include("curve.jl")
include("geometry.jl")
include("polycurve.jl")
include("line.jl")
include("arc.jl")
include("clothoid.jl")
include("construction.jl")

include("plotrecipes.jl")

end
