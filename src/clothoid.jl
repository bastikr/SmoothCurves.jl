import Base: length

using QuadGK
using StaticArrays: SVector


struct Clothoid <: Curve
    origin::SVector{2, Float64}
    shift::Float64
    rotation::Float64
    λ::Float64
    l0::Float64
    l1::Float64
end


# Clothoid specific functions
l(C::Clothoid, s::Real) = C.l0 + s

function Fresnel(λ::Float64, s::Real)
    function f(x::Float64)
        t = λ*x^2
        SVector{2, Float64}(cos(t), sin(t))
    end
    return QuadGK.quadgk(f, 0., s)[1]::SVector{2, Float64}
end

function smax_from_deviation(λ, dphi)
    sqrt(abs(dphi/(2*λ)))
end


# Implement Curve interface
smax(C::Clothoid) = C.l1 - C.l0

length(C::Clothoid, s::Real) = s
dlength(C::Clothoid, s::Real) = 1.

tangentangle(C::Clothoid, s::Real) = normalize_angle(C.rotation + C.λ*l(C, s)^2)

curvature(C::Clothoid, s::Real) = 2*C.λ*l(C, s)
dcurvature(C::Clothoid, s::Real) = 2*C.λ

function point(C::Clothoid, s::Real)
    p = Fresnel(C.λ, l(C, s))::SVector{2, Float64}
    p_r = rotate2d(C.rotation, p[1] - C.shift, p[2])::SVector{2, Float64}
    return p_r + C.origin
end

function dpoint(C::Clothoid, s::Real)
    l_ = l(C, s)
    dx = cos(C.λ*l_^2)
    dy = sin(C.λ*l_^2)
    return rotate2d(C.rotation, dx, dy)::SVector{2, Float64}
end
