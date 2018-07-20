using Revise
using SmoothCurves

# Path
dmax = 0.5
point0 = 2*[-4, -1]
point1 = [0.0, 0.0]
point2 = 2*[-4, 1]

C = SmoothCurves.curves.construct_curve2(dmax, point0, point1, point2)

# Initial state
p0 = SmoothCurves.Pose((point0 + [2, -0.5])..., 0.3)
s0 = SmoothCurves.controllers.Rio.minimize_distance(0.25, p0, C, 0, length(C.curves[1]))

# Controller
controller = SmoothCurves.controllers.Rio.ControllerParameters(
    τ_xy=0.5,
    τ_ϕ=0.5,
    K_ϕ=0.25,
    K_mov=0.5,
    s=s0
)

u = SmoothCurves.Control(0, 0)

control = SmoothCurves.controllers.Rio.control
eulerstep = SmoothCurves.controllers.Rio.eulerstep

dt = 0.005
tend = 20

tvec = Float64[0]
poses = SmoothCurves.Pose[p0]
controls = SmoothCurves.Control[u]
svec = Float64[controller.s]

p = p0
for t=0:dt:tend
    u = control(controller, dt, t, u, p, C)
    p = eulerstep(dt, p, u)

    push!(tvec, tvec[end]+dt)
    push!(poses, p)
    push!(controls, u)
    push!(svec, controller.s)
end

using Plots
poses_ideal = SmoothCurves.curves.pose.(C, svec)
poses_error = SmoothCurves.curves.frenet_coordinates.(poses_ideal, poses)

x = SmoothCurves.curves.x.(poses)
y = SmoothCurves.curves.y.(poses)
phi = SmoothCurves.curves.phi.(poses)

x_ideal = SmoothCurves.curves.x.(poses_ideal)
y_ideal = SmoothCurves.curves.y.(poses_ideal)
phi_ideal = SmoothCurves.curves.phi.(poses_ideal)

x_error = SmoothCurves.curves.x.(poses_error)
y_error = SmoothCurves.curves.y.(poses_error)
phi_error = controller.K_ϕ * SmoothCurves.curves.phi.(poses_error)
err = sqrt.(x_error.^2 + y_error.^2 + (phi_error).^2)

v = [u.v for u in controls]
w = [u.w for u in controls]


plt_xy = plot(C; spacing=0.01, color=:black, xlabel="x", ylabel="y")
plot!(plt_xy, x, y, label="")

plt_tx = plot(tvec, x, ylabel="x", label="")
plot!(tvec, x_ideal, label="")

plt_ty = plot(tvec, y, ylabel="y", label="")
plot!(tvec, y_ideal, label="")

plt_tphi = plot(tvec, phi, ylabel="phi", label="")
plot!(tvec, phi_ideal, label="")

plt_error = plot(tvec, y_error.^2, ylabel="error", label="x")
plot!(tvec, x_error.^2, label="y")
plot!(tvec, phi_error.^2, label="phi")
plot!(tvec, err.^2, ylabel="total error")

plt_tv = plot(tvec, v, ylabel="v", label="")
plt_tw = plot(tvec, w, ylabel="w", label="")

plt_pose = plot(plt_tx, plt_ty, plt_tphi, plt_error, layout=(4, 1))
plt_control = plot(plt_tv, plt_tw, layout=(2, 1))
plt_left = plot(plt_xy, plt_control, layout=(2, 1))
plot(plt_left, plt_pose, size=(800, 400))
# gui()

# @gif for p in poses
#     plt_xy = plot(C; spacing=0.05, color=:black)
#     plot!(plt_xy, x, y)
#     plot!(p, color=3)
# end every 5
