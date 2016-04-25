__precompile__(true)

module VSL

    export BRNGType, VSL_BRNG_MCG31, VSL_BRNG_R250, VSL_BRNG_MRG32K3A, VSL_BRNG_MCG59, VSL_BRNG_WH, VSL_BRNG_SOBOL,
           VSL_BRNG_NIEDERR, VSL_BRNG_MT19937, VSL_BRNG_MT2203, VSL_BRNG_SFMT19937, VSL_BRNG_NONDETERM, VSL_BRNG_ARS5,
           VSL_BRNG_PHILOX4X32X10
    
    export BasicRandomNumberGenerator

    const libmkl = :libmkl_rt

    include("errors.jl")
    include("brngs.jl")
    include("methods.jl")

end
