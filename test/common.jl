using VSL
import Random: rand, rand!
import Test: @test, @test_throws
import Printf: @printf

brng_types = [
    VSL_BRNG_MCG31, VSL_BRNG_R250, VSL_BRNG_MRG32K3A, VSL_BRNG_MCG59, VSL_BRNG_WH, VSL_BRNG_SOBOL, VSL_BRNG_NIEDERR,
    VSL_BRNG_MT19937, VSL_BRNG_MT2203, VSL_BRNG_SFMT19937, VSL_BRNG_NONDETERM, VSL_BRNG_ARS5, VSL_BRNG_PHILOX4X32X10
]

macro test_rand(expr)
    values = @eval $expr
    if isa(values, Array)
        for value in values
            @printf "%.6f\n" value
        end
    else
        @printf "%.6f\n" values
    end
end

test_folder = joinpath(dirname(pathof(VSL)), "..", "test")
