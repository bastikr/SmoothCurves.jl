using Base.Test
using SmoothCurves

using FDM


function test_curvefunctions(C::curves.Curve)
    d_ds = central_fdm(3, 1)

    point(s) = curves.point(C, s)
    dpoint(s) = curves.dpoint(C, s)
    l(s) = curves.l(C, s)
    dl(s) = curves.dl(C, s)
    θ(s) = curves.θ(C, s)
    curvature(s) = curves.curvature(C, s)
    dcurvature(s) = curves.dcurvature(C, s)

    Δs = curves.smax(C)/10
    for s=0:Δs:curves.smax(C)
        # Test dp/ds
        @test dpoint(s) ≈ d_ds(point, s) atol=1e-12

        # Test l
        @test d_ds(l, s) ≈ norm(dpoint(s))

        # Test dl/ds
        @test dl(s) ≈ d_ds(l, s)

        # Test θ
        @test cos(θ(s)) ≈ dpoint(s)[1]/dl(s) atol=1e-12
        @test sin(θ(s)) ≈ dpoint(s)[2]/dl(s) atol=1e-12

        # Test curvature
        t = dpoint(s)/dl(s)
        t′ = d_ds(dpoint, s)/dl(s)^2
        u_n = [-t[2], t[1]]
        k = dot(u_n, t′)
        @test curvature(s) ≈ k atol=1e-12

        # Test dcurvature
        @test dcurvature(s) ≈ d_ds(curvature, s) atol=1e-12
    end
end