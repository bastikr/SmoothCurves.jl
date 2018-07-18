normalvector(v) = [-v[2], v[1]]

function rotate2d(phi, x, y)
    c = cos(phi)
    s = sin(phi)
    return c*x - s*y, s*x + c*y
end

function deviation(v0, v1)
    u0 = normalize(v0)
    u1 = normalize(v1)
    n1 = normalvector(u1)
    atan2(dot(u0, -n1), dot(u0, u1))
end
