import Base.length

using QuadGK
using StaticArrays: SVector


struct Clothoid <: Curve
    l0::Float64
    l1::Float64
    λ::Float64
    shift::Float64
    rotation::Float64
    origin::SVector{2, Float64}
end

length(C::Clothoid) = C.l1 - C.l0

l(C::Clothoid, s::Real) = C.l0 + s
dl(C::Clothoid, s::Real) = 1.
θ(C::Clothoid, s::Real) = normalize_angle(C.rotation + C.λ*l(C, s)^2)
curvature(C::Clothoid, s::Real) = 2*C.λ*l(C, s)
dcurvature(C::Clothoid, s::Real) = 2*C.λ

function smax_from_deviation(λ, dphi)
    sqrt(abs(dphi/(2*λ)))
end

function clothoid_in_standardorientation(λ::Real, s::Real)
    value_cos, err = QuadGK.quadgk(x->cos(λ*x^2), 0., s)
    value_sin, err = QuadGK.quadgk(x->sin(λ*x^2), 0., s)
    return [value_cos, value_sin]
end

function Fcos(λ::Float64, s::Float64)
    return QuadGK.quadgk(x->cos(λ*x^2), 0., s)[1]::Float64
end

function Fsin(λ::Float64, s::Float64)
    return QuadGK.quadgk(x->sin(λ*x^2), 0., s)[1]::Float64
end

function Fresnel(λ::Real, s::Real)
    function f(x::Float64)
        t = λ*x^2
        SVector(cos(t), sin(t))
    end
    return QuadGK.quadgk(f, 0., s)[1]::SVector{2, Float64}
end

function point(C::Clothoid, s::Real)
    p = Fresnel(C.λ, l(C, s))::SVector{2, Float64}
    p_r = rotate2d(C.rotation, p[1] - C.shift, p[2])
    return p_r + C.origin
    return SVector(p_r[1]+C.origin[1], p_r[2]+C.origin[2])
end

function dpoint(C::Clothoid, s::Real)
    l_ = l(C, s)
    dx = cos(C.λ*l_^2)
    dy = sin(C.λ*l_^2)
    dx_r, dy_r = rotate2d(C.rotation, dx, dy)
    return [dx_r, dy_r]
end

function construct_clothoids(λ::Real, p0, v0, v1)
    v0_ = SVector{2}(normalize(v0))
    v1_ = SVector{2}(normalize(v1))
    λ = abs(λ)
    dphi = deviation(v0_, v1_)
    phi0 = deviation(v0_, [1, 0])
    phi1 = deviation(v1_, [1, 0])
    lmax = smax_from_deviation(λ, abs(dphi))
    xmax, ymax = clothoid_in_standardorientation(λ, lmax)

    shift = xmax + ymax*tan(abs(dphi)/2)
    C0 = Clothoid(0, lmax, sign(dphi)*λ, shift, -phi0, p0)

    shift = xmax + ymax*tan(abs(dphi)/2)
    C1 = Clothoid(-lmax, 0, -sign(dphi)*λ, -shift, -phi1, p0)
    return C0, C1
end


function construct_clothoids2(dmax::Real, p0, p1, p2)
    v0_ = SVector{2}(normalize(p1-p0))
    v1_ = SVector{2}(normalize(p2-p1))

    dphi = deviation(v0_, v1_)
    phi0 = deviation(v0_, [1, 0])
    phi1 = deviation(v1_, [1, 0])

    θ = abs(dphi/2)
    Fsin(s) = QuadGK.quadgk(x->sin(x^2), 0., s)[1]
    g = cos(θ)*sqrt(θ)/Fsin(sqrt(θ))
    d = sin(2*θ)^(3./2)

    smax = dmax*d*g
    λ = θ/smax^2

    xmax, ymax = clothoid_in_standardorientation(λ, smax)

    shift = xmax + ymax*tan(abs(dphi)/2)
    C0 = Clothoid(0, smax, sign(dphi)*λ, shift, -phi0, p1)

    shift = xmax + ymax*tan(abs(dphi)/2)
    C1 = Clothoid(-smax, 0, -sign(dphi)*λ, -shift, -phi1, p1)
    return C0, C1
end
