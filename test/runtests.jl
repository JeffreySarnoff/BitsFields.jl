using BitsFields
using Test

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

@test bitfield3 == bitfields[3]
@test (bitfield4, bitfield5) == bitfields[4:5]

try
   BitField(UInt16, 7, 10)
   @test false
catch
   @test true
end
