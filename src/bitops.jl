bitsizeof(::Type{T}) where {T} = sizeof(T) * 8

onebits(::Type{T}, bitspan::I, bitshift::I) where {T<:UBits, I<:Integer} =
    ~(~zero(T) << bitspan) << bitshift
