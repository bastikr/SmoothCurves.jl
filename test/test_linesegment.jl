using Test
using SmoothCurves

begin
l = LineSegment([1, 2], [4, 6])
@test point(l, 0) == [1, 2]
@test point(l, smax(l)) == [4, 6]
@test length(l) ≈ 5
@test samples(l, 0.1) ≈ [0., smax(l)]
end

include("curvefunctions_testsuite.jl")

p0 = [1.7, -6.3]
L = 7.3

for α=0:0.1:2π
    u = [cos(α), sin(α)]
    C = LineSegment(p0, p0+L*u)

    test_curvefunctions(C)
end
