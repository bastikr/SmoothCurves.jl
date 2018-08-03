module SmoothCurves

export Curve, LineSegment, ArcSegment, Clothoid, PolyCurve,
       smax, length, dlength,
       tangentangle, radialangle,
       curvature, dcurvature,
       point, dpoint, startpoint, endpoint,
       direction


include("curve.jl")
include("geometry.jl")
include("polycurve.jl")
include("linesegment.jl")
include("arcsegment.jl")
include("clothoid.jl")
include("construction.jl")

include("plotrecipes.jl")

end
