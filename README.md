# BitsFields.jl
using adjacent bits as fields

## example
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
```
