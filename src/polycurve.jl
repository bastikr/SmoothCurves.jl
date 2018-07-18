import Base: length


struct PolyCurve <: Curve
    curves::Vector
    cumlengths::Vector{Float64}

    function PolyCurve(curves...)
        cumlengths = cumsum(collect(length.(curves)))
        new(collect(curves), cumlengths)
    end
end

Base.length(p::PolyCurve) = p.cumlengths[end]

function evaluate(P::PolyCurve, l::Float64)
    if l < 0 || l > P.cumlengths[end]
        throw(DomainError("Out of Bounds"))
    end
    i = findfirst(x->(x-l>0), P.cumlengths)
    l_i = l
    if (i>1)
        l_i -= P.cumlengths[i-1]
    end
    evaluate(P.curves[i], l_i)
end

function evaluate_angle(P::PolyCurve, l::Float64)
    if l < 0 || l > P.cumlengths[end]
        throw(DomainError("Out of Bounds"))
    end
    i = findfirst(x->(x-l>=0), P.cumlengths)
    l_i = l
    if (i>1)
        l_i -= P.cumlengths[i-1]
    end
    evaluate_angle(P.curves[i], l_i)
end

function construct_curve(λ, p0, p1, p2)
    v0 = p1 - p0
    v1 = p2 - p1
    C0, C1 = construct_clothoids(λ, p1, v0, v1)
    p0_ = collect(evaluate(C0, 0.))
    dp0 = p0_ - p0
    L0 = Line(norm(dp0), p0, dp0)
    p1_ = collect(evaluate(C1, length(C1)))
    dp1 = p2 - p1_
    L1 = Line(norm(dp1), p1_, dp1)
    PolyCurve(L0, C0, C1, L1)
end
