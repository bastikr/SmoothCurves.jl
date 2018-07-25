# SmoothCurves.jl

Create smooth curves from basic curve types.


Implemented basic curves:

* Line
* Arc
* Clothoid
* PolyCurve


All curves `C` are parametrized ba a parameter `s` in the interval `[0, smax]`.

Curve Interface:
* `smax(C)`
* `length(C)`
* `length(C, s)`
* `dlength(C, s)`
* `tangentangle(C, s)`
* `curvature(C, s)`
* `dcurvature(C, s)`
* `point(C, s)`
* `dpoint(C, s)`

All derivatives are given in respect to the parameter `s`.
