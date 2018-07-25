# SmoothCurve.jl

Create smooth curves from basic curve types.

Implemented basic curves:

    * Line
    * Arc
    * Clothoid
    * PolyCurve (Combination of other curves)

All curves `C` are parametrized ba a parameter `s` in the interval `[0, smax]`.

Curve Interface:

    * `smax(C)`
    * `length(C)`
    * `length(C, s)`
        length of the curve from 0 to `s`
    * `dlength(C, s)`
        $\frac{dl}{ds}$
    * `tangentangle(C, s)`
    * `curvature(C, s)`
    * `dcurvature(C, s)`
        $\frac{d\kappa}{ds}$
    * `point(C, s)`
        `(x, y)` values given as `StaticArray::SVector`
    * `dpoint(C, s)`
        `(dx/ds, dy/ds)` values given as `StaticArray::SVector`
