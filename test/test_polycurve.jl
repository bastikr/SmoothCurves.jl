using Base.Test
using SmoothCurves


include("curvefunctions_testsuite.jl")

C_arc = Arc([1, 3], 2., 0., π)
C = SmoothCurves.construct_curve2(0.5, [-1, 3], [-1, -6], [1, -6])
C = PolyCurve(C_arc, C.curves...)

test_curvefunctions(C)
