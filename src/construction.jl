
function construct_clothoids(λ::Real, p0, v0, v1)
    v0_ = SVector{2}(normalize(v0))
    v1_ = SVector{2}(normalize(v1))
    λ = abs(λ)
    dphi = deviation(v0_, v1_)
    phi0 = deviation(v0_, [1, 0])
    phi1 = deviation(v1_, [1, 0])
    lmax = smax_from_deviation(λ, abs(dphi))
    xmax, ymax = Fresnel(λ, lmax)

    shift = xmax + ymax*tan(abs(dphi)/2)
    C0 = Clothoid(p0, shift, -phi0, sign(dphi)*λ, 0., lmax)

    shift = xmax + ymax*tan(abs(dphi)/2)
    C1 = Clothoid(p0, -shift, -phi1, -sign(dphi)*λ, -lmax, 0.)
    return C0, C1
end


function construct_clothoids2(dmax::Real, p0, p1, p2)
    v0_ = SVector{2}(normalize(p1-p0))
    v1_ = SVector{2}(normalize(p2-p1))

    dphi = deviation(v0_, v1_)
    phi0 = deviation(v0_, [1, 0])
    phi1 = deviation(v1_, [1, 0])

    θ = abs(dphi/2)
    Fcos, Fsin = Fresnel(1., sqrt(θ))
    g = cos(θ)*sqrt(θ)/Fsin
    d = sin(2*θ)^(3./2)

    smax = dmax*d*g
    λ = θ/smax^2

    xmax, ymax = Fresnel(λ, smax)

    shift = xmax + ymax*tan(abs(dphi)/2)
    C0 = Clothoid(p1, shift, -phi0, sign(dphi)*λ, 0., smax)

    shift = xmax + ymax*tan(abs(dphi)/2)
    C1 = Clothoid(p1, -shift, -phi1, -sign(dphi)*λ, -smax, 0.)
    return C0, C1
end


function construct_curve(λ, p0, p1, p2)
    v0 = p1 - p0
    v1 = p2 - p1
    C0, C1 = construct_clothoids(λ, p1, v0, v1)
    p0_ = collect(point(C0, 0.))
    dp0 = p0_ - p0
    L0 = Line(p0, dp0, norm(dp0))
    p1_ = collect(point(C1, length(C1)))
    dp1 = p2 - p1_
    L1 = Line(p1_, dp1, norm(dp1))
    PolyCurve(L0, C0, C1, L1)
end

function construct_curve2(dmax, p0, p1, p2)
    C0, C1 = construct_clothoids2(dmax, p0, p1, p2)
    p0_ = collect(point(C0, 0.))
    dp0 = p0_ - p0
    L0 = Line(p0, dp0, norm(dp0))
    p1_ = collect(point(C1, length(C1)))
    dp1 = p2 - p1_
    L1 = Line(p1_, dp1, norm(dp1))
    PolyCurve(L0, C0, C1, L1)
end
