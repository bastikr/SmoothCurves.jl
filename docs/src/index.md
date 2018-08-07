# SmoothCurves.jl

Create smooth curves, e.g. usable for mobile robot path following.

```@example # hide
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
C1 = construction.curve(dmax, points) # hide

# Plot Polygon points # hide
x = [p[1] for p in points] # hide
y = [p[2] for p in points] # hide
scatter(x, y, label="") # hide
plot!(x, y, label="", ls=:dash, color=:black, alpha=0.3) # hide

# Plot curve # hide
plot!(C1, lc=1) # hide

plot!(axis=false, grid=false) # hide
savefig("demoplot.svg") # hide
plot!() # hide
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
