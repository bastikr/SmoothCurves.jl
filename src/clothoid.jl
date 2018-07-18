import Base.length

using QuadGK: quadgk
using StaticArrays: SVector


struct Clothoid <: Curve
    l0::Float64
    l1::Float64
    λ::Float64
    shift::Float64
    rotation::Float64
    origin::SVector{2}
end

length(C::Clothoid) = C.l1 - C.l0


function smax_from_deviation(λ, dphi)
    sqrt(abs(dphi/(2*λ)))
end

function evaluate(C, lvec::Vector{Float64})
    xvec = Float64[]
    yvec = Float64[]
    for l=lvec
        x, y = evaluate(C, l)
        push!(xvec, x)
        push!(yvec, y)
    end
    return xvec, yvec
end

function evaluate_angle(C, lvec::Vector{Float64})
    phivec = Float64[]
    for l=lvec
        phi = evaluate_angle(C, l)
        push!(phivec, phi)
    end
    return phivec
end

function normalizedclothoid(λ::Float64, s::Float64)
    value_cos, err = quadgk(x::Float64->cos(λ*x^2), 0., s)
    value_sin, err = quadgk(x::Float64->sin(λ*x^2), 0., s)
    return [value_cos, value_sin]
end

function evaluate(C::Clothoid, l::Float64)
    x, y = normalizedclothoid(C.λ, C.l0 + l)
    x -= C.shift
    x_r, y_r = rotate2d(C.rotation, x, y)
    return x_r+C.origin[1], y_r+C.origin[2]
end

function evaluate_angle(C::Clothoid, l::Float64)
    l_ = C.l0 + l
    dx = cos(C.λ*l_^2)
    dy = sin(C.λ*l_^2)
    dx_r, dy_r = rotate2d(C.rotation, dx, dy)
    atan2(dy_r, dx_r)
end


function construct_clothoids(λ, p0, v0, v1)
    v0_ = SVector{2}(normalize(v0))
    v1_ = SVector{2}(normalize(v1))
    λ = abs(λ)
    dphi = deviation(v0_, v1_)
    phi0 = deviation(v0_, [1, 0])
    phi1 = deviation(v1_, [1, 0])
    lmax = smax_from_deviation(λ, abs(dphi))
    xmax, ymax = normalizedclothoid(λ, lmax)
    shift = xmax + ymax*tan(abs(dphi)/2)
    C0 = Clothoid(0, lmax, sign(dphi)*λ, shift, -phi0, p0)

    shift = xmax + ymax*tan(abs(dphi)/2)
    C1 = Clothoid(-lmax, 0, -sign(dphi)*λ, -shift, -phi1, p0)
    return C0, C1
end
