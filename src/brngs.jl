@enum(BRNGType,
      VSL_BRNG_MCG31         = 0x00100000,
      VSL_BRNG_R250          = 0x00200000,
      VSL_BRNG_MRG32K3A      = 0x00300000,
      VSL_BRNG_MCG59         = 0x00400000,
      VSL_BRNG_WH            = 0x00500000,
      VSL_BRNG_SOBOL         = 0x00600000,
      VSL_BRNG_NIEDERR       = 0x00700000,
      VSL_BRNG_MT19937       = 0x00800000,
      VSL_BRNG_MT2203        = 0x00900000,
#      VSL_BRNG_IABSTRACT     = 0x00a00000,
#      VSL_BRNG_DABSTRACT     = 0x00b00000,
#      VSL_BRNG_SABSTRACT     = 0x00c00000,
      VSL_BRNG_SFMT19937     = 0x00d00000,
      VSL_BRNG_NONDETERM     = 0x00e00000,
      VSL_BRNG_ARS5          = 0x00f00000,
      VSL_BRNG_PHILOX4X32X10 = 0x01000000
)

mutable struct BasicRandomNumberGenerator
    brng_type::BRNGType
    stream_state::Vector{Ptr{Cvoid}}
end

function BasicRandomNumberGenerator(brng_type::BRNGType, seed::UInt)
    stream_state = [Libc.malloc(sizeof(Ptr{Cvoid}))]
    status = ccall((:vslNewStream, libmkl), Cint, (Ptr{Ptr{Cvoid}}, Int, UInt),
                   stream_state, Int(brng_type), seed)
    if status ≠ VSL_STATUS_OK
        throw(VSL_ERROR(status))
    end
    brng = BasicRandomNumberGenerator(brng_type, stream_state)
    finalizer(brng_finalizer, brng)
    brng
end
function BasicRandomNumberGenerator(brng_type::BRNGType, seed::Vector{Cuint})
    stream_state = [Libc.malloc(sizeof(Ptr{Cvoid}))]
    status = ccall((:vslNewStreamEx, libmkl), Cint, (Ptr{Ptr{Cvoid}}, Int, UInt, Ptr{Cuint}),
             stream_state, Int(brng_type), length(seed), seed)
    if status ≠ VSL_STATUS_OK
        throw(VSL_ERROR(status))
    end
    brng = BasicRandomNumberGenerator(brng_type, stream_state)
    finalizer(brng_finalizer, brng)
    brng
end
BasicRandomNumberGenerator(brng_type::BRNGType, seed::Integer) =
    BasicRandomNumberGenerator(brng_type, UInt(seed))
BasicRandomNumberGenerator(brng_type::BRNGType, seed::Vector{T}) where {T<:Integer} =
    BasicRandomNumberGenerator(brng_type, Vector{Cuint}(seed))
BasicRandomNumberGenerator(brng_type::BRNGType) =
    BasicRandomNumberGenerator(brng_type, rand(RandomDevice()))
function brng_finalizer(brng::BasicRandomNumberGenerator)
    status = ccall((:vslDeleteStream, libmkl), Cint, (Ptr{Ptr{Cvoid}},), brng.stream_state)
    if status ≠ VSL_STATUS_OK
        throw(VSL_ERROR(status))
    end
end
