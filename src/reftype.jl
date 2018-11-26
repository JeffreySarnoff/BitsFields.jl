struct ByRef{T}
   value::Ref{T}
   
   function ByRef(x::T) where {T}
       return new{T}(Ref(x))
   end
end

@inline function ByRef(::Type{T}) where {T}
    return new{T}(Ref(zero(T)))
end
   
@inline value(x::ByRef{T}) where {T} = x.value
@inline val(x::ByRef{T}) where {T} = x.value[]

Base.show(io::IO, x::ByRef{T}) where {T} = show(io, val(x))

function set(x::ByRef{T}, val::T) where {T} 
    x.value[] = val
    return x
end

Base.get(x::ByRef{T}) where {T} = val(x)

Base.zero(x::ByRef{T}) where {T} = set(x, zero(T))
