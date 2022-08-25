module BitsFields

export BitField, BitFields

const CountType = UInt16

struct BitField{T<:Base.BitInteger}
    underlying::T     # underlying type
    field0s::T        # filters field in place
    field1s::T        # masks   field in place
    mask0s::T         # filters field in lsbs
    mask1s::T         # masks   field in lsbs
    nbits::CountType  # bitwdith of field
    shift::CountType  # shift from lsbs to field
end # BitsFields

struct BitFields{N,T}
    fields::NTuple{N,BitField{T}}
end

BitMasks(::Type{T}) where T = Tuple(map(T, 1:bitsof(T)))

BitFields(underlying::T, NTuple{N,NamedTuple{(:value, :nbits, :shift)
end  # BitsFields
