using Base.Test
using SmoothCurves

using FDM


function test_curvefunctions(C::SmoothCurves.curves.Curve)
    d_ds = central_fdm(5, 1)

    point(s) = SmoothCurves.curves.point(C0, s)
    dpoint(s) = SmoothCurves.curves.dpoint(C0, s)
    l(s) = SmoothCurves.curves.l(C0, s)
    dl(s) = SmoothCurves.curves.dl(C0, s)
    θ(s) = SmoothCurves.curves.θ(C0, s)
    curvature(s) = SmoothCurves.curves.curvature(C0, s)
    dcurvature(s) = SmoothCurves.curves.dcurvature(C0, s)

    for s=0:0.1:length(C0)
        # Test dp/ds
        @test dpoint(s) ≈ d_ds(point, s)

        # Test l
        @test d_ds(l, s) ≈ norm(dpoint(s))

        # Test dl/ds
        @test dl(s) ≈ d_ds(l, s)

        # Test θ
        @test θ(s) ≈ atan2(dpoint(s)[2], dpoint(s)[1])

        # Test curvature
        t = dpoint(s)/dl(s)
        t′ = d_ds(dpoint, s)/dl(s)
        u_n = [-t[2], t[1]]
        k = dot(u_n, t′)
        @test curvature(s) ≈ k  atol=1e-10

        # Test dcurvature
        @test dcurvature(s) ≈ d_ds(curvature, s)
    end
end