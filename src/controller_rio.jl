module Rio

export ControllerParameters, control

import ...curves: pose

using ...curves
using ...curves: Curve
using ..Pose
using ...Control
using ...DynamicParameters
using ...vmax

using Optim


mutable struct ControllerParameters
    τ_xy::Float64
    τ_ϕ::Float64
    K_ϕ::Float64
    K_mov::Float64
    s::Float64
end

ControllerParameters(; τ_xy=nothing, τ_ϕ=nothing, K_ϕ=nothing, K_mov=nothing, s=nothing) = ControllerParameters(τ_xy, τ_ϕ, K_ϕ, K_mov, s)


import Base.-

# function dr_dt(K_ϕ::Float64, q::Pose, u::Control, r::Float64, C::Curve)
#     K_mov = 1.
#     b_ϕ = K_ϕ

#     e = q - pose(C, r)
#     κ = curves.curvature(C, r)
#     dκ = curves.dcurvature(C, r)

#     # Determine desired v and w
#     v_des = K_mov * sqrt(1/(1 + b_ϕ^2*κ^2))
#     w_des = κ*v_des
#     v_des′ = K_mov*(1+b_ϕ^2*κ^2)^(-3/2) * b_ϕ^2 * κ * dκ
#     w_des′ = dκ*v_des + κ*v_des′

#     num = u.v*v_des*cos(e.phi) + K_ϕ^2*u.w*w_des
#     denum = v_des^2 - w_des*v_des*e.y + K_ϕ^2*w_des^2 - K_ϕ^2*e.phi*w_des′ - e.x*v_des′
#     return num/denum
# end


# function eulerstep(dt::Float64, pose::Pose, u::Control)
#     x = pose.x
#     y = pose.y
#     phi = pose.phi
#     x = x + dt*u.v*cos(phi)
#     y = y + dt*u.v*sin(phi)
#     phi_unwrapped = phi + dt*u.w
#     phi = atan2(sin(phi_unwrapped), cos(phi_unwrapped))
#     return Pose(x, y, phi)
# end

function distance(K_ϕ::Float64, p0::Pose, p::Pose)
    e = curves.frenet_coordinates(p0, p)
    e.x^2 + e.y^2 + (K_ϕ * e.phi)^2
end

function minimize_distance(K_ϕ, p0::Pose, C::Curve, lmin, lmax)
    result = optimize(l->distance(K_ϕ, pose(C, l), p0), lmin, lmax)
    return result.minimizer[1]
end

function control(params::ControllerParameters, dt::Float64, t::Float64, u::Control, p::Pose, C::Curve)
    s = minimize_distance(params.K_ϕ, p, C, max(params.s-0.3, 0), params.s+0.3)
    # ds = dt*dr_dt(params.K_ϕ, p, u, params.s, C)
    # s = s + 0.01
    params.s = s
    e = curves.frenet_coordinates(C, s, p)
    # e = p - pose(C, s)

    κ = curves.curvature(C, s)
    # b_ϕ = params.K_ϕ
    params_dyn = DynamicParameters(1., 0.5, 0.5)
    v_des = vmax(params_dyn, C, 0., s) + 0.01
    v_des = min(u.v + params_dyn.amax*dt, v_des)

    # v_des = params.K_mov * sqrt(1/(1 + b_ϕ^2*κ^2))
    w_des = κ*v_des
    w_des = min(w_des, u.w + params_dyn.amax*dt)
    w_des = max(w_des, u.w - params_dyn.amax*dt)
    println("v_des = ", v_des, "  w_des = ", w_des)
    p0_des = [v_des, params.K_ϕ*w_des]

    K_mov = params.K_mov

    cv = e.x*cos(e.phi) + e.y*sin(e.phi)
    cw = params.K_ϕ*e.phi
    u0_line = normalize([cw, -cv])
    n0_line = normalize([cv, cw])
    p0_line = [-cv/params.τ_xy, -cw/params.τ_ϕ]
    d = dot(n0_line, (p0_line - p0_des))
    p = p0_des + d*n0_line
    v, w_scaled = p
    # d = dot(n0_line, p0_line)
    # d_ = (-cv^2/τ_xy - cw^2/τ_ϕ)/sqrt(cv^2 + cw^2)

    # v = v_des
    # v = 0.5
    # w_scaled = -1./cw*(cv*v + cv^2/params.τ_xy + cw^2/params.τ_ϕ)
    return Control(v, max(min(w_scaled/params.K_ϕ, 1.), -1.))

    # if (d^2>K_mov^2)
    #     println("max")
    #     if dot(n0_line, p0_line)>0
    #         v, w_scaled = K_mov * n0_line
    #     else
    #         v, w_scaled = -K_mov * n0_line
    #     end
    # else
    #     lu = sqrt(K_mov^2 - d^2)
    #     v0, w_scaled0 = n0_line*d + lu*u0_line
    #     v1, w_scaled1 = n0_line*d - lu*u0_line
    #     pose_simulated0 = eulerstep(0.01, p, Control(v0, w_scaled0/params.K_ϕ))
    #     pose_simulated1 = eulerstep(0.01, p, Control(v1, w_scaled1/params.K_ϕ))
    #     l0 = minimize_distance(params.K_ϕ, pose_simulated0, C, max(s-0.3, 0), s+0.3)
    #     l1 = minimize_distance(params.K_ϕ, pose_simulated1, C, max(s-0.3, 0), s+0.3)
    #     if l0>l1
    #         v, w_scaled = v0, w_scaled0
    #     else
    #         v, w_scaled = v1, w_scaled1
    #     end
    # end
    # return Control(v, w_scaled/params.K_ϕ)
end

end # module Rio
