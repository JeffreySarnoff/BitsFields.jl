
using Base: IEEEFloat, unsigned, sign_mask, exponent_mask, significand_mask

using BitsFields

Base.unsigned(::Type{Float64}) = UInt64
Base.unsigned(::Type{Float32}) = UInt32
Base.unsigned(::Type{Float16}) = UInt16




"""
    fieldspan

How many bits does this field span?
""" 
fieldspan(::Type{T}, fieldmask) where {T<:IEEEFloat} =
   bitsof(T) - leading_zeros(fieldmask(T)) - trailing_zeros(fieldmask(T))

"""
    fieldshift

By how many bits is this field shifted?
   - how far is the least significant bit of the field
     from the least significant bit of all the fields
"""
fieldshift(::Type{T}, fieldmask) where {T<:IEEEFloat} =
   trailing_zeros(fieldmask(T))


UI = UInt64
FP = float(UI) # Float64

for (Field, Name, Mask) in ( (:signfield, :sign, :sign_mask), 
                             (:exponentfield, :exponent, :exponent_mask), 
                             (:significandfield, :significand, :significand_mask) )
    @eval begin
        $Field = BitField(UI, fieldspan(FP, $Mask), fieldshift(FP, $Mask), Symbol($Name))
    end
end

float64bits = BitFields(signfield, exponentfield, significandfield)

float64 = NamedTuple(float64bits);

function mulbytwo(x::FP{T,U}) where {T<:IEEEFloat}
    originalexponent = get(exponent(T), UNSIGNED(x))
    # check for potential overflow
    if originalexponent === exponentfield.ones
        throw(OverflowError("$(x.fp) * 2"))
    end
    
    mulbytwoexponent = originalexponent + one(U)
    set!(exponent(T), mulbytwoexponent, x.unsigned)
    x.floating = reinterpret(T, x.unsigned)
    
    return x
end




mutable struct FP{T,U}
    floating::T
    unsigned::U
end

value(x::FP{T,U}) where {T,U} = x.floating

FP(x::T) where {T<:IEEEFloat} = FP{T,unsigned(T)}(x, reinterpret(unsigned(T), x))
FP(x::U) where {U<:Unsigned}  = FP{float(U),U}(reinterpret(float(T), x), x)

Base.show(io::IO, x::FP{T,U}) where {T,U} = show(io, value(x))

Base.:(+)(x::T, fp::FP{T,U}) where {T,U} = x + value(fp)
Base.:(+)(x::FP{T,U}, y::FP{T,U}) where {T,U} = FP(value(x) + value(y))



fpvalue = Ref(reinterpret(UInt64, inv(sqrt(Float64(2.0)))))

set!(float64.exponent,
     get(float64.exponent,fpvalue) + 1,
     fpvalue)

reinterpret(Float64,fpvalue[])
1.414213562373095

