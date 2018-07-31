using SmoothCurves
using Documenter

using StaticArrays

makedocs(
    sitename="SmoothCurves.jl",
    format=:html,
    modules=[SmoothCurves],
    pages=[
        "index.md",
        "clothoid.md",
        "API" => "api.md"
    ]
)
