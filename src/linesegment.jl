import Base: length

using StaticArrays: SVector

"""
    LineSegment(p0, p1)

A line segment starting from `p0` and ending at `p1`. Besides the Curve
protocol, also a [`direction`](@ref) function is implemented, which
calculates the unit vector pointing from `p0` in direction of `p1`.
"""
struct LineSegment <: Curve
    p0::SVector{2, Float64}
    p1::SVector{2, Float64}
end

"""
    direction(C::LineSegment)

Returns the unitvector from the start point to the endpoint of the
line segment.
"""
direction(C::LineSegment) = normalize(C.p1 - C.p0)


# Implement Curve interface
smax(C::LineSegment) = norm(C.p1 - C.p0)

length_unchecked(C::LineSegment, s::Real) = s
dlength_unchecked(C::LineSegment, s::Real) = 1.

function tangentangle_unchecked(C::LineSegment, s::Real)
    direction = normalize(C.p1 - C.p0)
    atan2(direction[2], direction[1])
end
function radialangle_unchecked(C::LineSegment, s::Real)
    direction = normalize(C.p1 - C.p0)
    atan2(-direction[1], direction[2])
end

curvature_unchecked(C::LineSegment, s::Real) = 0.
dcurvature_unchecked(C::LineSegment, s::Real) = 0.

function point_unchecked(C::LineSegment, s::Real)
    r = s/smax(C)
    (1-r)*C.p0 + r*C.p1
end
dpoint_unchecked(C::LineSegment, s::Real) = direction(C)

startpoint(C::LineSegment) = C.p0
endpoint(C::LineSegment) = C.p1
