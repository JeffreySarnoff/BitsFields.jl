using Base: IEEEFloat, unsigned, sign_mask, exponent_mask, significand_mask

using BitsFields
using BitsFields: bitsof

Base.unsigned(::Type{Float64}) = UInt64
Base.unsigned(::Type{Float32}) = UInt32
Base.unsigned(::Type{Float16}) = UInt16


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




"""
    fieldspan

How many bits does this field span?

The tally of 1-bits in the field's mask gives its span.
All bits of a bitfield are adjacent to at least one other
bit within the bitfield. Interior bits, if any (if the
bitfield has a span of three or more), are adjacent to
two bits within bitfield.

To tally the 1-bits, we subtract any leading 0-bits
and subtract any trailing 0-bits from the
number of bits provided and given by the value_store.
(This way, no reliance on tabulated values is needed.
 We stay within the information availablilty of Julia.)
""" 
fieldspan(::Type{T}, fieldmask) where {T<:IEEEFloat} =
    bitsof(T) - leading_zeros(fieldmask(T)) - trailing_zeros(fieldmask(T))

"""
    fieldshift

By how many bits is this field shifted?
   - how far is the least significant bit of the field
     from the least significant bit of all the fields

To determine the number of bits over which a bitfield
is shifted (from low-order bits to high-order bits),
we count the empty bit positions that trail the bitfield.
"""
fieldshift(::Type{T}, fieldmask) where {T<:IEEEFloat} =
   trailing_zeros(fieldmask(T))



sign64 = BitField(UInt64, fieldspan(Float64, sign_mask), fieldshift(Float64, sign_mask), :sign)
exponent64 = BitField(UInt64, fieldspan(Float64, exponent_mask), fieldshift(Float64, exponent_mask), :exponent)
significand64  = BitField(UInt64, fieldspan(Float64, significand_mask), fieldshift(Float64, significand_mask), :significand)

float64 = BitFields(sign64, exponent64, significand64)

sign32 = BitField(UInt32, fieldspan(Float32, sign_mask), fieldshift(Float32, sign_mask), :sign)
exponent32 = BitField(UInt32, fieldspan(Float32, exponent_mask), fieldshift(Float32, exponent_mask), :exponent)
significand32  = BitField(UInt32, fieldspan(Float32, significand_mask), fieldshift(Float32, significand_mask), :significand)

float32 = BitFields(sign32, exponent32, significand32)



BitField(::Type{T}, mask::Function, name::Symbol) where {T<:IEEEFloat} =
    BitField(unsigned(T), fieldspan(T, mask), fieldshift(T, mask), name)

sign64 = BitField(Float64, sign_mask, :sign)
exponent64 = BitField(Float64, exponent_mask, :exponent)
significand64 = BitField(Float64, significand_mask, :significand)

float64 = BitFields(sign64, exponent64, significand64)

sign32 = BitField(Float32, sign_mask, :sign)
exponent32 = BitField(Float32, exponent_mask, :exponent)
significand32 = BitField(Float32, significand_mask, :significand)

float32 = BitFields(sign32, exponent32, significand32)







###################################################################

for N in (64, 32, 16)
  for (Field, Mask) in ( (:sign, :sign_mask), 
                         (:exponent, :exponent_mask), 
                         (:significand, :significand_mask) )
    @eval begin
      float_type = $(Symbol(:Float,N))
      uint_type  = $(Symbol(:UInt,N))
      $(Symbol(Field,N)) = BitField(uint_type,
                                    fieldspan(float_type, $Mask), 
                                    fieldshift(float_type, $Mask), 
                                    Symbol($Field))
    end
  end
end


float64 = NamedTuple(BitFields(sign64, exponent64, significand64))
float32 = NamedTuple(BitFields(sign32, exponent32, significand32))
float16 = NamedTuple(BitFields(sign16, exponent16, significand16))


function mulbytwo(x::FP{T,U}) where {T<:IEEEFloat,U}
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


fpvalue = Ref(reinterpret(UInt64, inv(sqrt(Float64(2.0)))))

set!(float64.exponent,
     get(float64.exponent,fpvalue) + 1,
     fpvalue)

reinterpret(Float64,fpvalue[])
1.414213562373095

