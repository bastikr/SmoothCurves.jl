import Base.length
import Base.angle

abstract type Curve end


function pose(C::Curve, l::Float64)
    x, y = point(C, l)
    phi = angle(C, l)
    return x, y, phi
end


function point(C::Curve, lvec::Vector{Float64})
    xvec = Float64[]
    yvec = Float64[]
    for l=lvec
        x, y = point(C, l)
        push!(xvec, x)
        push!(yvec, y)
    end
    return xvec, yvec
end

function angle(C::Curve, lvec::Vector{Float64})
    phivec = Float64[]
    for l=lvec
        phi = angle(C, l)
        push!(phivec, phi)
    end
    return phivec
end

function pose(C::Curve, lvec::Vector{Float64})
    xvec = Float64[]
    yvec = Float64[]
    phivec = Float64[]
    for l=lvec
        x, y = point(C, l)
        push!(xvec, x)
        push!(yvec, y)
        phi = angle(C, l)
        push!(phivec, phi)
    end
    return xvec, yvec, phivec
end
