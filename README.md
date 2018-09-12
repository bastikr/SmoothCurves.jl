# SmoothCurves.jl

[![Stable Docs][docs-stable-img]][docs-stable-url]
[![Latest Docs][docs-latest-img]][docs-latest-url]
[![Travis build status][travis-img]][travis-url]
[![Test coverage status on codecov][codecov-img]][codecov-url]

Create smooth curves from basic curve types.


Implemented basic curves:

* Line
* ArcSegment
* Clothoid
* PolyCurve


All curves `C` are parametrized ba a parameter `s` in the interval `[0, smax]`.

Curve Interface:
* `smax(C)`
* `length(C)`
* `length(C, s)`
* `dlength(C, s)`
* `tangentangle(C, s)`
* `radialangle(C, s)`
* `curvature(C, s)`
* `dcurvature(C, s)`
* `point(C, s)`
* `startpoint(C)`
* `endpoint(C)`
* `dpoint(C, s)`
* `samples(C, e)`

All derivatives are given in respect to the parameter `s`.


[docs-stable-img]:https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]:https://bastikr.github.io/SmoothCurves.jl/stable/index.html

[docs-latest-img]:https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]:https://bastikr.github.io/SmoothCurves.jl/latest/index.html

[travis-url]: https://travis-ci.com/bastikr/SmoothCurves.jl
[travis-img]: https://travis-ci.com/bastikr/SmoothCurves.jl.svg?branch=master

[codecov-url]: https://codecov.io/gh/bastikr/SmoothCurves.jl
[codecov-img]: https://codecov.io/gh/bastikr/SmoothCurves.jl/branch/master/graph/badge.svg
