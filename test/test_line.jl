using Base.Test
using SmoothCurves


include("curvefunctions_testsuite.jl")


origin = [1.7, -6.3]
L = 7.3

for α=0:0.1:2π
    u = [cos(α), sin(α)]
    C = Line(origin, u, L)

    test_curvefunctions(C)
end
