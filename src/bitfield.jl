const BitUInt = Int16

struct UIntBits{U}
    nbits::BitUInt
    shift::BitUInt
    maskof1s::U
    maskof0s::U
end

function UIntBits(::Type{U}, bitspan::Int, bitshift::Int) where {U<:BitUInt}
    span  = BitUInt(bitspan)
    shift = BitUInt(bitshift)
    validate(U, span, shift)

    maskof1s = onebits(U, span, shift)
    maskof0s = ~maskof1s
    return UIntBits{U}(span, shift, maskof1s, maskof0s)
end


function isolate(source::U, bitfield::UIntBits{U}) where {U<:BitUInt}
    return source & bitfield.maskof1s
end

function Base.get(source::U, bitfield::UIntBits{U}) where {U<:BitUInt}
    return isolate(source, bitfield) >> bitfield.shift
end

function filter(source::U, bitfield::UIntBits{U}) where {U<:BitUInt}
    return source & bitfield.maskof0s
end

function put(value::U, bitfield::UIntBits{U}) where {U<:BitUInt}
    value << bitfield.shift
end

function set(target::U, value::U, bitfield::UIntBits{U})  where {U<:BitUInt}
    filter(target, bitfield) | put(value, bitfield)
end


function validate(::Type{U}, bitspan::Integer, bitshift::Integer) where {U<:BitUInt}
    if !(bitspan > 0 && bitspan + bitshift <= bitsizeof(U))
        if bitspan <= 0
            throw(ErrorException("bitspan ($bitspan) must be > 0"))
        else
            throw(ErrorException("bitspan + bitshift > totalbits: $bitspan + $bitshift > $(bitsizeof(U))"))
        end
    end
    return nothing
end
