__precompile__(true)

module VSL

    export BRNGType, VSL_BRNG_MCG31, VSL_BRNG_R250, VSL_BRNG_MRG32K3A, VSL_BRNG_MCG59, VSL_BRNG_WH, VSL_BRNG_SOBOL,
           VSL_BRNG_NIEDERR, VSL_BRNG_MT19937, VSL_BRNG_MT2203, VSL_BRNG_SFMT19937, VSL_BRNG_NONDETERM, VSL_BRNG_ARS5,
           VSL_BRNG_PHILOX4X32X10
    
    export BasicRandomNumberGenerator

    export VSL_RNG_METHOD_STD, VSL_RNG_METHOD_BOXMULLER, VSL_RNG_METHOD_BOXMULLER2, VSL_RNG_METHOD_ICDF,
           VSL_RNG_METHOD_GNORM, VSL_RNG_METHOD_CJA, VSL_RNG_METHOD_BTPE, VSL_RNG_METHOD_H2PE, VSL_RNG_METHOD_PTPE,
           VSL_RNG_METHOD_POISNORM, VSL_RNG_METHOD_NBAR, VSL_RNG_METHOD_STD_ACCURATE,
           VSL_RNG_METHOD_BOXMULLER2_ACCURATE, VSL_RNG_METHOD_ICDF_ACCURATE, VSL_RNG_METHOD_GNORM_ACCURATE, 
           VSL_RNG_METHOD_CJA_ACCURATE

    export MatrixStorageType, VSL_MATRIX_STORAGE_FULL, VSL_MATRIX_STORAGE_PACKED, VSL_MATRIX_STORAGE_DIAGONAL

    export VSLDistribution, VSLContinuousDistribution, VSLDiscreteDistribution,
           Uniform, Gaussian, GaussianMV, Exponential, Laplace, Weibull, Cauchy, Rayleigh, Lognormal,
           Gumbel, Gamma, Beta,
           UniformDiscrete, UniformBits, UniformBits32, UniformBits64, Bernoulli, Geometric, Binomial, Hypergeometric,
           Poisson, PoissonV, NegBinomial

    import MKL_jll
    const libmkl = MKL_jll.libmkl_rt

    const BUFFER_LENGTH = 16

    include("errors.jl")
    include("brngs.jl")
    include("methods.jl")
    include("common.jl")

    include("continuous_distributions.jl")
    include("discrete_distributions.jl")

end
