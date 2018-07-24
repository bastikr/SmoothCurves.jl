import Base.length
import Base.sign

using StaticArrays: SVector


struct Arc <: Curve
    origin::SVector{2, Float64}
    radius::Float64
    angle0::Float64
    angle1::Float64
end


# Special Arc specific functions
sign(C::Arc) = sign(C.angle1 - C.angle0)
arcangle(C::Arc, Δϕ::Real) = C.angle0 + sign(C)*Δϕ


# Implement Curve interface
smax(C::Arc) = abs(C.angle1 - C.angle0)

l(C::Arc, Δϕ::Real) = C.radius*Δϕ
length(C::Arc) = l(C, smax(C))
dl(C::Arc, Δϕ::Real) = C.radius

θ(C::Arc, Δϕ::Real) = normalize_angle(arcangle(C, Δϕ) + sign(C)*π/2)

curvature(C::Arc) = sign(C)/C.radius
curvature(C::Arc, Δϕ::Real) = curvature(C)
dcurvature(C::Arc, Δϕ::Real) = 0.

function point(C::Arc, Δϕ::Real)
    ϕ_ = arcangle(C, Δϕ)
    C.origin + C.radius*SVector{2, Float64}(cos(ϕ_), sin(ϕ_))
end

function dpoint(C::Arc, Δϕ::Real)
    ϕ_ = arcangle(C, Δϕ)
    C.radius*sign(C)*SVector{2, Float64}(-sin(ϕ_), cos(ϕ_))
end
