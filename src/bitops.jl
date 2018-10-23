bitsizeof(::Type{T}) where {T} = sizeof(T) * 8
bitsizeof(x::T) where {T} = bitsizeof(T)

onebits(::Type{T}, bitspan::Int, bitshift::Int) where {T<:Unsigned} =
    ~(~zero(T) << bitspan) << bitshift
