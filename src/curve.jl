import Base.length


using StaticArrays

abstract type Curve end

Point = StaticArrays.SVector


struct Pose
    x::Float64
    y::Float64
    phi::Float64
end

function pose(C::Curve, l::Float64)
    x, y = point(C, l)
    phi = θ(C, l)
    return Pose(x, y, phi)
end

x(p::Point) = p[1]
y(p::Point) = p[2]

x(p::Pose) = p.x
y(p::Pose) = p.y
phi(p::Pose) = p.phi
