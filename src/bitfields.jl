struct BitFields{N,U}    # N BitField{U} fields
   bitfields::NTuple{N,BitField{U}}

   function BitFields(bitfields::Vararg{BitField{U}, N}) where {N,U}
       return new{N,U}(bitfields)
   end
end

Base.length(x::BitFields{N,U}) where {N,U} =
    length(x.bitfields)

Base.lastindex(x::BitFields{N,U}) where {N,U} =
    lastindex(x.bitfields)

Base.getindex(x::BitFields{N,U}, idx::Int) where {N,U} =
    getindex(x.bitfields, idx)

Base.getindex(x::BitFields{N,U}, idxs::AbstractRange{Int}) where {N,U} =
    getindex(x.bitfields, idxs)
