using Base.Test
using SmoothCurves


struct TestCurve <: Curve end

C = TestCurve()
s = 0.5

@test_throws ErrorException smax(C)
@test_throws ErrorException length(C, s)
@test_throws ErrorException length(C)
@test_throws ErrorException dlength(C, s)
@test_throws ErrorException tangentangle(C, s)
@test_throws ErrorException radialangle(C, s)
@test_throws ErrorException curvature(C, s)
@test_throws ErrorException dcurvature(C, s)
@test_throws ErrorException point(C, s)
@test_throws ErrorException dpoint(C, s)
@test_throws ErrorException startpoint(C)
@test_throws ErrorException endpoint(C)
