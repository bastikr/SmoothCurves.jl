using Base.Test
using SmoothCurves


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
