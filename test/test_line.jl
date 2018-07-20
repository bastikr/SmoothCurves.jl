using Base.Test
using SmoothCurves


include("curvefunctions_testsuite.jl")


origin = [1.7, -6.3]

for α=0:0.1:2π
    u = [cos(α), sin(α)]
    C = SmoothCurves.curves.Line(7.3, origin, u)

    test_curvefunctions(C)
end
