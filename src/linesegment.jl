import Base: length

using StaticArrays: SVector


struct LineSegment <: Curve
    p0::SVector{2, Float64}
    p1::SVector{2, Float64}
end

direction(C::LineSegment) = normalize(C.p1 - C.p0)


# Implement Curve interface
smax(C::LineSegment) = norm(C.p1 - C.p0)

length(C::LineSegment, s::Real) = s
dlength(C::LineSegment, s::Real) = 1.

function tangentangle(C::LineSegment, s::Real)
    direction = normalize(C.p1 - C.p0)
    atan2(direction[2], direction[1])
end
function radialangle(C::LineSegment, s::Real)
    direction = normalize(C.p1 - C.p0)
    atan2(-direction[1], direction[2])
end

curvature(C::LineSegment, s::Real) = 0.
dcurvature(C::LineSegment, s::Real) = 0.

function point(C::LineSegment, s::Real)
    r = s/smax(C)
    (1-r)*C.p0 + r*C.p1
end
dpoint(C::LineSegment, s::Real) = direction(C)
