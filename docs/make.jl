using SmoothCurves
using Documenter

using StaticArrays

makedocs(
    sitename="SmoothCurves.jl",
    format=:html,
    modules=[SmoothCurves],
    pages=[
        "Introduction" => "index.md",
        "Curves" => [
            "Interface" => "curve.md",
            "polycurve.md",
            "linesegment.md",
            "arcsegment.md",
            "clothoid.md"
        ],
        "frenetframe.md",
        "construction.md",
        "API" => "api.md"
    ]
)

deploydocs(
    repo="github.com/bastikr/SmoothCurves.jl.git",
    julia="0.6",
    target="build",
    make=()->nothing,
    deps=Deps.pip()
)
