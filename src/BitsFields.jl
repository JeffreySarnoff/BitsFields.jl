module BitsFields

export BitField, BitFields

const UBits = Union{UInt128,UInt64,UInt32,UInt16,UInt8}

include("bitfield.jl")
include("bitfields.jl")

include("bitops.jl")

end # BitsFields
