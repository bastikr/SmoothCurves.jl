import Base: length, sign

using StaticArrays: SVector

"""
    ArcSegment(origin, radius, angle0, angle1)

ArcSegment centered at `origin` with the given `radius` going from the first to the
second angle. As parametrization the angle difference to the starting angle is
used.
"""
struct ArcSegment <: Curve
    origin::SVector{2, Float64}
    radius::Float64
    angle0::Float64
    angle1::Float64
end


# Special ArcSegment specific functions
"""
    sign(C::ArcSegment)

Sign of the curvature of the ArcSegment.
"""
sign(C::ArcSegment) = sign(C.angle1 - C.angle0)


# Implement Curve interface
smax(C::ArcSegment) = abs(C.angle1 - C.angle0)

length(C::ArcSegment, Δϕ::Real) = C.radius*Δϕ
dlength(C::ArcSegment, Δϕ::Real) = C.radius

tangentangle(C::ArcSegment, Δϕ::Real) = normalize_angle(radialangle(C, Δϕ) + sign(C)*π/2)
radialangle(C::ArcSegment, Δϕ::Real) = C.angle0 + sign(C)*Δϕ

curvature(C::ArcSegment) = sign(C)/C.radius
curvature(C::ArcSegment, Δϕ::Real) = curvature(C)
dcurvature(C::ArcSegment, Δϕ::Real) = 0.

function point(C::ArcSegment, Δϕ::Real)
    ϕ = radialangle(C, Δϕ)
    C.origin + C.radius*SVector{2, Float64}(cos(ϕ), sin(ϕ))
end

function dpoint(C::ArcSegment, Δϕ::Real)
    ϕ = radialangle(C, Δϕ)
    C.radius*sign(C)*SVector{2, Float64}(-sin(ϕ), cos(ϕ))
end
