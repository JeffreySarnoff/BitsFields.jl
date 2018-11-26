struct ByRef{T}
   ref::Ref{T}
   
   function ByRef(x::Ref{T}) where {T}
       return new{T}(x)
   end
end

@inline function ByRef(::Type{T}) where {T}
    return ByRef(Ref(zero(T)))
end

@inline function ByRef(x::T) where {T}
    return ByRef(Ref(x))
end

@inline ref(x::ByRef{T}) where {T} = x.ref
@inline value(x::ByRef{T}) where {T} = x.ref[]

Base.show(io::IO, x::ByRef{T}) where {T} = show(io, x.ref[])

function set!(x::ByRef{T}, value::T) where {T} 
    x.ref[] = value
    return x
end

Base.get(x::ByRef{T}) where {T} = x.ref[]


Base.zero(::Type{ByRef{T}}) where {T} = ByRef(T)

Base.zero(x::ByRef{T}) where {T} = set!(x, zero(T))
