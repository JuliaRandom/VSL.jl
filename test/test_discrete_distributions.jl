brng_type = VSL_BRNG_ARS5 
println("Testing discrete distributions with $brng_type...")
brng = BasicRandomNumberGenerator(brng_type, 200701281)

t_uniform = UniformDiscrete(brng, Cint(1), Cint(10))
Test.@test rand(t_uniform) == 6
Test.@test rand(t_uniform, 2, 3) == [5 7 6; 9 2 5]

t_uniform_bits = UniformBits(brng)
Test.@test rand(t_uniform_bits) == 0xb12b3d58
Test.@test rand(t_uniform_bits, 2, 3) == UInt32[637523788 778724293 3600950861;
    3780002280 1760664825 619741082]

t_uniform_bits32 = UniformBits32(brng)
Test.@test rand(t_uniform_bits32) == 0xa347657e
Test.@test rand(t_uniform_bits32, 2, 3) == UInt32[344532633 3528062335 1322179841;
    3498659647 463957909 1655917268]

t_uniform_bits64 = UniformBits64(brng)
Test.@test rand(t_uniform_bits64) == 0xff571ce61117088d
Test.@test rand(t_uniform_bits64, 2, 3) == UInt64[3216196937293186388 16416441042639576966 5648224080291228016;
    8861913333374977376 15154980180941018381 7228038123753426320]

t_bernoulli = Bernoulli(brng, 0.3)
Test.@test rand(t_bernoulli) == 1
Test.@test rand(t_bernoulli, 4, 5) == Int32[1 0 0 0 1; 1 0 0 0 0; 1 1 1 1 1; 0 0 1 0 0]

t_geometric = Geometric(brng, 0.6)
Test.@test rand(t_geometric) == 0
Test.@test rand(t_geometric, 6, 3) == Int32[0 0 0; 0 1 0; 3 0 0; 1 3 0; 2 0 0; 0 1 0]

t_binomial = Binomial(brng, Cint(10), 0.6)
Test.@test rand(t_binomial) == 5
Test.@test rand(t_binomial, 6, 3) == Int32[4 6 6; 7 7 5; 5 5 6; 6 5 7; 7 6 4; 6 8 7]

t_hypergeometric = Hypergeometric(brng, Cint(10), Cint(5), Cint(6))
Test.@test rand(t_hypergeometric) == 4
Test.@test rand(t_hypergeometric, 3, 6) == Int32[3 3 4 4 4 3; 3 3 3 3 2 4; 3 3 4 3 3 4]

t_poisson = Poisson(brng, 3.0)
Test.@test rand(t_poisson) == 2
Test.@test rand(t_poisson, 3, 6) == Int32[1 4 3 2 5 0; 1 3 5 5 5 5; 2 2 3 4 5 3]

t_poisson_v = PoissonV(brng, [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8])
Test.@test rand(t_poisson_v) == 5
Test.@test rand(t_poisson_v, 3, 3) == Int32[0 1 2; 3 0 1; 2 2 2]

t_neg_binomial = NegBinomial(brng, 3.0, 0.7)
Test.@test rand(t_neg_binomial) == 1
Test.@test rand(t_neg_binomial, 3, 4) == Int32[1 1 2 4; 3 1 2 1; 1 0 0 0]
