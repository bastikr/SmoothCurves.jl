import Base: length

using QuadGK
using StaticArrays: SVector

doc"""
    Clothoid(origin, shift, rotation, λ, l0, l1)

Describes a clothoid which in standard orientation.

It is here defined as

```math
x(s) = \int_0^s \cos(λ t^2) \mathrm{d}t
\\
y(s) = \int_0^s \sin(λ t^2) \mathrm{d}t
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

doc"""
    Fresnel(λ, s)

Solve the generalized Fresnel integrals

```math
x(s) = \int_0^s \cos(λ t^2) \mathrm{d}t
\\
y(s) = \int_0^s \sin(λ t^2) \mathrm{d}t
```
"""
function Fresnel(λ::Real, s::Real)
    λ_ = convert(Float64, λ)
    s_ = convert(Float64, s)
    function f(x::Float64)
        t = λ_*x^2
        SVector{2, Float64}(cos(t), sin(t))
    end
    QuadGK.quadgk(f, 0., s_)[1]::SVector{2, Float64}
end

function smax_from_deviation(λ, dphi)
    sqrt(abs(dphi/(2*λ)))
end


# Implement Curve interface
smax(C::Clothoid) = C.l1 - C.l0

length(C::Clothoid, s::Real) = s
dlength(C::Clothoid, s::Real) = 1.

tangentangle(C::Clothoid, s::Real) = normalize_angle(C.rotation + C.λ*standardlength(C, s)^2)
function radialangle(C::Clothoid, s::Real)
    kappa = curvature(C, s)
    sign_ = kappa==0 ? 1 : sign(kappa)
    normalize_angle(C.rotation + C.λ*standardlength(C, s)^2 - sign_*π/2)
end

curvature(C::Clothoid, s::Real) = 2*C.λ*standardlength(C, s)
dcurvature(C::Clothoid, s::Real) = 2*C.λ

function point(C::Clothoid, s::Real)
    p = Fresnel(C.λ, standardlength(C, s))::SVector{2, Float64}
    p_r = rotate2d(C.rotation, p[1] - C.shift, p[2])::SVector{2, Float64}
    return p_r + C.origin
end

function dpoint(C::Clothoid, s::Real)
    l_ = standardlength(C, s)
    dx = cos(C.λ*l_^2)
    dy = sin(C.λ*l_^2)
    return rotate2d(C.rotation, dx, dy)::SVector{2, Float64}
end
