using Revise
using SmoothCurves

# Path
λ = 500.
p0 = [-4, 2]
p1 = [0.0, 0.0]
p2 = [-4, 3]

C = SmoothCurves.curves.construct_curve(λ, p0, p1, p2)

# Initial state
p0 = SmoothCurves.Pose(-3, 1.6, -0.6)


# Controller
controller = SmoothCurves.controllers.Rio.ControllerParameters(
    τ_xy=0.5,
    τ_ϕ=0.5,
    K_ϕ=0.25,
    K_mov=0.5,
    s=SmoothCurves.controllers.Rio.minimize_distance(0.25, p0, C, 0, length(C.curves[1]))
)


state0 = SmoothCurves.controllers.Rio.State(p0, 1)
u = SmoothCurves.Control(0, 0)

control = SmoothCurves.controllers.Rio.control
eulerstep = SmoothCurves.controllers.Rio.eulerstep


dt = 0.01
tend = 10

state = state0

tvec = Float64[0]
poses = SmoothCurves.Pose[p0]
controls = SmoothCurves.Control[u]

for t=0:dt:tend
    u = control(controller, 0.1, 1., u, state, C)
    p = eulerstep(dt, state.pose, u)
    state = SmoothCurves.controllers.Rio.State(p, 1)

    push!(tvec, tvec[end]+dt)
    push!(poses, p)
    push!(controls, u)
end

using Plots
x = SmoothCurves.curves.x.(poses)
y = SmoothCurves.curves.y.(poses)
v = [u.v for u in controls]
w = [u.w for u in controls]


plt_xy = plot(C; spacing=0.01, color=:black)
plot!(plt_xy, x, y)

plt_tx = plot(tvec, x, ylabel="x", label="")
plt_ty = plot(tvec, y, ylabel="y", label="")

plt_tv = plot(tvec, v, ylabel="v", label="")
plt_tw = plot(tvec, w, ylabel="w", label="")

plt_c = plot(plt_tx, plt_ty, plt_tv, plt_tw, layout=(4,1))
plot(plt_xy, plt_c, size=(800, 400))


# @gif for p in poses
#     plt_xy = plot(C; spacing=0.05, color=:black)
#     plot!(plt_xy, x, y)
#     plot!(p, color=3)
# end every 5
