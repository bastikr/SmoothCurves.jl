import Base: length


struct PolyCurve <: Curve
    curves::Vector
    cum_s::Vector{Float64}

    function PolyCurve(curves...)
        cum_s = cumsum(collect(smax.(curves)))
        new(collect(curves), cum_s)
    end
end

function subcurveindex(C::PolyCurve, s::Float64)
    if s>C.cum_s[end]
        return length(C.curves)
    end
    findfirst(x->(x-s>=0), C.cum_s)
end

subcurveparameter(C::PolyCurve, s::Float64, index::Int64) = index==1 ? s : s - C.cum_s[index-1]
subcurveparameter(C::PolyCurve, s::Float64) = subcurveparameter(C, s, subcurveindex(C, s))

function dispatch(f, C::PolyCurve, s::Float64)
    i = subcurveindex(C, s)
    s_i = subcurveparameter(C, s, i)
    f(C.curves[i], s_i)
end

function length(C::PolyCurve, s::Float64)
    i = subcurveindex(C, s)
    l = 0.
    for j=1:i-1
        l += length(C.curves[j])
    end
    s_i = subcurveparameter(C, s, i)
    l + length(C.curves[i], s_i)
end

smax(C::PolyCurve) = C.cum_s[end]
point(C::PolyCurve, s::Float64) = dispatch(point, C, s)
dpoint(C::PolyCurve, s::Float64) = dispatch(dpoint, C, s)
dlength(C::PolyCurve, s::Float64) = dispatch(dlength, C, s)
tangentangle(C::PolyCurve, s::Float64) = dispatch(tangentangle, C, s)
curvature(C::PolyCurve, s::Float64) = dispatch(curvature, C, s)
dcurvature(C::PolyCurve, s::Float64) = dispatch(dcurvature, C, s)
