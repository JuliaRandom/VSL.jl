info("Testing basic random number generators...")
for brng_type in brng_types
    brng = BasicRandomNumberGenerator(brng_type, rand(UInt))
    brng = BasicRandomNumberGenerator(brng_type, [rand(Cuint) for i in 1:10])
end
