using Test
using SmoothCurves
import SmoothCurves: smax


struct TestCurve <: Curve end

C = TestCurve()
s = 0.25

@test_throws ErrorException smax(C)
@test_throws ErrorException length_unchecked(C, s)
@test_throws ErrorException dlength_unchecked(C, s)
@test_throws ErrorException tangentangle_unchecked(C, s)
@test_throws ErrorException radialangle_unchecked(C, s)
@test_throws ErrorException curvature_unchecked(C, s)
@test_throws ErrorException dcurvature_unchecked(C, s)
@test_throws ErrorException point_unchecked(C, s)
@test_throws ErrorException dpoint_unchecked(C, s)


SmoothCurves.smax(C::TestCurve) = 0.5

s = 0.25
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
@test_throws ErrorException samples(C, 0.1)

s = 0.75
@test_throws ArgumentError length(C, s)
@test_throws ArgumentError dlength(C, s)
@test_throws ArgumentError tangentangle(C, s)
@test_throws ArgumentError radialangle(C, s)
@test_throws ArgumentError curvature(C, s)
@test_throws ArgumentError dcurvature(C, s)
@test_throws ArgumentError point(C, s)
@test_throws ArgumentError dpoint(C, s)
