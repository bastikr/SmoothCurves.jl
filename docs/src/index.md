# SmoothCurves.jl

Create parameterized smooth curves, e.g. usable for mobile robot path following.

```@example intro
using SmoothCurves # hide
using Plots # hide

# Define Polygon points # hide
points = [ # hide
    [0, 0], # hide
    [4, 0], # hide
    [2, 2], # hide
    [7, 3], # hide
    [8, 1], # hide
    [6, -2] # hide
] # hide

# Construct curve consisting of line segments and clothoids # hide
dmax = 0.5 # hide
C = construction.curve(dmax, points) # hide

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

Besides the ``x(s), y(s)`` coordinates, many other quantities are available:

```@example intro
svec = [0:0.01:smax(C);] # hide

ϕ = tangentangle.(C, svec) # hide
p0 = plot(svec, ϕ, xlabel="s", ylabel="tangentangle", label="") # hide

θ = radialangle.(C, svec) # hide
p1 = plot(svec, θ, xlabel="s", ylabel="radialangle", label="") # hide

κ = curvature.(C, svec) # hide
p2 = plot(svec, κ, xlabel="s", ylabel="curvature", label="") # hide

dκ = dcurvature.(C, svec) # hide
p3 = plot(svec, dκ, xlabel="s", ylabel="dcurvature", label="") # hide

plot(p0, p1, p2, p3, layout=(2, 2)) # hide
```

## Curve Types

[`Curve`](@ref)\
[Clothoid](@ref)\
[LineSegment](@ref)\
[ArcSegment](@ref)


## Curve Interface

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
[`radialangle`](@ref)\
