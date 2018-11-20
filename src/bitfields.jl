struct BitFields{N,U}    # N BitField{U} fields
   bitfields::NTuple{N,BitField{U}}

   function BitFields(bitfields::Vararg{BitField{U}, N}) where {N,U}
       return new{N,U}(bitfields)
   end
end


Base.eltype(::Type{BitFields{N,U}}) where {N,U} = U
Base.eltype(x::BitFields{N,U}) where {N,U} = U

Base.length(x::BitFields{N,U}) where {N,U} = N

Base.lastindex(x::BitFields{N,U}) where {N,U} =
    lastindex(x.bitfields)

Base.getindex(x::BitFields{N,U}, idx::Int) where {N,U} =
    getindex(x.bitfields, idx)

Base.getindex(x::BitFields{N,U}, idxs::AbstractRange{Int}) where {N,U} =
    getindex(x.bitfields, idxs)

function Base.iterate(x::BitFields{N,U}) where {N,U<:UBits}
    if length(x) > 0
       x[1], 2
    else
       nothing
    end
end

function Base.iterate(x::BitFields{N,U}, state::Int) where {N,U<:UBits}
    if state > length(x)
       nothing
    else
       x[state], state+1
    end
end

Base.get(bitfields::BitFields{N,U}, bits::Ref{U}) where {N,U<:UBits} = [get(bitfield, bits) for bitfield in bitfields]
Base.get(bitfields::BitFields{N,U}, bits::U) where {N,U<:UBits} = [get(bitfield, bits) for bitfield in bitfields]

symbol(bitfields::BitFields{N,U}) where {N,U<:UBits} = [symbol(bitfield) for bitfield in bitfields]
symbols(bitfields::BitFields{N,U}) where {N,U<:UBits} = ((symbol(bitfield) for bitfield in bitfields)...,)

function Base.NamedTuple(bitfields::BitFields{N,U}) where {N,U<:UBits}
   names  = symbols(bitfields)
   fields = [bitfields...,]
   nt = NamedTuple{names,NTuple{N,BitField}}(fields)
   return nt
end
