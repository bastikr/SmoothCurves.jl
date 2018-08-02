import Base: length


using StaticArrays

"""
Abstract base class for all specialized curve types.
"""
abstract type Curve end

Point = StaticArrays.SVector

"""
    smax(C::Curve)

Maximum parameter ``s`` for which the given curve ``\\mathcal{C}`` is defined.
"""
smax(C::Curve) = error("Not Implemented")

"""
    length(C::Curve, s)

Length of the given curve ``\\mathcal{C}`` between ``0`` and ``s``.
"""
length(C::Curve, s::Real) = error("Not Implemented")

"""
    length(C::Curve)

Total length of the given curve. Equal to `length(C, smax(C))`.
"""
length(C::Curve) = length(C::Curve, smax(C))

"""
    dlength(C::Curve, s)

Derivative ``\\frac{dl}{ds}`` at ``s``.
"""
dlength(C::Curve, s::Real) = error("Not Implemented")

"""
    tangentangle(C::Curve, s)

Angle between the tangent of the curve ``\\mathcal{C}`` at ``s`` and the ``x``-axis.
Always between ``-π`` and ``π``.
"""
tangentangle(C::Curve, s::Real) = error("Not Implemented")

"""
    radialangle(C::Curve, s)

Angle between the radial vector of the curve ``\\mathcal{C}`` at ``s`` and the
``x``-axis. Always between ``-π`` and ``π``.
"""
radialangle(C::Curve, s::Real) = error("Not Implemented")


"""
    curvature(C::Curve, s)

Curvature of the Curve ``\\mathcal{C}`` at ``s``.
"""
curvature(C::Curve, s::Real) = error("Not Implemented")

"""
    dcurvature(C::Curve, s)

Derivative ``\\frac{dκ}{ds}`` of the curve ``\\mathcal{C}`` at ``s``.
"""
dcurvature(C::Curve, s::Real) = error("Not Implemented")

"""
    point(C::Curve, s)

Point `(x, y)` of the curve ``\\mathcal{C}`` at ``s``. Returns a `StaticArrays.SVector`.
"""
point(C::Curve, s::Real) = error("Not Implemented")

"""
    dpoint(C::Curve, s)

Derivative ``\\frac{dC(s)}{ds}`` of the curve ``\\mathcal{C}`` at ``s``. Returns a
`StaticArrays.SVector`.
"""
dpoint(C::Curve, s::Real) = error("Not Implemented")


struct Pose
    x::Float64
    y::Float64
    phi::Float64
end

function pose(C::Curve, l::Float64)
    x, y = point(C, l)
    phi = tangentangle(C, l)
    return Pose(x, y, phi)
end

x(p::Point) = p[1]
y(p::Point) = p[2]

x(p::Pose) = p.x
y(p::Pose) = p.y
phi(p::Pose) = p.phi
