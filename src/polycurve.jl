import Base: length


"""
    PolyCurve(curves...)

Collection of curves joined at their start and endpoints.
"""
struct PolyCurve <: Curve
    curves::Vector
    cum_s::Vector{Float64}

    function PolyCurve(curves...)
        cum_s = cumsum(collect(smax.(curves)))
        new(collect(curves), cum_s)
    end
end

"""
    subcurveindex(C::PolyCurve, s)

Index of the subcurve reached at the given parameter `s`.
"""
function subcurveindex(C::PolyCurve, s::Float64)
    if s>C.cum_s[end]
        return length(C.curves)
    end
    findfirst(x->(x-s>=0), C.cum_s)
end

subcurveparameter(C::PolyCurve, s::Float64, index::Int64) = index==1 ? s : s - C.cum_s[index-1]

"""
    subcurveparameter(C::PolyCurve, s)

Parameter ``s_i`` for which ``C(s)=C_i(s_i)``
"""
subcurveparameter(C::PolyCurve, s::Float64) = subcurveparameter(C, s, subcurveindex(C, s))

"""
    dispatch(f, C::PolyCurve, s::Real)

Apply function `f` to appropriate subcurve i.e. ``f(C_i, s_i)``.
"""
function dispatch(f, C::PolyCurve, s::Real)
    s_ = convert(Float64, s)
    i = subcurveindex(C, s_)
    s_i = subcurveparameter(C, s_, i)
    f(C.curves[i], s_i)
end


# Implement curve interface

smax(C::PolyCurve) = C.cum_s[end]
point(C::PolyCurve, s::Real) = dispatch(point, C, s)
dpoint(C::PolyCurve, s::Real) = dispatch(dpoint, C, s)
function length(C::PolyCurve, s::Real)
    s_ = convert(Float64, s)
    i = subcurveindex(C, s_)
    l = 0.
    for j=1:i-1
        l += length(C.curves[j])
    end
    s_i = subcurveparameter(C, s_, i)
    l + length(C.curves[i], s_i)
end
dlength(C::PolyCurve, s::Real) = dispatch(dlength, C, s)
tangentangle(C::PolyCurve, s::Real) = dispatch(tangentangle, C, s)
radialangle(C::PolyCurve, s::Real) = dispatch(radialangle, C, s)
curvature(C::PolyCurve, s::Real) = dispatch(curvature, C, s)
dcurvature(C::PolyCurve, s::Real) = dispatch(dcurvature, C, s)
