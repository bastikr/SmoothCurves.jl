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

function evaluate(C::Line, l::Float64)
    if l < 0 || l > C.l1
        throw(DomainError("l has to be between 0 and l1"))
    end
    C.origin + l*C.direction
end

function evaluate_angle(C::Line, l::Float64)
    return atan2(C.direction[2], C.direction[1])
end
