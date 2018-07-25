# SmoothCurves.jl

[![Travis build status][travis-img]][travis-url]
[![Test coverage status on coveralls][coveralls-img]][coveralls-url]
[![Test coverage status on codecov][codecov-img]][codecov-url]

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


[travis-url]: https://travis-ci.com/bastikr/SmoothCurves.jl
[travis-img]: https://travis-ci.com/bastikr/SmoothCurves.jl.svg?branch=master

[coveralls-url]: https://coveralls.io/github/bastikr/SmoothCurves.jl?branch=master
[coveralls-img]: https://coveralls.io/repos/github/bastikr/SmoothCurves.jl/badge.svg?branch=master

[codecov-url]: https://codecov.io/gh/bastikr/SmoothCurves.jl
[codecov-img]: https://codecov.io/gh/bastikr/SmoothCurves.jl/branch/master/graph/badge.svg
