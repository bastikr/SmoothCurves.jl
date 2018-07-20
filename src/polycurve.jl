import Base: length


struct PolyCurve <: Curve
    curves::Vector
    cumlengths::Vector{Float64}

    function PolyCurve(curves...)
        cumlengths = cumsum(collect(length.(curves)))
        new(collect(curves), cumlengths)
    end
end

Base.length(C::PolyCurve) = C.cumlengths[end]

function dispatch(f, C::PolyCurve, s::Float64)
    if s < 0 || s > C.cumlengths[end]
        throw(DomainError("Out of Bounds"))
    end
    i = findfirst(x->(x-s>0), C.cumlengths)
    s_i = s
    if (i>1)
        s_i -= C.cumlengths[i-1]
    end
    f(C.curves[i], s_i)
end

point(C::PolyCurve, s::Float64) = dispatch(point, C, s)
l(C::PolyCurve, s::Float64) = dispatch(l, C, s)
dl(C::PolyCurve, s::Float64) = dispatch(dl, C, s)
θ(C::PolyCurve, s::Float64) = dispatch(θ, C, s)
dθ(C::PolyCurve, s::Float64) = dispatch(dθ, C, s)
curvature(C::PolyCurve, s::Float64) = dispatch(curvature, C, s)
dcurvature(C::PolyCurve, s::Float64) = dispatch(dcurvature, C, s)


function construct_curve(λ, p0, p1, p2)
    v0 = p1 - p0
    v1 = p2 - p1
    C0, C1 = construct_clothoids(λ, p1, v0, v1)
    p0_ = collect(point(C0, 0.))
    dp0 = p0_ - p0
    L0 = Line(norm(dp0), p0, dp0)
    p1_ = collect(point(C1, length(C1)))
    dp1 = p2 - p1_
    L1 = Line(norm(dp1), p1_, dp1)
    PolyCurve(L0, C0, C1, L1)
end

function construct_curve2(dmax, p0, p1, p2)
    C0, C1 = construct_clothoids2(dmax, p0, p1, p2)
    p0_ = collect(point(C0, 0.))
    dp0 = p0_ - p0
    L0 = Line(norm(dp0), p0, dp0)
    p1_ = collect(point(C1, length(C1)))
    dp1 = p2 - p1_
    L1 = Line(norm(dp1), p1_, dp1)
    PolyCurve(L0, C0, C1, L1)
end
