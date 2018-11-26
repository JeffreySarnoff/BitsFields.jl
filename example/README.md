BitFields conforming to the IEEE Floating Point Standard


Standards conformant binary floating point represenentations
have "three componants: a sign, an exponent, and a significand" [§2.1.26]

The _sign_ is encoded in the most significant bit of the value_store.
The bitfield for the floating-point sign (nonnegative or negative)
has a span of 1 bit and a shift of `bitsof(value_store) - 1`
(shifting 1 bit placed in the least significant bit of the value_store
by bitsof(value_store) bit positions would shift it out of the value_store).

The exponent is encoded in a bitfield that follows the sign's bitfield.
The exponent bitfield is adjacent to the sign bitfield, from below
(where `below` means that the sign bitfield occupies a more significant
position in the value_store than does the exponent bitfield; with
respect to positional significance, the exponent bitfield follows
the sign bitfield).  The span of the exponent bitfield is given
by fiat in the Standard (see table 3.2).

The shift of the exponent bitfield is less than the shift of the
sign bitfield, as that field occupies a more significant (the most
significant) position in the value_store.  How much less is the 
shift of the exponent bitfield, exactly as many as there are
bits in the exponent bitfield.  The shift of the exponent BitField
can be ascertained as
`bitsof(value_store) - 1 - span of exponent bitfield`.

The span of the significand bitfield is mandated, too.
The least significant bit of the significand BitField
occupies the least significant bit of the value_store.
Therefore, the shift of the significand bitfield is 0.
