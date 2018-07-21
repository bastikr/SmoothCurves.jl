import Base.length
import Base.sign

using StaticArrays: SVector


struct Arc <: Curve
    phi0::Float64
    phi1::Float64
    r::Float64
    origin::SVector{2}
end

sign(C::Arc) = sign(C.phi1 - C.phi0)
ϕ(C::Arc, Δϕ::Real) = C.phi0 + sign(C)*Δϕ

Base.length(C::Arc) = C.r*abs(C.phi1 - C.phi0)
smax(C::Arc) = abs(C.phi1 - C.phi0)
θ(C::Arc, Δϕ::Real) = normalize_angle(ϕ(C, Δϕ) + sign(C)*π/2)
l(C::Arc, Δϕ::Real) = C.r*Δϕ


dl(C::Arc, Δϕ::Real) = C.r

curvature(C::Arc, Δϕ::Real) = sign(C)*1./C.r
dcurvature(C::Arc, Δϕ::Real) = 0.

function point(C::Arc, Δϕ::Real)
    ϕ_ = ϕ(C, Δϕ)
    C.origin + C.r*SVector(cos(ϕ_), sin(ϕ_))
end

function dpoint(C::Arc, Δϕ::Real)
    ϕ_ = ϕ(C, Δϕ)
    C.r*sign(C)*SVector(-sin(ϕ_), cos(ϕ_))
end
