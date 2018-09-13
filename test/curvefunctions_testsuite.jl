using Test
import SmoothCurves

using LinearAlgebra: norm, dot


function test_curvefunctions(C::SmoothCurves.Curve)
    l = SmoothCurves.length(C)
    @test l >= 0
    @test l == SmoothCurves.length(C, SmoothCurves.smax(C))
    @test 0 == SmoothCurves.length(C, 0.)
    @test SmoothCurves.startpoint(C) == SmoothCurves.point(C, 0)
    @test SmoothCurves.endpoint(C) == SmoothCurves.point(C, smax(C))

    d_ds_forward = forward_fdm(3, 1)
    d_ds_central = central_fdm(3, 1)
    d_ds_backward = backward_fdm(3, 1)

    point(s) = SmoothCurves.point(C, s)
    dpoint(s) = SmoothCurves.dpoint(C, s)
    length(s) = SmoothCurves.length(C, s)
    dlength(s) = SmoothCurves.dlength(C, s)
    tangentangle(s) = SmoothCurves.tangentangle(C, s)
    radialangle(s) = SmoothCurves.radialangle(C, s)
    curvature(s) = SmoothCurves.curvature(C, s)
    dcurvature(s) = SmoothCurves.dcurvature(C, s)

    for s=range(0, stop=smax(C), length=10)
        if abs(s)<0.01
            d_ds = d_ds_forward
        elseif abs(s-smax(C))<0.01
            d_ds = d_ds_backward
        else
            d_ds = d_ds_central
        end

        # Test dp/ds
        @test dpoint(s) ≈ d_ds(point, s) atol=1e-12

        # Test l
        @test d_ds(length, s) ≈ norm(dpoint(s))

        # Test dl/ds
        @test dlength(s) ≈ d_ds(length, s)

        # Test tangentangle
        phi_t = tangentangle(s)
        @test cos(phi_t) ≈ dpoint(s)[1]/dlength(s) atol=1e-12
        @test sin(phi_t) ≈ dpoint(s)[2]/dlength(s) atol=1e-12

        # Test radialangle
        phi_r = radialangle(s)
        κ = curvature(s)
        sign_ = κ==0 ? 1 : sign(κ)
        @test cos(phi_r) ≈ cos(phi_t - sign_*π/2) atol=1e-12
        @test sin(phi_r) ≈ sin(phi_t - sign_*π/2) atol=1e-12

        # Test curvature
        t = dpoint(s)/dlength(s)
        t′ = d_ds(dpoint, s)/dlength(s)^2
        u_n = [-t[2], t[1]]
        k = dot(u_n, t′)
        @test curvature(s) ≈ k atol=1e-10

        # Test dcurvature
        @test dcurvature(s) ≈ d_ds(curvature, s) atol=1e-12
    end
end