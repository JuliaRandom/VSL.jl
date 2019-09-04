_vsl_errors = Dict()
macro vsl_error(code)
    _vsl_errors[code.args[2]] = code.args[1]
    return esc(Meta.parse("const $code"))
end
struct VSLError <: Exception
    errno :: Int32
    message :: AbstractString
end
show(io::IO, E::VSLError) = print(io, string("VSL Error: ", strerror(E.errno), " -- ", E.message))
VSL_ERROR(errno::Integer) = VSLError(errno, _vsl_errors[errno])

@vsl_error VSL_STATUS_OK = 0

@vsl_error VSL_ERROR_FEATURE_NOT_IMPLEMENTED = -1
@vsl_error VSL_ERROR_UNKNOWN                 = -2
@vsl_error VSL_ERROR_BADARGS                 = -3
@vsl_error VSL_ERROR_MEM_FAILURE             = -4
@vsl_error VSL_ERROR_NULL_PTR                = -5
@vsl_error VSL_ERROR_CPU_NOT_SUPPORTED       = -6

@vsl_error VSL_RNG_ERROR_INVALID_BRNG_INDEX        = -1000
@vsl_error VSL_RNG_ERROR_LEAPFROG_UNSUPPORTED      = -1002
@vsl_error VSL_RNG_ERROR_SKIPAHEAD_UNSUPPORTED     = -1003
@vsl_error VSL_RNG_ERROR_BRNGS_INCOMPATIBLE        = -1005
@vsl_error VSL_RNG_ERROR_BAD_STREAM                = -1006
@vsl_error VSL_RNG_ERROR_BRNG_TABLE_FULL           = -1007
@vsl_error VSL_RNG_ERROR_BAD_STREAM_STATE_SIZE     = -1008
@vsl_error VSL_RNG_ERROR_BAD_WORD_SIZE             = -1009
@vsl_error VSL_RNG_ERROR_BAD_NSEEDS                = -1010
@vsl_error VSL_RNG_ERROR_BAD_NBITS                 = -1011
@vsl_error VSL_RNG_ERROR_QRNG_PERIOD_ELAPSED       = -1012
@vsl_error VSL_RNG_ERROR_LEAPFROG_NSTREAMS_TOO_BIG = -1013
@vsl_error VSL_RNG_ERROR_BRNG_NOT_SUPPORTED        = -1014

@vsl_error VSL_RNG_ERROR_BAD_UPDATE              = -1120
@vsl_error VSL_RNG_ERROR_NO_NUMBERS              = -1121
@vsl_error VSL_RNG_ERROR_INVALID_ABSTRACT_STREAM = -1122

@vsl_error VSL_RNG_ERROR_NONDETERM_NOT_SUPPORTED     = -1130
@vsl_error VSL_RNG_ERROR_NONDETERM_NRETRIES_EXCEEDED = -1131

@vsl_error VSL_RNG_ERROR_ARS5_NOT_SUPPORTED = -1140

@vsl_error VSL_RNG_ERROR_FILE_CLOSE = -1100
@vsl_error VSL_RNG_ERROR_FILE_OPEN  = -1101
@vsl_error VSL_RNG_ERROR_FILE_WRITE = -1102
@vsl_error VSL_RNG_ERROR_FILE_READ  = -1103

@vsl_error VSL_RNG_ERROR_BAD_FILE_FORMAT      = -1110
@vsl_error VSL_RNG_ERROR_UNSUPPORTED_FILE_VER = -1111

@vsl_error VSL_RNG_ERROR_BAD_MEM_FORMAT = -1200

