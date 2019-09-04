for method in (:STD, :BOXMULLER, :BOXMULLER2, :ICDF, :GNORM, :CJA, :BTPE, :H2PE, :PTPE, :POISNORM, :NBAR,
               :STD_ACCURATE, :BOXMULLER2_ACCURATE, :ICDF_ACCURATE, :GNORM_ACCURATE, :CJA_ACCURATE)
    eval(Meta.parse("const VSL_RNG_METHOD_$method = Val{:$method}"))
end
