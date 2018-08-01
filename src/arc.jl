import Base: length, sign

using StaticArrays: SVector

"""
    Arc(origin, radius, angle0, angle1)

Arc centered at `origin` with the given `radius` going from the first to the
second angle. As parametrization the angle difference to the starting angle is
used.
"""
struct Arc <: Curve
    origin::SVector{2, Float64}
    radius::Float64
    angle0::Float64
    angle1::Float64
end


# Special Arc specific functions
"""
    sign(C::Arc)

Sign of the curvature of the Arc.
"""
sign(C::Arc) = sign(C.angle1 - C.angle0)
arcangle(C::Arc, Δϕ::Real) = C.angle0 + sign(C)*Δϕ


# Implement Curve interface
smax(C::Arc) = abs(C.angle1 - C.angle0)

length(C::Arc, Δϕ::Real) = C.radius*Δϕ
dlength(C::Arc, Δϕ::Real) = C.radius

tangentangle(C::Arc, Δϕ::Real) = normalize_angle(arcangle(C, Δϕ) + sign(C)*π/2)

curvature(C::Arc) = sign(C)/C.radius
curvature(C::Arc, Δϕ::Real) = curvature(C)
dcurvature(C::Arc, Δϕ::Real) = 0.

function point(C::Arc, Δϕ::Real)
    ϕ = arcangle(C, Δϕ)
    C.origin + C.radius*SVector{2, Float64}(cos(ϕ), sin(ϕ))
end

function dpoint(C::Arc, Δϕ::Real)
    ϕ = arcangle(C, Δϕ)
    C.radius*sign(C)*SVector{2, Float64}(-sin(ϕ), cos(ϕ))
end
