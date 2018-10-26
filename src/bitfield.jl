const BitCount = Int16

struct BitField{U}
    nbits::BitCount
    shift::BitCount
    maskof1s::U
    maskof0s::U
end

function BitField(::Type{U}, bitspan::Int, bitshift::Int) where {U<:UBits}
    span  = BitCount(bitspan)
    shift = BitCount(bitshift)
    validate(U, span, shift)

    maskof1s = onebits(U, span, shift)
    maskof0s = ~maskof1s
    return BitField{U}(span, shift, maskof1s, maskof0s)
end


function isolate(source::U, bitfield::BitField{U}) where {U<:UBits}
    return source & bitfield.maskof1s
end

function Base.get(source::U, bitfield::BitField{U}) where {U<:UBits}
    return isolate(source, bitfield) >> bitfield.shift
end

function filter(source::U, bitfield::BitField{U}) where {U<:UBits}
    return source & bitfield.maskof0s
end

function put(value::U, bitfield::BitField{U}) where {U<:UBits}
    value << bitfield.shift
end

function set(target::U, value::U, bitfield::BitField{U})  where {U<:UBits}
    filter(target, bitfield) | put(value, bitfield)
end


function Base.set!(target::Base.RefValue{U}, value::U, bitfield::BitField{U})  where {U<:UBits}
    target[] = filter(target[], bitfield) | put(value, bitfield)
    return nothing
end

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
