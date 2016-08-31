brng_type = VSL_BRNG_ARS5 
info("Testing discrete distributions with $brng_type...")
brng = BasicRandomNumberGenerator(brng_type, 200701281)

stdout_ = STDOUT
pwd_ = pwd()
cd(joinpath(Pkg.dir("VSL"), "test/"))
mkpath("./actual")
outfile = open("./actual/discrete.out", "w")
redirect_stdout(outfile)

t_uniform = UniformDiscrete(brng, Cint(1), Cint(10))
@test_rand(rand(t_uniform))
@test_rand(rand(t_uniform, 2, 3))

t_uniform_bits = UniformBits(brng)
@test_rand(rand(t_uniform_bits))
@test_rand(rand(t_uniform_bits, 2, 3))

t_uniform_bits32 = UniformBits32(brng)
@test_rand(rand(t_uniform_bits32))
@test_rand(rand(t_uniform_bits32, 2, 3))

t_uniform_bits64 = UniformBits64(brng)
@test_rand(rand(t_uniform_bits64))
@test_rand(rand(t_uniform_bits64, 2, 3))

t_bernoulli = Bernoulli(brng, 0.3)
@test_rand(rand(t_bernoulli))
@test_rand(rand(t_bernoulli, 4, 5))

t_geometric = Geometric(brng, 0.6)
@test_rand(rand(t_geometric))
@test_rand(rand(t_geometric, 6, 3))

t_binomial = Binomial(brng, Cint(10), 0.6)
@test_rand(rand(t_binomial))
@test_rand(rand(t_binomial, 6, 3))

t_hypergeometric = Hypergeometric(brng, Cint(10), Cint(5), Cint(6))
@test_rand(rand(t_hypergeometric))
@test_rand(rand(t_hypergeometric, 3, 6))

t_poisson = Poisson(brng, 3.0)
@test_rand(rand(t_poisson))
@test_rand(rand(t_poisson, 3, 6))

t_poisson_v = PoissonV(brng, [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8])
@test_rand(rand(t_poisson_v))
@test_rand(rand(t_poisson_v, 3, 3))

t_neg_binomial = NegBinomial(brng, 3.0, 0.7)
@test_rand(rand(t_neg_binomial))
@test_rand(rand(t_neg_binomial, 3, 4))

close(outfile)
redirect_stdout(stdout_)

@test success(`diff ./expected/discrete.out ./actual/discrete.out`)
cd(pwd_)
