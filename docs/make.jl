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

deploydocs(
    repo="github.com/bastikr/SmoothCurves.jl.git",
    julia="0.6",
    target="build",
    make=()->nothing,
    deps=Deps.pip()
)
