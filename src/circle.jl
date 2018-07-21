import Base.length
import Base.sign

using StaticArrays: SVector


struct Arc <: Curve
    origin::SVector{2, Float64}
    radius::Float64
    angle0::Float64
    angle1::Float64
end

sign(C::Arc) = sign(C.angle1 - C.angle0)
ϕ(C::Arc, Δϕ::Real) = C.angle0 + sign(C)*Δϕ

smax(C::Arc) = abs(C.angle1 - C.angle0)

θ(C::Arc, Δϕ::Real) = normalize_angle(ϕ(C, Δϕ) + sign(C)*π/2)
l(C::Arc, Δϕ::Real) = C.radius*Δϕ
Base.length(C::Arc) = l(C, smax(C))

dl(C::Arc, Δϕ::Real) = C.radius

curvature(C::Arc, Δϕ::Real) = sign(C)/C.radius
dcurvature(C::Arc, Δϕ::Real) = 0.

function point(C::Arc, Δϕ::Real)
    ϕ_ = ϕ(C, Δϕ)
    C.origin + C.radius*SVector(cos(ϕ_), sin(ϕ_))
end

function dpoint(C::Arc, Δϕ::Real)
    ϕ_ = ϕ(C, Δϕ)
    C.radius*sign(C)*SVector(-sin(ϕ_), cos(ϕ_))
end
