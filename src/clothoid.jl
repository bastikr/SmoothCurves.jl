import Base: length

using QuadGK
using StaticArrays: SVector

"""
    Clothoid(origin, shift, rotation, λ, l0, l1)

Describes a clothoid which in standard orientation.

It is here defined as

```math
x(s) = \\int_0^s \\cos(λ t^2) \\mathrm{d}t
\\
y(s) = \\int_0^s \\sin(λ t^2) \\mathrm{d}t
```

for parameter ``s ∈ [l0, l1]``. (Note that `l1` may also be smaller to `l0`).
It is placed at `origin`, shifted along the x-axis and rotated around the `origin` by
the given angle.
"""
struct Clothoid <: Curve
    origin::SVector{2, Float64}
    shift::Float64
    rotation::Float64
    λ::Float64
    l0::Float64
    l1::Float64
end


# Clothoid specific functions
"""
    l(C::Clothoid, s)

Signed distance to the origin of the Clothoid.
"""
standardlength(C::Clothoid, s::Real) = C.l0 + s


function fresnel_powerseries(λ::Real, s::Real)
    λ_ = convert(Float64, λ)
    θ = abs(λ_)*s^2
    if (θ<1e-16)
        return SVector(s, 0.)
    elseif (θ>π/2+0.01)
        throw(ArgumentError("θ=λ*s^2=$θ is not in [-π/2, π/2]."))
    end
    sqrt_λ = sqrt(abs(λ_))
    s_ = sqrt_λ*convert(Float64, s)
    s4 = s_^4

    cx0 =  1
    cx1 = -1/10
    cx2 =  1/216
    cx3 = -1/9360
    cx4 =  1/685440
    cx5 = -1/76204800
    cx6 =  1/11975040000
    cx7 = -1/2528170444800
    x = s_*(cx0 + s4*(cx1 + s4*(cx2 + s4*(cx3 + s4*(cx4 + s4*(cx5 + s4*(cx6 + s4*cx7)))))))

    cy0 =  1/3
    cy1 = -1/42
    cy2 =  1/1320
    cy3 = -1/75600
    cy4 =  1/6894720
    cy5 = -1/918086400
    cy6 =  1/168129561600
    cy7 = -1/40537905408000
    y = s_^3*(cy0 + s4*(cy1 + s4*(cy2 + s4*(cy3 + s4*(cy4 + s4*(cy5 + s4*(cy6 + s4*cy7)))))))

    return SVector(x/sqrt_λ, sign(λ_)*y/sqrt_λ)
end


function fresnel_numericintegration(λ::Real, s::Real)
    λ_ = convert(Float64, λ)
    s_ = convert(Float64, s)
    function f(x::Float64)
        t = λ_*x^2
        SVector{2, Float64}(cos(t), sin(t))
    end
    QuadGK.quadgk(f, 0., s_)[1]::SVector{2, Float64}
end

"""
    fresnel(λ, s)

Solve the generalized Fresnel integrals

```math
x(s) = \\int_0^s \\cos(λ t^2) \\mathrm{d}t
\\
y(s) = \\int_0^s \\sin(λ t^2) \\mathrm{d}t
```
"""
fresnel(λ::Real, s::Real) = fresnel_powerseries(λ, s)


# Implement Curve interface
smax(C::Clothoid) = C.l1 - C.l0

length_unchecked(C::Clothoid, s::Real) = s
dlength_unchecked(C::Clothoid, s::Real) = 1.

tangentangle_unchecked(C::Clothoid, s::Real) = normalize_angle(C.rotation + C.λ*standardlength(C, s)^2)
function radialangle_unchecked(C::Clothoid, s::Real)
    kappa = curvature(C, s)
    sign_ = kappa==0 ? 1 : sign(kappa)
    normalize_angle(C.rotation + C.λ*standardlength(C, s)^2 - sign_*π/2)
end

curvature_unchecked(C::Clothoid, s::Real) = 2*C.λ*standardlength(C, s)
dcurvature_unchecked(C::Clothoid, s::Real) = 2*C.λ

function point_unchecked(C::Clothoid, s::Real)
    p = fresnel(C.λ, standardlength(C, s))::SVector{2, Float64}
    p_r = rotate2d(C.rotation, p[1] - C.shift, p[2])::SVector{2, Float64}
    return p_r + C.origin
end

function dpoint_unchecked(C::Clothoid, s::Real)
    l_ = standardlength(C, s)
    dx = cos(C.λ*l_^2)
    dy = sin(C.λ*l_^2)
    return rotate2d(C.rotation, dx, dy)::SVector{2, Float64}
end
