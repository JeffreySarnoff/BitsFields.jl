bitsizeof(::Type{T}) where {T} = sizeof(T) * 8

onebits(::Type{T}, bitspan::Int, bitshift::Int) where {T<:Unsigned} =
    ~(~zero(T) << bitspan) << bitshift
