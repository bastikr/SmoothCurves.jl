using Base.Test
using SmoothCurves


function Fcos(λ::Float64, s::Float64)
    return QuadGK.quadgk(x->cos(λ*x^2), 0., s)[1]::Float64
end

function Fsin(λ::Float64, s::Float64)
    return QuadGK.quadgk(x->sin(λ*x^2), 0., s)[1]::Float64
end

θmax = π/2

for λ in -5:0.5:5
    s = sqrt(θmax/max(0.1, abs(λ)))
    @test SmoothCurves.fresnel(λ, s)[1] ≈ Fcos(λ, s)
    @test SmoothCurves.fresnel(λ, s)[2] ≈ Fsin(λ, s)
end

include("curvefunctions_testsuite.jl")

λ = 0.5
r = 5
pc = [1.7, -6.3]

δmin = π/8
Δ = π/8

for α=0:Δ:2π, δ=δmin:Δ:2π-δmin
    if δ ≈ π
        continue
    end
    β = α + δ
    p0 = pc + r*[cos(α), sin(α)]
    p2 = pc + r*[cos(β), sin(β)]
    C0, C1 = SmoothCurves.construction.clothoidcorner(1.2, p0, pc, p2).curves

    test_curvefunctions(C0)
    test_curvefunctions(C1)
end
