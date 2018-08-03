using Base.Test
using SmoothCurves


function Fcos(λ::Float64, s::Float64)
    return QuadGK.quadgk(x->cos(λ*x^2), 0., s)[1]::Float64
end

function Fsin(λ::Float64, s::Float64)
    return QuadGK.quadgk(x->sin(λ*x^2), 0., s)[1]::Float64
end

for λ in -5:0.5:5
    @test SmoothCurves.fresnel(λ, 2.)[1] ≈ Fcos(λ, 2.)
    @test SmoothCurves.fresnel(λ, 2.)[2] ≈ Fsin(λ, 2.)
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
    C0, C1 = SmoothCurves.construct_clothoids2(1.0, p0, pc, p2)

    test_curvefunctions(C0)
    test_curvefunctions(C1)
end
