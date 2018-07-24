import Base.length

using StaticArrays: SVector


struct Line <: Curve
    origin::SVector{2, Float64}
    direction::SVector{2, Float64}
    length::Float64

    function Line(origin, direction, length::Number)
        if length<0
            throw(DomainError("length has to be positive"))
        end
        new(origin, normalize(direction), length)
    end
end

# Implement Curve interface
smax(C::Line) = C.length

length(C::Line, s::Real) = s
length(C::Line) = C.length
dlength(C::Line, s::Real) = 1.

tangentangle(C::Line, s::Real) = atan2(C.direction[2], C.direction[1])

curvature(C::Line, s::Real) = 0.
dcurvature(C::Line, s::Real) = 0.

point(C::Line, s::Real) = C.origin + s*C.direction
dpoint(C::Line, s::Real) = C.direction
