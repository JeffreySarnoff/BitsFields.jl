"""
    BitCount

type used to hold bit counts and shift amounts
"""
const BitCount = Int16

"""
    BitField

The structured BitField.

fields:
    nbits
    shift
    maskof1s
    maskof0s
    name::Symbol
"""
struct BitField{U}
    nbits::BitCount
    shift::BitCount
    maskof1s::U
    maskof0s::U
    name::Symbol
end

Base.eltype(::Type{BitField{U}}) where {U} = U
Base.eltype(x::BitField{U}) where {U} = U

name(x::BitField{U}) where {U<:UBits} = x.name
nbits(x::BitField{U}) where {U<:UBits} = x.nbits
shift(x::BitField{U}) where {U<:UBits} = x.shift
maskof1s(x::BitField{U}) where {U<:UBits} = x.maskof1s
maskof0s(x::BitField{U}) where {U<:UBits} = x.maskof0s



function BitField(::Type{U}, bitspan::Int, bitshift::Int, name::Symbol) where {U<:UBits}
    span  = BitCount(bitspan)
    shift = BitCount(bitshift)
    validate(U, span, shift)

    maskof1s = onebits(U, span, shift)
    maskof0s = ~maskof1s
    return BitField{U}(span, shift, maskof1s, maskof0s, name)
end

BitField(::Type{U}, name::Symbol, bitspan::Int, bitshift::Int) where {U<:UBits} =
    BitField(U, bitspan, bitshift, name)

BitField(bitspan::Int, bitshift::Int, name::Symbol) = BitField(UInt64, bitspan, bitshift, name)

BitField(name::Symbol, bitspan::Int, bitshift::Int) = BitField(UInt64, bitspan, bitshift, name)


@inline function isolate(bitfield::BitField{U}, source::U) where {U<:UBits}
    return source & bitfield.maskof1s
end

@inline function filter(bitfield::BitField{U}, source::U) where {U<:UBits}
    return source & bitfield.maskof0s
end

@inline function Base.get(bitfield::BitField{U}, source::U) where {U<:UBits}
    return isolate(bitfield, source) >> bitfield.shift
end

@inline function Base.get(bitfield::BitField{U}, source::Base.RefValue{U}) where {U<:UBits}
    return isolate(bitfield, source[]) >> bitfield.shift
end

@inline function put(bitfield::BitField{U}, value::U) where {U<:UBits}
    value << bitfield.shift
end

@inline function set(bitfield::BitField{U}, value::U, target::U)  where {U<:UBits}
    filter(bitfield, target) | put(bitfield, value)
end

@inline function set!(bitfield::BitField{U}, value::U, target::Base.RefValue{U})  where {U<:UBits}
    target[] = set(bitfield, value, target[])
    return nothing
end

set(bitfield::BitField{U}, value::UBits, target::U) where {U<:UBits} =
    set(bitfield, value%U, target)

set!(bitfield::BitField{U}, value::UBits, target::Base.RefValue{U})  where {U<:UBits} =
    set!(bitfield, value%U, target)


function validate(::Type{U}, bitspan::Integer, bitshift::Integer) where {U<:UBits}
    if !(bitspan > 0 && bitspan + bitshift <= bitsof(U))
        if bitspan <= 0
            throw(ErrorException("bitspan ($bitspan) must be > 0"))
        else
            throw(ErrorException("bitspan + bitshift > totalbits: $bitspan + $bitshift > $(bitsizeof(U))"))
        end
    end
    return nothing
end


onebits(::Type{T}, bitspan::I, bitshift::I) where {T<:UBits, I<:Integer} =
    ~(~zero(T) << bitspan) << bitshift
