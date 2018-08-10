import Base: length

using StaticArrays


"""
Abstract base class for all specialized curve types.
"""
abstract type Curve end


length_unchecked(C::Curve, s::Real) = error("Not Implemented")
dlength_unchecked(C::Curve, s::Real) = error("Not Implemented")
tangentangle_unchecked(C::Curve, s::Real) = error("Not Implemented")
radialangle_unchecked(C::Curve, s::Real) = error("Not Implemented")
curvature_unchecked(C::Curve, s::Real) = error("Not Implemented")
dcurvature_unchecked(C::Curve, s::Real) = error("Not Implemented")
point_unchecked(C::Curve, s::Real) = error("Not Implemented")
dpoint_unchecked(C::Curve, s::Real) = error("Not Implemented")


"""
    smax(C::Curve)

Maximum parameter ``s`` for which the given curve ``\\mathcal{C}`` is defined.
"""
smax(C::Curve) = error("Not Implemented")

"""
    checkdomain(C::Curve, s)

Check if the given parameter `s` is in the domain where ``C`` is defined.
"""
function checkdomain(C::Curve, s::Real)
    if s<0 || s>smax(C)
        throw(ArgumentError("s=$s is not in curve domain [0, $(smax(C))]."))
    end
end

"""
    length(C::Curve, s)

Length of the given curve ``\\mathcal{C}`` between ``0`` and ``s``.
"""
length(C::Curve, s::Real) = (checkdomain(C, s); length_unchecked(C, s))


"""
    length(C::Curve)

Total length of the given curve. Equal to `length(C, smax(C))`.
"""
length(C::Curve) = length(C::Curve, smax(C))

"""
    dlength(C::Curve, s)

Derivative ``\\frac{dl}{ds}`` at ``s``.
"""
dlength(C::Curve, s::Real) = (checkdomain(C, s); dlength_unchecked(C, s))


"""
    tangentangle(C::Curve, s)

Angle between the tangent of the curve ``\\mathcal{C}`` at ``s`` and the ``x``-axis.
Always between ``-π`` and ``π``.
"""
tangentangle(C::Curve, s::Real) = (checkdomain(C, s); tangentangle_unchecked(C, s))


"""
    radialangle(C::Curve, s)

Angle between the radial vector of the curve ``\\mathcal{C}`` at ``s`` and the
``x``-axis. Always between ``-π`` and ``π``.
"""
radialangle(C::Curve, s::Real) = (checkdomain(C, s); radialangle_unchecked(C, s))



"""
    curvature(C::Curve, s)

Curvature of the Curve ``\\mathcal{C}`` at ``s``.
"""
curvature(C::Curve, s::Real) = (checkdomain(C, s); curvature_unchecked(C, s))


"""
    dcurvature(C::Curve, s)

Derivative ``\\frac{dκ}{ds}`` of the curve ``\\mathcal{C}`` at ``s``.
"""
dcurvature(C::Curve, s::Real) = (checkdomain(C, s); dcurvature_unchecked(C, s))


"""
    point(C::Curve, s)

Point `(x, y)` of the curve ``\\mathcal{C}`` at ``s``. Returns a `StaticArrays.SVector`.
"""
point(C::Curve, s::Real) = (checkdomain(C, s); point_unchecked(C, s))


"""
    dpoint(C::Curve, s)

Derivative ``\\frac{dC(s)}{ds}`` of the curve ``\\mathcal{C}`` at ``s``. Returns a
`StaticArrays.SVector`.
"""
dpoint(C::Curve, s::Real) = (checkdomain(C, s); dpoint_unchecked(C, s))


"""
    startpoint(C::Curve)

Return the first point ``C(0)`` of the curve.
"""
startpoint(C::Curve) = point_unchecked(C, 0.)

"""
    endpoint(C::Curve)

Return the last point ``C(s_\\mathrm{max}`` of the curve.
"""
endpoint(C::Curve) = point_unchecked(C, smax(C))


struct Pose
    x::Float64
    y::Float64
    phi::Float64
end

function pose(C::Curve, l::Number)
    l_ = convert(Float64, l)
    x, y = point(C, l_)
    phi = tangentangle(C, l_)
    return Pose(x, y, phi)
end
