
using Documenter, BitsFields

makedocs(
    modules = [BitsFields],
    sitename = "BitsFields",
    pages  = Any[
        "Introduction"             => "index.md",
        "The BitField"             => "thebitfield.md",
        "The BitField, Named"      => "thebitfieldnamed.md",
        "MultiFields"              => "multifields.md",
        "MultiFields, Named"       => "multifieldsnamed.md",
        "Worked Use"               => "workeduse.md",
        "IEEE Standard 754-2008"   => "ieeestandard754-2008.md",
        "References"               => "references.md",
        "Index"                    => "documentindex.md"
        ]
    )

deploydocs(
    repo = "github.com/JeffreySarnoff/BitsFields.jl.git",
    target = "build"
)
