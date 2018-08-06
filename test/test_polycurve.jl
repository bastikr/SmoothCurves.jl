using Base.Test
using SmoothCurves


include("curvefunctions_testsuite.jl")

begin
C_l0 = LineSegment([1, 2], [4.2, 2])
C_l1 = LineSegment([4.2, 2], [4.2, 4.4])
C_l2 = LineSegment([4.2, 4.4], [1.6, 7])
C = PolyCurve(C_l0, C_l1, C_l2)

@test SmoothCurves.subcurveindex(C, -1.) == 1
@test SmoothCurves.subcurveindex(C, 3.) == 1
@test SmoothCurves.subcurveindex(C, 5.) == 2
@test SmoothCurves.subcurveindex(C, 7.) == 3
@test SmoothCurves.subcurveindex(C, 9.) == 3

@test SmoothCurves.subcurveparameter(C, -1.) ≈ -1
@test SmoothCurves.subcurveparameter(C, 3.) ≈ 3
@test SmoothCurves.subcurveparameter(C, 5.) ≈ 1.8
@test SmoothCurves.subcurveparameter(C, 7.) ≈ 1.4
@test SmoothCurves.subcurveparameter(C, 9.) ≈ 3.4

@test smax(C) == smax(C_l0) + smax(C_l1) + smax(C_l2)
@test length(C) == length(C_l0) + length(C_l1) + length(C_l2)
@test length(C, smax(C)) == length(C)
end

C_arc = ArcSegment([1, 3], 2., 0., π)
C = SmoothCurves.construction.curve(0.5, [[-1, 3], [-1, -6], [1, -6]])
C = PolyCurve(C_arc, C.curves...)

test_curvefunctions(C)
