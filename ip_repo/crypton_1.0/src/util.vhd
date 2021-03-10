package util is
    type key_enum is (K_64, K_96, K_128);
    type key_lookup is array(key_enum) of natural;
    constant key_bits: key_lookup := (
        K_64  =>  64,
        K_96  =>  96,
        K_128 => 128
    );
end package;
