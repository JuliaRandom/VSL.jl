brng_type = VSL_BRNG_MT19937
@info("Testing continuous distributions with $brng_type...")
brng = BasicRandomNumberGenerator(brng_type, 200701281)

stdout_ = STDOUT
pwd_ = pwd()
cd(joinpath(Pkg.dir("VSL"), "test/"))
mkpath("./actual")
outfile = open("./actual/continuous.out", "w")
redirect_stdout(outfile)

t_uniform = Uniform(brng, 1.0, 5.0, VSL_RNG_METHOD_STD)
@test_rand(rand(t_uniform)) 
@test_rand(rand(t_uniform, 2, 3))

t_uniform_s = Uniform(brng, 1.0f0, 5.0f0, VSL_RNG_METHOD_STD)
@test_rand(rand(t_uniform_s))
@test_rand(rand(t_uniform_s, 2, 3))

t_gaussian = Gaussian(brng, 0.0, 2.0, VSL_RNG_METHOD_BOXMULLER)
@test_rand(rand(t_gaussian))
@test_rand(rand(t_gaussian, 2, 3))

t_gaussianmv = GaussianMV(brng, 3, VSL.VSL_MATRIX_STORAGE_FULL,
                          Float64[1,2,3], Float64[1 2 3; 1 2 3; 1 2 3], VSL_RNG_METHOD_BOXMULLER)
@test_rand(rand(t_gaussianmv))

t_exponential = Exponential(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF_ACCURATE)
@test_rand(rand(t_exponential))
@test_rand(rand(t_exponential, 2, 3))

t_laplace = Laplace(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
@test_rand(rand(t_laplace))
@test_rand(rand(t_laplace, 2, 3))

t_weibull = Weibull(brng, 2.0, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
@test_rand(rand(t_weibull))
@test_rand(rand(t_weibull, 2, 3))

t_cauchy = Cauchy(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
@test_rand(rand(t_cauchy))
@test_rand(rand(t_cauchy, 2, 3))

t_rayleigh = Rayleigh(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
@test_rand(rand(t_rayleigh))
@test_rand(rand(t_rayleigh, 2, 3))

t_lognormal = Lognormal(brng, 1.0, 5.0, 1.0, 5.0, VSL_RNG_METHOD_BOXMULLER2_ACCURATE)
@test_rand(rand(t_lognormal))
@test_rand(rand(t_lognormal, 2, 3))

t_gumbel = Gumbel(brng, 1.0, 5.0, VSL_RNG_METHOD_ICDF)
@test_rand(rand(t_gumbel))
@test_rand(rand(t_gumbel, 2, 3))

t_gamma = Gamma(brng, 2.0, 1.0, 5.0, VSL_RNG_METHOD_GNORM)
@test_rand(rand(t_gamma))
@test_rand(rand(t_gamma, 2, 3))

t_beta = Beta(brng, 3.0, 2.0, 1.0, 5.0, VSL_RNG_METHOD_CJA_ACCURATE)
@test_rand(rand(t_beta))
@test_rand(rand(t_beta, 2, 3))

close(outfile)
redirect_stdout(stdout_)

@test success(`diff ./expected/continuous.out ./actual/continuous.out`)
cd(pwd_)
