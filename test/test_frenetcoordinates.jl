using Test
using SmoothCurves


for α=0:0.2:2π, β=0:0.2:2π
    p0 = Pose(-2, 3, α)
    p1 = Pose(1, 2, β)

    C = LineSegment([-2, 3], [-2, 3] + [cos(α), sin(α)])
    @test SmoothCurves.pose(C, 0).x ≈ p0.x
    @test SmoothCurves.pose(C, 0).y ≈ p0.y
    @test SmoothCurves.pose(C, 0).phi ≈ SmoothCurves.normalize_angle(p0.phi)

    f_a = frenet.coordinates(p0, p1)
    f_b = frenet.coordinates(C, 0, p1)

    @test f_a.x ≈ 3*cos(α) - 1*sin(α)
    @test f_a.y ≈ -3*sin(α) - 1*cos(α)
    @test f_a.phi ≈ SmoothCurves.normalize_angle(β-α)

    @test f_a.x ≈ f_b.x
    @test f_a.y ≈ f_b.y
    @test f_a.phi ≈ f_b.phi
end
