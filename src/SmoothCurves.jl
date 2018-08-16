module SmoothCurves

export Curve, Pose, LineSegment, ArcSegment, Clothoid, PolyCurve,
       smax, length, dlength,
       length_unchecked, dlength_unchecked,
       tangentangle, radialangle,
       tangentangle_unchecked, radialangle_unchecked,
       curvature, dcurvature,
       curvature_unchecked, dcurvature_unchecked,
       point, dpoint, startpoint, endpoint,
       point_unchecked, dpoint_unchecked,
       direction,
       frenet,
       construction


include("curve.jl")
include("geometry.jl")
include("polycurve.jl")
include("linesegment.jl")
include("arcsegment.jl")
include("clothoid.jl")
include("frenet_coordinates.jl")
include("construction.jl")

include("plotrecipes.jl")

end
