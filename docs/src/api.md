# API

```@contents
Depth=1
```

## [Curve Types](@id API Curve Types)

[`Curve`](@ref)\
[`LineSegment`](@ref)\
[`ArcSegment`](@ref)\
[`Clothoid`](@ref)\
[`PolyCurve`](@ref)\

```@docs
Curve
LineSegment
ArcSegment
Clothoid
PolyCurve
```

## [Curve Interface](@id API Curve Interface)

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

```@docs
smax
point
startpoint
endpoint
dpoint
length
dlength
curvature
dcurvature
tangentangle
radialangle
```

## Curve specific functions

### [LineSegment](@id API LineSegment)

```@docs
direction(C::LineSegment)
```

### [ArcSegment](@id API ArcSegment)

```@docs
sign(C::ArcSegment)
```

### [Clothoid](@id API Clothoid)

```@docs
SmoothCurves.fresnel
SmoothCurves.standardlength
```

### [PolyCurve](@id API PolyCurve)

```@docs
SmoothCurves.subcurveindex
SmoothCurves.subcurveparameter
SmoothCurves.dispatch
```
