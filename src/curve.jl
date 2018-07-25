import Base: length


using StaticArrays

abstract type Curve end

Point = StaticArrays.SVector


smax(C::Curve) = error("Not Implemented")
length(C::Curve, s::Real) = error("Not Implemented")
length(C::Curve) = length(C::Curve, smax(C))
dlength(C::Curve, s::Real) = error("Not Implemented")

tangentangle(C::Curve, s::Real) = error("Not Implemented")

curvature(C::Curve, s::Real) = error("Not Implemented")
dcurvature(C::Curve, s::Real) = error("Not Implemented")
point(C::Curve, s::Real) = error("Not Implemented")
dpoint(C::Curve, s::Real) = error("Not Implemented")


struct Pose
    x::Float64
    y::Float64
    phi::Float64
end

function pose(C::Curve, l::Float64)
    x, y = point(C, l)
    phi = tangentangle(C, l)
    return Pose(x, y, phi)
end

x(p::Point) = p[1]
y(p::Point) = p[2]

x(p::Pose) = p.x
y(p::Pose) = p.y
phi(p::Pose) = p.phi
