struct UIntFields{N,U}    # N UIntBits{U} fields
   bitfields::NTuple{N,UIntBits{U}}

   function UIntFields(bitfields::Vararg{UIntBits{U}, N}) where {N,U}
       return new{N,U}(bitfields)
   end
end

Base.length(x::UIntFields{N,U}) where {N,U} =
    length(x.bitfields)

Base.lastindex(x::UIntFields{N,U}) where {N,U} =
    lastindex(x.bitfields)

Base.getindex(x::UIntFields{N,U}, idx::Int) where {N,U} =
    getindex(x.bitfields, idx)

Base.getindex(x::UIntFields{N,U}, idxs::AbstractRange{Int}) where {N,U} =
    getindex(x.bitfields, idxs)
