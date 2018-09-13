import Base: length


"""
    PolyCurve(curves...)

Collection of curves joined at their start and endpoints.
"""
struct PolyCurve <: Curve
    curves::Vector
    smax::Vector{Float64}
    cum_smax::Vector{Float64}

    function PolyCurve(curves...)
        smax_ = collect(smax.(curves))
        cum_smax = cumsum(smax_)
        new(collect(curves), smax_, cum_smax)
    end
end

"""
    subcurveindex(C::PolyCurve, s)

Index of the subcurve reached at the given parameter `s`.
"""
function subcurveindex(C::PolyCurve, s::Real)
    checkdomain(C, s)
    findfirst(x->(x-s>=0), C.cum_smax)
end

function subcurveparameter(C::PolyCurve, s::Real, index::Int64)
    s_i = index==1 ? s : s - C.cum_smax[index-1]
    if s_i>C.smax[index] # Numerical inaccuracy
        s_i = C.smax[index]
    end
    return s_i
end

"""
    subcurveparameter(C::PolyCurve, s)

Parameter ``s_i`` for which ``C(s)=C_i(s_i)``
"""
subcurveparameter(C::PolyCurve, s::Real) = subcurveparameter(C, s, subcurveindex(C, s))

"""
    dispatch(f, C::PolyCurve, s::Real)

Apply function `f` to appropriate subcurve i.e. ``f(C_i, s_i)``.
"""
function dispatch(f, C::PolyCurve, s::Real)
    i = subcurveindex(C, s)
    s_i = subcurveparameter(C, s, i)
    f(C.curves[i], s_i)
end


# Implement curve interface

smax(C::PolyCurve) = C.cum_smax[end]
point_unchecked(C::PolyCurve, s::Real) = dispatch(point_unchecked, C, s)
dpoint_unchecked(C::PolyCurve, s::Real) = dispatch(dpoint_unchecked, C, s)
function length_unchecked(C::PolyCurve, s::Real)
    i = subcurveindex(C, s)
    l = 0.
    for j=1:i-1
        l += length(C.curves[j])
    end
    s_i = subcurveparameter(C, s, i)
    l + length(C.curves[i], s_i)
end
dlength_unchecked(C::PolyCurve, s::Real) = dispatch(dlength_unchecked, C, s)
tangentangle_unchecked(C::PolyCurve, s::Real) = dispatch(tangentangle_unchecked, C, s)
radialangle_unchecked(C::PolyCurve, s::Real) = dispatch(radialangle_unchecked, C, s)
curvature_unchecked(C::PolyCurve, s::Real) = dispatch(curvature_unchecked, C, s)
dcurvature_unchecked(C::PolyCurve, s::Real) = dispatch(dcurvature_unchecked, C, s)
startpoint(C::PolyCurve) = startpoint(C.curves[1])
endpoint(C::PolyCurve) = endpoint(C.curves[end])
