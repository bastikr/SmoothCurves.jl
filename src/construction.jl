
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

function construct_clothoids3(dmax::Real, p0, p1, p2)
    p0_ = convert(SVector{2, Float64}, p0)
    p1_ = convert(SVector{2, Float64}, p1)
    p2_ = convert(SVector{2, Float64}, p2)

    v0 = p1 - p0
    v1 = p2 - p1

    u0 = normalize(v0)
    u1 = normalize(v1)

    Δφ = deviation(u0, u1)

    maxshift = min(norm(v0), norm(v1))
    θ = abs(Δφ/2)
    Fcos, Fsin = Fresnel(1., sqrt(θ))

    ν = sin(θ) + cos(θ)*Fcos/Fsin
    dmax_shift = maxshift/ν

    if dmax_shift<dmax
        d = dmax_shift
        shift = maxshift
    else
        d = dmax
        shift = ν*d
    end
    smax = d*sqrt(θ)*cos(θ)/Fsin
    λ = sign(Δφ)*θ/smax^2

    phi0 = deviation(u0, [1, 0])
    phi1 = deviation(u1, [1, 0])

    C0 = Clothoid(p1, shift, -phi0, λ, 0., smax)
    C1 = Clothoid(p1, -shift, -phi1, -λ, -smax, 0.)
    return PolyCurve(C0, C1)
end


function construct_curve(λ, p0, p1, p2)
    v0 = p1 - p0
    v1 = p2 - p1
    C0, C1 = construct_clothoids(λ, p1, v0, v1)
    p0_ = collect(point(C0, 0.))
    L0 = LineSegment(p0, p0_)
    p1_ = collect(point(C1, length(C1)))
    L1 = LineSegment(p1_, p2)
    PolyCurve(L0, C0, C1, L1)
end

function construct_curve2(dmax, p0, p1, p2)
    C0, C1 = construct_clothoids2(dmax, p0, p1, p2)
    p0_ = collect(point(C0, 0.))
    L0 = LineSegment(p0, p0_)
    p1_ = collect(point(C1, length(C1)))
    L1 = LineSegment(p1_, p2)
    PolyCurve(L0, C0, C1, L1)
end

function construct_curve3(dmax, points)
    curves = Curve[]
    p2_ = points[1]
    for i=1:length(points)-2
        p0 = p2_
        p1 = points[i+1]
        if (i+2>length(points))
            p2 = points[end]
        else
            p2 = 0.5*(points[i+1] + points[i+2])
        end
        C = construct_clothoids3(dmax, p0, p1, p2)
        p0_ = point(C, 0)
        if norm(p0_ - p0) > 1e-12
            push!(curves, LineSegment(p0, p0_))
        end
        push!(curves, C.curves[1])
        push!(curves, C.curves[2])
        p2_ = point(C, smax(C))
    end
    if norm(p2_ - points[end]) > 1e-12
        push!(curves, LineSegment(p2_, points[end]))
    end
    return PolyCurve(curves...)
end
