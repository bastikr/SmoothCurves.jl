module Rio

export ControllerParameters, control

import ...curves: pose

using ...curves
using ...curves: Curve
using ..Pose
using ...Control
using ...DynamicParameters
using ...vmax_backward, ...vmax_forward

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
    params.s = s
    e = curves.frenet_coordinates(C, s, p)

    κ = curves.curvature(C, s)
    # b_ϕ = params.K_ϕ
    params_dyn = DynamicParameters(1., 0.5, 0.5)
    v_des = min(vmax_backward(params_dyn, C, 0., s), vmax_forward(params_dyn, C, 0., s))
    v_des = max(v_des, 0.01)

    cv = e.x*cos(e.phi) + e.y*sin(e.phi)
    cw = params.K_ϕ*e.phi
    w_scaled = -1./cw*(cv*v_des + cv^2/params.τ_xy + cw^2/params.τ_ϕ)
    return Control(v_des, w_scaled/params.K_ϕ)

    # K_mov = v_des*sqrt(1 + κ^2*params.K_ϕ^2)
    # if cw>=0
    #     u_c = normalize([cw, -cv])
    # else
    #     u_c = normalize([-cw, cv])
    # end
    # n_c = normalize([cv, cw])
    # p_c = [-cv/params.τ_xy, -cw/params.τ_ϕ]
    # d = dot(p_c, n_c)
    # if (K_mov < abs(d))
    #     p_target = K_mov*sign(d)*n_c
    # else
    #     p_target = d*n_c + sqrt(1-K_mov^2)*u_c
    # end

    # p0 = [u.v, params.K_ϕ*u.w]
    # if norm(p0-p_target)>dt*params_dyn.amax
    #     println("Max accelaration")
    #     p_target = p0 + normalize(p_target-p0)*dt*params_dyn.amax
    # end
    # return Control(p_target[1], p_target[2]/params.K_ϕ)
end

end # module Rio
