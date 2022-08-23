using VSL
using Test

@testset "BRNG" begin

@info("Testing basic random number generators...")

brng_types = [
    VSL_BRNG_MCG31, VSL_BRNG_R250, VSL_BRNG_MRG32K3A, VSL_BRNG_MCG59, VSL_BRNG_WH, VSL_BRNG_SOBOL, VSL_BRNG_NIEDERR,
    VSL_BRNG_MT19937, VSL_BRNG_MT2203, VSL_BRNG_SFMT19937, VSL_BRNG_NONDETERM, VSL_BRNG_ARS5, VSL_BRNG_PHILOX4X32X10
]

for brng_type in brng_types
    @test BasicRandomNumberGenerator(brng_type, UInt(200701281)) isa BasicRandomNumberGenerator
    @test BasicRandomNumberGenerator(brng_type, [Cuint(i) for i in 1:10]) isa BasicRandomNumberGenerator
end

end
