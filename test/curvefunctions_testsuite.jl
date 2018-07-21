using Base.Test
using SmoothCurves

using FDM


function test_curvefunctions(C::SmoothCurves.curves.Curve)
    d_ds = central_fdm(3, 1)

    point(s) = SmoothCurves.curves.point(C, s)
    dpoint(s) = SmoothCurves.curves.dpoint(C, s)
    l(s) = SmoothCurves.curves.l(C, s)
    dl(s) = SmoothCurves.curves.dl(C, s)
    θ(s) = SmoothCurves.curves.θ(C, s)
    curvature(s) = SmoothCurves.curves.curvature(C, s)
    dcurvature(s) = SmoothCurves.curves.dcurvature(C, s)

    Δs = length(C)/10
    for s=0:Δs:length(C)
        # Test dp/ds
        @test dpoint(s) ≈ d_ds(point, s) atol=1e-15

        # Test l
        @test d_ds(l, s) ≈ norm(dpoint(s))

        # Test dl/ds
        @test dl(s) ≈ d_ds(l, s)

        # Test θ
        @test cos(θ(s)) ≈ dpoint(s)[1]/dl(s) atol=1e-15
        @test sin(θ(s)) ≈ dpoint(s)[2]/dl(s) atol=1e-15

        # Test curvature
        t = dpoint(s)/dl(s)
        t′ = d_ds(dpoint, s)/dl(s)^2
        u_n = [-t[2], t[1]]
        k = dot(u_n, t′)
        @test curvature(s) ≈ k atol=1e-15

        # Test dcurvature
        @test dcurvature(s) ≈ d_ds(curvature, s) atol=1e-15
    end
end