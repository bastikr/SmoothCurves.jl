module construction

using StaticArrays: SVector

using ..deviation
using ..Curve, ..smax, ..point
using ..LineSegment
using ..Clothoid, ..fresnel
using ..PolyCurve


function clothoidcorner(dmax::Real, p0, p1, p2)
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
    Fcos, Fsin = fresnel(1., sqrt(θ))

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


function curve(dmax, points)
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
        C = clothoidcorner(dmax, p0, p1, p2)
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

end # module construction
