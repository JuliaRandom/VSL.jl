using VSL
using Random, Test

@testset "Discrete" begin

brng_type = VSL_BRNG_ARS5
@info("Testing discrete distributions with $brng_type...")

brng = BasicRandomNumberGenerator(brng_type, 200701281)

t_uniform = UniformDiscrete(brng, Cint(1), Cint(10))
@test rand(t_uniform) ≈ 6
@test rand(t_uniform, 2, 3) ≈ Int32[5 7 6; 9 2 5]

@test_throws ErrorException rand(t_uniform, Float64)
@test_throws ErrorException rand!(t_uniform, zeros(Float64, 5))

t_uniform_bits = UniformBits(brng)
@test rand(t_uniform_bits) ≈ 0xd0894f3f
@test rand(t_uniform_bits, 2, 3) ≈ UInt32[0xd249f57f 0x4ecedd01 0x1117088d; 0x1ba76f95 0x62b34ad4 0xff571ce6]

t_uniform_bits32 = UniformBits32(brng)
@test rand(t_uniform_bits32) ≈ 0x4e6285e0
@test rand(t_uniform_bits32, 2, 3) ≈ UInt32[0xb54dcd90 0x9caafef2 0x859643bd; 0x644f2660 0x9299101d 0xc662ce6d]

t_uniform_bits64 = UniformBits64(brng)
@test rand(t_uniform_bits64) ≈ 0x5fae8b8b09aef82a
@test rand(t_uniform_bits64, 2, 3) ≈ UInt64[0xe219cba5bc57be11 0xcea0f7139dbd4b35 0x8e08400eed6fac84; 0x3ec915aaa5ecc228 0x16f99b0664060777 0xa2d17317e60984cc]

t_bernoulli = Bernoulli(brng, 0.3)
@test rand(t_bernoulli) ≈ 0
@test rand(t_bernoulli, 4, 5) ≈ Int32[0 0 0 1 0; 0 0 0 0 0; 0 1 0 0 0; 0 0 0 0 1]

t_geometric = Geometric(brng, 0.6)
@test rand(t_geometric) ≈ 0
@test rand(t_geometric, 6, 3) ≈ Int32[1 2 1; 0 0 2; 0 0 1; 1 0 0; 0 0 0; 0 1 1]

t_binomial = Binomial(brng, Cint(10), 0.6)
@test rand(t_binomial) ≈ 6
@test rand(t_binomial, 6, 3) ≈ Int32[5 4 7; 6 4 3; 7 9 5; 5 4 6; 5 6 9; 4 2 6]

t_hypergeometric = Hypergeometric(brng, Cint(10), Cint(5), Cint(6))
@test rand(t_hypergeometric) ≈ 3
@test rand(t_hypergeometric, 3, 6) ≈ Int32[2 3 3 3 4 3; 3 4 3 4 3 3; 3 3 2 2 2 2]

t_poisson = Poisson(brng, 3.0)
@test rand(t_poisson) ≈ 2
@test rand(t_poisson, 3, 6) ≈ Int32[3 5 4 2 0 2; 1 4 2 5 2 4; 1 1 3 6 8 7]

t_poisson_v = PoissonV(brng, [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8])
@test rand(t_poisson_v) ≈ 0
@test rand(t_poisson_v, 3, 3) ≈ Int32[1 2 1; 1 1 2; 1 3 0]

t_neg_binomial = NegBinomial(brng, 3.0, 0.7)
@test rand(t_neg_binomial) ≈ 0
@test rand(t_neg_binomial, 3, 4) ≈ Int32[0 1 0 2; 0 1 0 1; 0 0 1 0]

end
