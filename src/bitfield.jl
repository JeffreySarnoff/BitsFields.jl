const BitCount = Int16

struct BitField{U}
    nbits::BitCount
    shift::BitCount
    maskof1s::U
    maskof0s::U
    symbol::Symbol
end

Base.eltype(::Type{BitField{U}}) where {U} = U
Base.eltype(x::BitField{U}) where {U} = U

symbol(x::BitField{U}) where {U<:UBits} = x.symbol

function BitField(::Type{U}, bitspan::Int, bitshift::Int, symbol::Symbol) where {U<:UBits}
    span  = BitCount(bitspan)
    shift = BitCount(bitshift)
    validate(U, span, shift)

    maskof1s = onebits(U, span, shift)
    maskof0s = ~maskof1s
    return BitField{U}(span, shift, maskof1s, maskof0s, symbol)
end

BitField(::Type{U}, symbol::Symbol, bitspan::Int, bitshift::Int) where {U<:UBits} =
    BitField(U, bitspan, bitshift, symbol)

BitField(bitspan::Int, bitshift::Int, symbol::Symbol) = BitField(UInt64, bitspan, bitshift, symbol)

BitField(symbol::Symbol, bitspan::Int, bitshift::Int) = BitField(UInt64, bitspan, bitshift, symbol)



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
    if !(bitspan > 0 && bitspan + bitshift <= bitsizeof(U))
        if bitspan <= 0
            throw(ErrorException("bitspan ($bitspan) must be > 0"))
        else
            throw(ErrorException("bitspan + bitshift > totalbits: $bitspan + $bitshift > $(bitsizeof(U))"))
        end
    end
    return nothing
end


bitsizeof(::Type{T}) where {T} = sizeof(T) * 8

onebits(::Type{T}, bitspan::I, bitshift::I) where {T<:UBits, I<:Integer} =
    ~(~zero(T) << bitspan) << bitshift
