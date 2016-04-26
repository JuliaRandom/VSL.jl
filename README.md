# VSL.jl
[![Build Status](https://travis-ci.org/sunoru/VSL.jl.svg?branch=master)](https://travis-ci.org/sunoru/VSL.jl)

This package provide bindings to the Intel Vector Statistics Library.

## Using VSL.jl

You must have the [Intel® Math Kernel Library](http://software.intel.com/en-us/intel-mkl) installed to use VSL.jl, and
the shared library must be in a directory known to the linker.

VML.jl provides several basic random number generators (BRNGs) and distributions, and each distrituion has at least
one method to generate random number. After VSL.jl loaded, you can use the distributions such like the followings:

```julia
using VSL.jl
brng = BasicRandomNumberGenerator(VSL_BRNG_MT19937, 12345)
# A BRNG created, in which 12345 is the random seed.
u = Uniform(brng, 0.0, 1.0) # Create a uniform distribution between 0.0 and 1.0.
rand(u) # Generate one random number.
rand(u, 2, 3) # Generate an 2*3 array filled by random numbers.
A = Array(Float64, 3, 4)
rand!(A) # Fill an array with random numbers.
```

### Basic random number generators

Use the Enum `BRNGType` to set the type of BRNG.

| BRNGType Enum |
| ------------------------ |
| `VSL_BRNG_MCG31` |
| `VSL_BRNG_R250` |
| `VSL_BRNG_MRG32K3A` |
| `VSL_BRNG_MCG59` |
| `VSL_BRNG_WH` |
| `VSL_BRNG_SOBOL` |
| `VSL_BRNG_NIEDERR` |
| `VSL_BRNG_MT19937` |
| `VSL_BRNG_MT2203` |
| `VSL_BRNG_SFMT19937` |
| `VSL_BRNG_NONDETERM` |
| `VSL_BRNG_ARS5` |
| `VSL_BRNG_PHILOX4X32X10` |

### Supported distributions

Contigurous: Uniform, Gaussian, GaussianMV, Exponential, Laplace, Weibull, Cauchy, Rayleigh, Lognormal,
    Gumbel, Gamma, Beta

Discrete: UniformDiscrete, UniformBits, UniformBits32, UniformBits64, Bernoulli, Geometric, Binomial,
    Hypergeometric, Poisson, PoissonV, NegBinomial

### Notes

Most of the discrete distributions return values of 32-bit integer. Please be careful when using those distributions.

For more information, please refer to the 
[Intel® Math Kernel Library Developer Reference](https://software.intel.com/en-us/articles/mkl-reference-manual)

## License

[MIT license](https://sunoru.mit-license.org)
