# BitsFields.jl
#### Use adjacent bits as a bitfield. Use adjacent bitfields to copartition the useful.

----

#### Copyright ©&thinsp;2018 by Jeffrey Sarnoff. &nbsp;&nbsp; This work has been released under The MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/BitsFields.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/BitsFields.jl)

[![Coverage Status](https://coveralls.io/repos/github/JeffreySarnoff/BitsFields.jl/badge.svg?branch=master)](https://coveralls.io/github/JeffreySarnoff/BitsFields.jl?branch=master)
[![codecov.io](http://codecov.io/github/JeffreySarnoff/BitsFields.jl/coverage.svg?branch=master)](http://codecov.io/github/JeffreySarnoff/BitsFields.jl?branch=master)

-----

## Purpose

This package provides an easy way to describe and use bitfields within Julia.

## First Example

We want two bitfields, one that is six bits wide and another that is ten bits wide.

The total span for both bitfields is 6+10 == 16 bits, so a UInt16 will hold them.

```
using BitsFields

bitfield1span  =  6
bitfield1shift =  0
bitfield2span  = 10
bitfield2shift = bitfield1span

bitfield1 = BitField(UInt16, bitfield1span, bitfield1shift)
bitfield2 = BitField(UInt16, bitfield2span, bitfield2shift)

bitfields = BitFields(bitfield1, bitfield2)
```
Now we can set the fields and get their values.
```
thebitfields = Ref(UInt16)

bitfield1value = 0x15
bitfield2value = 0x02f6

set!(bitfields[1], bitfield1value, thebitfields)
set!(bitfields[2], bitfield2value, thebitfields)

get(bitfields[2], thebitfields)  # UInt16(0x02f6)

get(bitfields, thebitfields)     # [ UInt16(0x15), UInt16(0x02f6) ]
```
A bitfield may be changed, just set! it again.


## Use

```julia
using BitsFields

utype=UInt64;
#                          span      shift          bits used
bitfield1 = BitField(utype,  8,            0);   #      8
bitfield2 = BitField(utype,  4,            8);   #     12
bitfield3 = BitField(utype, 12,          4+8);   #     24
bitfield4 = BitField(utype, 16,       12+4+8);   #     40
bitfield5 = BitField(utype, 20,    16+12+4+8);   #     60
bitfield6 = BitField(utype,  4, 20+16+12+4+8);   #     64

bitfields = BitFields(bitfield1, bitfield2, bitfield3,
                      bitfield4, bitfield5, bitfield6);

valfield1 = 0xae;
valfield2 = 0x06;
valfield3 = 0x05f3;
valfield4 = 0x3113;
valfield5 = 0x7654;
valfield6 = 0x03;

target = Ref(zero(utype));

set!(bitfields[1], valfield1, target)
set!(bitfields[2], valfield2, target)
set!(bitfields[3], valfield3, target)
set!(bitfields[4], valfield4, target)
set!(bitfields[5], valfield5, target)
set!(bitfields[6], valfield6, target)

fields = get(bitfields, target)
#=
6-element Array{UInt64,1}:
 0x00000000000000ae
 0x0000000000000006
 0x00000000000005f3
 0x0000000000003113
 0x0000000000007654
 0x0000000000000003
=#

set!(bitfields[1], 0x12, target)
get(bitfields[1], target)
# 0x0000000000000012

```
