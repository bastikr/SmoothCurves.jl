using Base.Test
using SmoothCurves


include("curvefunctions_testsuite.jl")


origin = [1.7, -6.3]
r = 0.5

for ϕ0=0:0.1:2π, ϕ1=0:0.1:2π
    if ϕ0==ϕ1
        continue
    end
    C = Arc(origin, r, ϕ0, ϕ1)

    test_curvefunctions(C)
end
