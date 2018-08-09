# SmoothCurves.jl

Create parameterized smooth curves, e.g. usable for mobile robot path following.

This library provides a few elementary curve types,

[Clothoid](@ref)\
[LineSegment](@ref)\
[ArcSegment](@ref)

and the possibility to chain them together as [PolyCurve](@ref). All curves implement the [Curve](@ref) interface:

[`smax`](@ref)\
[`point`](@ref)\
[`startpoint`](@ref)\
[`endpoint`](@ref)\
[`dpoint`](@ref)\
[`length`](@ref)\
[`dlength`](@ref)\
[`curvature`](@ref)\
[`dcurvature`](@ref)\
[`tangentangle`](@ref)\
[`radialangle`](@ref)

Additionally, [Construction](@ref) methods which generate smooth curves from given polygon paths are provided.

```@example intro
using SmoothCurves
using Plots # hide

# Define Polygon points
points = [
    [0, 0],
    [4, 0],
    [2, 2],
    [7, 3],
    [8, 1],
    [6, -2]
]

# Construct curve consisting of line segments and clothoids # hide
dmax = 0.5
C = construction.curve(dmax, points)

# Plot Polygon points # hide
x = [p[1] for p in points] # hide
y = [p[2] for p in points] # hide
scatter(x, y, label="") # hide
plot!(x, y, label="", ls=:dash, color=:black, alpha=0.3) # hide

# Plot curve # hide
plot!(C, lc=1) # hide

plot!(axis=false, grid=false) # hide
savefig("demoplot.svg") # hide
plot!() # hide
```

Besides the ``x(s), y(s)`` coordinates, many other quantities are available.

```@example intro
svec = [0:0.01:smax(C);]
ϕ = tangentangle.(C, svec)
p0 = plot(svec, ϕ, xlabel="s", ylabel="tangentangle", label="") # hide
θ = radialangle.(C, svec)
p1 = plot(svec, θ, xlabel="s", ylabel="radialangle", label="") # hide
κ = curvature.(C, svec)
p2 = plot(svec, κ, xlabel="s", ylabel="curvature", label="") # hide
dκ = dcurvature.(C, svec)
p3 = plot(svec, dκ, xlabel="s", ylabel="dcurvature", label="") # hide
plot(p0, p1, p2, p3, layout=(2, 2)) # hide
```
