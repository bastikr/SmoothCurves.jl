import Base.length
using StaticArrays: SVector


struct Line <: Curve
    l1::Float64
    origin::SVector{2}
    direction::SVector{2}
    function Line(l1::Float64, origin, direction)
        if l1<0
            throw(DomainError("l0 has to be positive"))
        end
        new(l1, SVector{2}(origin), SVector{2}(normalize(direction)))
    end
end

Base.length(x::Line) = x.l1

l(C::Line, s::Real) = s
dl(C::Line, s::Real) = 1.
θ(C::Line, s::Real) = atan2(C.direction[2], C.direction[1])
curvature(C::Line, s::Real) = 0.
dcurvature(C::Line, s::Real) = 0.
dpoint(C::Line, s::Real) = C.direction

function point(C::Line, l::Real)
    Point((C.origin + l*C.direction)...)
end
