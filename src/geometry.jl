normalvector(v) = [-v[2], v[1]]

function rotate2d(phi::Float64, x::Float64, y::Float64)
    c = cos(phi)
    s = sin(phi)
    return SVector(c*x - s*y, s*x + c*y)
end

function normalize_angle(x)
    (x % (2π) + 3*π) % (2π) - π
end

function deviation(v0, v1)
    u0 = normalize(v0)
    u1 = normalize(v1)
    n1 = normalvector(u1)
    atan2(dot(u0, -n1), dot(u0, u1))
end

function frenet_coordinates(p0::Pose, p::Pose)
    dx = p.x - p0.x
    dy = p.y - p0.y
    dphi = normalize_angle(p.phi - p0.phi)
    xr, yr = rotate2d(-p0.phi, dx, dy)
    return Pose(xr, yr, dphi)
end

function frenet_coordinates(C::Curve, s::Float64, p::Pose)
    p0 = pose(C, s)
    frenet_coordinates(p0, p)
end
