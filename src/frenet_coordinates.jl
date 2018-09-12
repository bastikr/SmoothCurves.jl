module frenet

import ..Curve, ..Pose, ..pose
import ..normalize_angle, ..rotate2d


"""
    frenet.coordinates(p0::Pose, p::Pose)

Coordinates of `p` in the Frenet frame defined by `p0`.
"""
function coordinates(p0::Pose, p::Pose)
    dx = p.x - p0.x
    dy = p.y - p0.y
    dphi = normalize_angle(p.phi - p0.phi)
    xr, yr = rotate2d(-p0.phi, dx, dy)
    return Pose(xr, yr, dphi)
end


"""
    frenet.coordinates(C::Curve, s, p::Pose)

Coordinates of `p` in the Frenet frame at ``C(s)``.
"""
function coordinates(C::Curve, s::Real, p::Pose)
    p0 = pose(C, s)
    coordinates(p0, p)
end

end
