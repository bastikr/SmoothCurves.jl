module Rio

export ControllerParameters, control

import ...curves: pose

using ...curves: Curve
using ..Pose
using ...Control

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

function dr_dt(K_ϕ::Float64, q::Pose, r::Float64, C::Curve)
    e = q - pose(C, r)
    κ = curvature(C, r)
    K_mov = 1.
    v_des = sqrt(K_mov^2/(1 + b_ϕ^2*κ^2))
    ω_des = κ*v_des
    ω_des′ = 1
    v_des′ = 1
    num = q.v*v_des*cos(e.ϕ) + K_ϕ^2*q.ω*ω_des
    denum = v_des^2 - ω_des*v_des*e.y + K_ϕ^2*ω_des^2 - K_ϕ^2*e.ϕ*ω_des′ - e.x*v_des′
    return num/denum
end

function (-)(state_real::Pose, pose_desired::Pose)
    dx = state_real.x - pose_desired.x
    dy = state_real.y - pose_desired.y
    phi = pose_desired.phi
    dphi_unwrapped = state_real.phi - pose_desired.phi
    dphi = atan2(sin(dphi_unwrapped), cos(dphi_unwrapped))
    return Pose(dx*cos(phi) + dy*sin(phi), -dx*sin(phi) + dy*cos(phi), dphi)
end

function eulerstep(dt::Float64, pose::Pose, u::Control)
    x = pose.x
    y = pose.y
    phi = pose.phi
    x = x + dt*u.v*cos(phi)
    y = y + dt*u.v*sin(phi)
    phi_unwrapped = phi + dt*u.w
    phi = atan2(sin(phi_unwrapped), cos(phi_unwrapped))
    return Pose(x, y, phi)
end

function distance(K_ϕ::Float64, p0::Pose, p1::Pose)
    e = p0 - p1
    e.x^2 + e.y^2 + (K_ϕ * e.phi)^2
end

function minimize_distance(K_ϕ, p0::Pose, C::Curve, lmin, lmax)
    result = optimize(l->distance(K_ϕ, p0, pose(C, l)), lmin, lmax)
    return result.minimizer[1]
end

function control(params::ControllerParameters, dt::Float64, t::Float64, u::Control, p::Pose, C::Curve)
    s = minimize_distance(params.K_ϕ, p, C, max(params.s-0.3, 0), params.s+0.3)
    params.s = s
    e = p - pose(C, s)

    cv = e.x*cos(e.phi) + e.y*sin(e.phi)
    cw = params.K_ϕ*e.phi
    u0_line = normalize([cw, -cv])
    n0_line = normalize([cv, cw])
    p0_line = [-cv/params.τ_xy, -cw/params.τ_ϕ]
    d = dot(n0_line, p0_line)
    # d_ = (-cv^2/τ_xy - cw^2/τ_ϕ)/sqrt(cv^2 + cw^2)

    if (d^2>params.K_mov^2)
        println("max")
        if dot(n0_line, p0_line)>0
            v, w_scaled = params.K_mov * n0_line
        else
            v, w_scaled = -params.K_mov * n0_line
        end
    else
        lu = sqrt(params.K_mov^2 - d^2)
        v0, w_scaled0 = n0_line*d + lu*u0_line
        v1, w_scaled1 = n0_line*d - lu*u0_line
        pose_simulated0 = eulerstep(0.01, p, Control(v0, w_scaled0/params.K_ϕ))
        pose_simulated1 = eulerstep(0.01, p, Control(v1, w_scaled1/params.K_ϕ))
        l0 = minimize_distance(params.K_ϕ, pose_simulated0, C, max(s-0.3, 0), s+0.3)
        l1 = minimize_distance(params.K_ϕ, pose_simulated1, C, max(s-0.3, 0), s+0.3)
        if l0>l1
            v, w_scaled = v0, w_scaled0
        else
            v, w_scaled = v1, w_scaled1
        end
    end
    return Control(v, w_scaled/params.K_ϕ)
end

end # module Rio
