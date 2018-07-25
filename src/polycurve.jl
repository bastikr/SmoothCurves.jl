import Base: length


struct PolyCurve <: Curve
    curves::Vector
    cum_s::Vector{Float64}

    function PolyCurve(curves...)
        cum_s = cumsum(collect(smax.(curves)))
        new(collect(curves), cum_s)
    end
end

Base.length(C::PolyCurve) = C.cum_s[end]

function curveindex(C::PolyCurve, s::Float64)
    if s < 0 || s > C.cum_s[end]
        throw(DomainError("s has to be between 0 and $(C.cum_s[end]) but is $s."))
    end
    findfirst(x->(x-s>=0), C.cum_s)
end

function dispatch(f, C::PolyCurve, s::Float64)
    i = curveindex(C, s)
    s_i = s
    if (i>1)
        s_i -= C.cum_s[i-1]
    end
    f(C.curves[i], s_i)
end

function length(C::PolyCurve, s::Float64)
    i = curveindex(C, s)
    s_i = s
    if (i>1)
        s_i -= C.cum_s[i-1]
    end
    l_ = 0.
    for j=1:i-1
        l += length(C.curve[j])
    end
    l_ + length(C.curves[i], s_i)
end

smax(C::PolyCurve) = C.cum_s[end]
point(C::PolyCurve, s::Float64) = dispatch(point, C, s)
dlength(C::PolyCurve, s::Float64) = dispatch(dl, C, s)
tangentangle(C::PolyCurve, s::Float64) = dispatch(tangentangle, C, s)
dtangentangle(C::PolyCurve, s::Float64) = dispatch(dtangentangle, C, s)
curvature(C::PolyCurve, s::Float64) = dispatch(curvature, C, s)
dcurvature(C::PolyCurve, s::Float64) = dispatch(dcurvature, C, s)
