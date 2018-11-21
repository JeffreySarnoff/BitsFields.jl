using Documenter, BitsFields

makedocs(
    modules = [BitsFields],
    format = :html,
    sitename = "BitsFields",
    pages    = Any[
        "Introduction"             => "index.md",
        "The BitField"             => "thebitfield.md",
        "The BitField, Named"      => "thebitfieldnamed.md",
        "MultiFields"              => "multifields.md",
        "MultiFields, Named"       => "multifieldsnamed.md",
        "References"               => "references.md",
        "Index"                    => "index.md",
        ]
    )

deploydocs(
    repo = "github.com/JeffreySarnoff/BitsFields.jl.git",
    target = "build",
    julia  = "1.0",
    osname = "linux",
    deps = nothing,
    make = nothing
)