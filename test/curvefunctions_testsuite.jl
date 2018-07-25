using Base.Test
import SmoothCurves

using FDM


function test_curvefunctions(C::SmoothCurves.Curve)
    l = SmoothCurves.length(C)
    @test l >= 0
    @test l == SmoothCurves.length(C, SmoothCurves.smax(C))
    @test 0 == SmoothCurves.length(C, 0.)

    d_ds = central_fdm(3, 1)

    point(s) = SmoothCurves.point(C, s)
    dpoint(s) = SmoothCurves.dpoint(C, s)
    length(s) = SmoothCurves.length(C, s)
    dlength(s) = SmoothCurves.dlength(C, s)
    tangentangle(s) = SmoothCurves.tangentangle(C, s)
    curvature(s) = SmoothCurves.curvature(C, s)
    dcurvature(s) = SmoothCurves.dcurvature(C, s)

    Δs = SmoothCurves.smax(C)/10
    for s=0:Δs:smax(C)
        # Test dp/ds
        @test dpoint(s) ≈ d_ds(point, s) atol=1e-12

        # Test l
        @test d_ds(length, s) ≈ norm(dpoint(s))

        # Test dl/ds
        @test dlength(s) ≈ d_ds(length, s)

        # Test tangentangle
        @test cos(tangentangle(s)) ≈ dpoint(s)[1]/dlength(s) atol=1e-12
        @test sin(tangentangle(s)) ≈ dpoint(s)[2]/dlength(s) atol=1e-12

        # Test curvature
        t = dpoint(s)/dlength(s)
        t′ = d_ds(dpoint, s)/dlength(s)^2
        u_n = [-t[2], t[1]]
        k = dot(u_n, t′)
        @test curvature(s) ≈ k atol=1e-12

        # Test dcurvature
        @test dcurvature(s) ≈ d_ds(curvature, s) atol=1e-12
    end
end