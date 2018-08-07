# Construction

```@example
using SmoothCurves
using Plots

# Define Polygon points
points = [
    [0, 0],
    [4, 0],
    [2, 2],
    [7, 3],
    [8, 1],
    [6, -2]
]

# Construct curve consisting of line segments and clothoids
dmax = 0.5
C1 = construction.curve(dmax, points)

# Plot Polygon points
x = [p[1] for p in points]
y = [p[2] for p in points]
scatter(x, y, label="")
plot!(x, y, label="", ls=:dash, color=:black, alpha=0.3)

# Plot curve
plot!(C1, lc=1)
```