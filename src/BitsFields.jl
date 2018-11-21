module BitsFields

export BitField, BitFields, set!

"""
    MaybeSymbol

allow names, rather than require them
"""
const MaybeSymbol = Union{Nothing, Symbol}

"""
    UBits

unsigned types available to hold multiple bitfields
"""
const UBits = Union{UInt128, UInt64, UInt32, UInt16, UInt8}

"""
    bitsof

as sizeof is with bytes, bitsof is with bits
"""
bitsof(::Type{T}) where {T} = sizeof(T) * 8


include("bitfield.jl")
include("bitfields.jl")

end # BitsFields
