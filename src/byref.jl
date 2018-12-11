struct ByRef{S,T}
   ref::Ref{T}
   
   function ByRef(::Type{S}, x::Ref{T}) where {S,T}
       return new{S,T}(x)
   end
end

@inline function ByRef(::Type{S}, ::Type{T}) where {S,T}
    return ByRef(S, Ref(zero(T)))
end

@inline function ByRef(::Type{S}, x::T) where {S,T}
    return ByRef(S, Ref(x))
end

@inline sourcetype(x::ByRef{S,T}) where {S,T} = S
@inline carriertype(x::ByRef{S,T}) where {S,T} = T

@inline ref(x::ByRef{S,T}) where {S,T} = x.ref
@inline val(x::ByRef{S,T}) where {S,T} = x.ref[]

@inline value(x::ByRef{S,T}) where {S,T} = reinterpret(sourcetype(x), val(z16))


Base.show(io::IO, x::ByRef{S,T}) where {S,T} = show(io, reinterpret(S,x.ref[]))

function set!(x::ByRef{S,T}, value::T) where {S,T} 
    x.ref[] = value
    return x
end

Base.get(x::ByRef{S,T}) where {S,T} = x.ref[]

Base.zero(::Type{ByRef{S,T}}) where {S,T} = ByRef(S,T)

Base.zero(x::ByRef{S,T}) where {S,T} = set!(x, zero(T))
