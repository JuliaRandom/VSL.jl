brng_type = VSL_BRNG_MT19937
info("Testing continuous distributions with $brng_type...")
brng = BasicRandomNumberGenerator(brng_type, 200701281)

stdout_ = STDOUT
pwd_ = pwd()
cd(joinpath(Pkg.dir("VSL"), "test/"))
mkpath("./actual")
outfile = open("./actual/continuous.out", "w")
redirect_stdout(outfile)

t_uniform = Uniform(brng, 1.0, 5.0, VSL_RNG_METHOD_STD)
println(rand(t_uniform)) 
println(rand(t_uniform, 2, 3))

t_uniform_s = Uniform(brng, 1.0f0, 5.0f0, VSL_RNG_METHOD_STD)
println(rand(t_uniform_s))
println(rand(t_uniform_s, 2, 3))

t_gaussian = Gaussian(brng, 0.0, 2.0, VSL_RNG_METHOD_BOXMULLER)
println(rand(t_gaussian))
println(rand(t_gaussian, 2, 3))

t_gaussianmv = GaussianMV(brng, 3, VSL.VSL_MATRIX_STORAGE_FULL,
                          Float64[1,2,3], Float64[1 2 3; 1 2 3; 1 2 3], VSL_RNG_METHOD_BOXMULLER)
println(rand(t_gaussianmv))

t_exponential = Exponential(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF_ACCURATE)
println(rand(t_exponential))
println(rand(t_exponential, 2, 3))

t_laplace = Laplace(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
println(rand(t_laplace))
println(rand(t_laplace, 2, 3))

t_weibull = Weibull(brng, 2.0, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
println(rand(t_weibull))
println(rand(t_weibull, 2, 3))

t_cauchy = Cauchy(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
println(rand(t_cauchy))
println(rand(t_cauchy, 2, 3))

t_rayleigh = Rayleigh(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
println(rand(t_rayleigh))
println(rand(t_rayleigh, 2, 3))

t_lognormal = Lognormal(brng, 1.0, 5.0, 1.0, 5.0, VSL_RNG_METHOD_BOXMULLER2_ACCURATE)
println(rand(t_lognormal))
println(rand(t_lognormal, 2, 3))

t_gumbel = Gumbel(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
println(rand(t_gumbel))
println(rand(t_gumbel, 2, 3))

t_gamma = Gamma(brng, 2.0, 1.0, 5.0, VSL_RNG_METHOD_GNORM)
println(rand(t_gamma))
println(rand(t_gamma, 2, 3))

t_beta = Beta(brng, 3.0, 2.0, 1.0, 5.0, VSL_RNG_METHOD_CJA_ACCURATE)
println(rand(t_beta))
println(rand(t_beta, 2, 3))

close(outfile)
redirect_stdout(stdout_)

@test success(`diff ./expected/continuous.out ./actual/continuous.out`)
cd(pwd_)
