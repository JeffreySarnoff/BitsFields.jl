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


valfield1 = 0xae;
valfield2 = 0x06;
valfield3 = 0x05f3;
valfield4 = 0x3113;
valfield5 = 0x7654;
valfield6 = 0x03;

target = Ref(zero(utype))

set!(bitfields[1], valfield1, target);
set!(bitfields[2], valfield2, target);
set!(bitfields[3], valfield3, target);
set!(bitfields[4], valfield4, target);
set!(bitfields[5], valfield5, target);
set!(bitfields[6], valfield6, target);

@test get(bitfield1, target) == valfield1
@test get(bitfield2, target) == valfield2
@test get(bitfield3, target) == valfield3
@test get(bitfield4, target) == valfield4
@test get(bitfield5, target) == valfield5
@test get(bitfield6, target) == valfield6

fields = get(bitfields, target);

@test fields[1] == valfield1
@test fields[2] == valfield2
@test fields[3] == valfield3
@test fields[4] == valfield4
@test fields[5] == valfield5
@test fields[6] == valfield6
