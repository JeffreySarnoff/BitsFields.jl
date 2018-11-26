using Documenter, BitsFields

makedocs(
    modules = [BitsFields],
    sitename = "BitsFields",
    pages  = Any[
        "Introduction"             => "index.md",
        "The BitField"             => "thebitfield.md",
        ]
    )

deploydocs(
    repo = "github.com/JeffreySarnoff/BitsFields.jl.git",
    target = "build"
)
