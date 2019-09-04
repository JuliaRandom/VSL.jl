import Random: rand, rand!

abstract type VSLContinuousDistribution <: VSLDistribution end

macro vsl_distribution_continuous(name, methods, tmp, properties...)
    t2 = :(Union{})
    method_symbols = [Symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    for method in method_symbols
        push!(t2.args, method)
    end
    code = quote
        mutable struct $name{T1<:Union{Cfloat, Cdouble}, T2<:$t2} <: VSLContinuousDistribution
            brng::BasicRandomNumberGenerator
            ii::Int
        end
    end
    fields = code.args[2].args[end].args
    push!(fields, tmp)
    for property in properties
        push!(fields, property)
    end
    push!(fields, :(method::Type{T2}))

    push!(code.args, :(
        function $name{T1<:Union{Cfloat, Cdouble}, T2<:$t2}(brng::BasicRandomNumberGenerator, $(properties...), method::Type{T2})
            tmp = $(tmp.args[2].args[1] == :Vector ? :(Vector{T1}(BUFFER_LENGTH)) : :(Matrix{T1}(dimen, BUFFER_LENGTH)))
            $name(brng, BUFFER_LENGTH, tmp, $([property.args[1] for property in properties]...), method)
        end
    ))

    push!(code.args, :(
        $name{T1<:Union{Cfloat, Cdouble}}(brng::BasicRandomNumberGenerator, $(properties...)) =
        $name(brng, $([property.args[1] for property in properties]...), $(method_symbols[1]))
    ))

    esc(code)
end

macro register_rand_functions_continuous(name, methods, method_constants, types, arguments)
    code = quote end
    method_symbols = [Symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    for ttype in (:Cfloat, :Cdouble)
        ctype = ttype == :Cfloat ? 's' : 'd'
        argtypes = [atype == :T1 ? ttype : atype for atype in types.args]
        function_name = "v$(ctype)Rng$(name)"
        for (method, constant) in zip(method_symbols, method_constants.args)
            push!(
                code.args,
                :(function rand(d::$name{$ttype, $method}, ::Type{$ttype}=$ttype)
                    d.ii += 1
                    if d.ii > BUFFER_LENGTH
                        ccall(($function_name, libmkl), Cint, (Int, Ptr{Void}, Int, Ptr{$ttype}, $(argtypes...)),
                            $constant, d.brng.stream_state[1], BUFFER_LENGTH, d.tmp, $(arguments.args...))
                        d.ii = 1
                    end
                    d.tmp[d.ii]
                end)
            )
            push!(
                code.args,
                :(function rand!(d::$name{$ttype, $method}, A::Array{$ttype})
                    n = length(A)
                    t = BUFFER_LENGTH - d.ii
                    if n <= t
                        copy!(A, 1, d.tmp, d.ii + 1, n)
                        d.ii = d.ii + n
                        return A
                    end
                    copy!(A, 1, d.tmp, d.ii + 1, t)
                    d.ii = BUFFER_LENGTH
                    ccall(($function_name, libmkl), Cint, (Int, Ptr{Void}, Int, Ptr{$ttype}, $(argtypes...)),
                        $constant, d.brng.stream_state[1], n - t, view(A, t+1:n), $(arguments.args...))
                    A
                end)
            )
            push!(
                code.args,
                :(rand(d::$name{$ttype, $method}, dims::Dims) = rand!(d, Array{$ttype}(dims)))
            )
        end
    end
    esc(code)
end

macro register_rand_functions_continuous_multivariate(name, methods, method_constants, types, arguments)
    code = quote end
    method_symbols = [Symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    for ttype in (:Cfloat, :Cdouble)
        ctype = ttype == :Cfloat ? 's' : 'd'
        argtypes = [Meta.parse(replace("$atype", "T1", "$ttype")) for atype in types.args]
        function_name = "v$(ctype)Rng$(name)"
        for (method, constant) in zip(method_symbols, method_constants.args)
            push!(
                code.args,
                :(function rand(d::$name{$ttype, $method}, ::Type{Vector{$ttype}}=Vector{$ttype})
                    d.ii += 1
                    if d.ii > BUFFER_LENGTH
                        ccall(($function_name, libmkl), Cint, (Int, Ptr{Void}, Int, Ptr{$ttype}, Int, $(argtypes...)),
                            $constant, d.brng.stream_state[1], BUFFER_LENGTH, d.tmp, d.dimen, $(arguments.args...))
                        d.ii = 1
                    end
                    d.tmp[:, d.ii]
                end)
            )
        end
    end
    esc(code)
end

@vsl_distribution_continuous(
    Uniform,
    [STD, STD_ACCURATE],
    tmp::Vector{T1},
    a::T1,
    b::T1
)

@register_rand_functions_continuous(
    Uniform,
    [STD, STD_ACCURATE],
    [0x00000000, 0x40000000],
    [T1, T1],
    [d.a, d.b]
)

@vsl_distribution_continuous(
    Gaussian,
    [BOXMULLER, BOXMULLER2, ICDF],
    tmp::Vector{T1},
    a::T1,
    σ::T1
)

@register_rand_functions_continuous(
    Gaussian,
    [BOXMULLER, BOXMULLER2, ICDF],
    [0x00000000, 0x00000001, 0x00000002],
    [T1, T1],
    [d.a, d.σ]
)

@enum(MatrixStorageType,
    VSL_MATRIX_STORAGE_FULL     = 0,
    VSL_MATRIX_STORAGE_PACKED   = 1,
    VSL_MATRIX_STORAGE_DIAGONAL = 2
)

@vsl_distribution_continuous(
    GaussianMV,
    [BOXMULLER, BOXMULLER2, ICDF],
    tmp::Matrix{T1},
    dimen::Int,
    mstorage::MatrixStorageType,
    a::Vector{T1},
    t::Matrix{T1}
)

@register_rand_functions_continuous_multivariate(
    GaussianMV,
    [BOXMULLER, BOXMULLER2, ICDF],
    [0x00000000, 0x00000001, 0x00000002],
    [Int, Ptr{T1}, Ptr{T1}],
    [Int(d.mstorage), d.a, d.t]
)

@vsl_distribution_continuous(
    Exponential,
    [ICDF, ICDF_ACCURATE],
    tmp::Vector{T1},
    a::T1,
    β::T1
)

@register_rand_functions_continuous(
    Exponential,
    [ICDF, ICDF_ACCURATE],
    [0x00000000, 0x40000000],
    [T1, T1],
    [d.a, d.β]
)

@vsl_distribution_continuous(
    Laplace,
    [ICDF],
    tmp::Vector{T1},
    a::T1,
    β::T1
)

@register_rand_functions_continuous(
    Laplace,
    [ICDF],
    [0x00000000],
    [T1, T1],
    [d.a, d.β]
)

@vsl_distribution_continuous(
    Weibull,
    [ICDF, ICDF_ACCURATE],
    tmp::Vector{T1},
    α::T1,
    a::T1,
    β::T1
)

@register_rand_functions_continuous(
    Weibull,
    [ICDF, ICDF_ACCURATE],
    [0x00000000, 0x40000000],
    [T1, T1, T1],
    [d.α, d.a, d.β]
)

@vsl_distribution_continuous(
    Cauchy,
    [ICDF],
    tmp::Vector{T1},
    a::T1,
    β::T1
)

@register_rand_functions_continuous(
    Cauchy,
    [ICDF],
    [0x00000000],
    [T1, T1],
    [d.a, d.β]
)

@vsl_distribution_continuous(
    Rayleigh,
    [ICDF, ICDF_ACCURATE],
    tmp::Vector{T1},
    a::T1,
    β::T1
)

@register_rand_functions_continuous(
    Rayleigh,
    [ICDF, ICDF_ACCURATE],
    [0x00000000, 0x40000000],
    [T1, T1],
    [d.a, d.β]
)

@vsl_distribution_continuous(
    Lognormal,
    [BOXMULLER2, BOXMULLER2_ACCURATE, ICDF, ICDF_ACCURATE],
    tmp::Vector{T1},
    a::T1,
    σ::T1,
    b::T1,
    β::T1
)

@register_rand_functions_continuous(
    Lognormal,
    [BOXMULLER2, BOXMULLER2_ACCURATE, ICDF, ICDF_ACCURATE],
    [0x00000000, 0x40000000, 0x00000001, 0x40000001],
    [T1, T1, T1, T1],
    [d.a, d.σ, d.b, d.β]
)

@vsl_distribution_continuous(
    Gumbel,
    [ICDF],
    tmp::Vector{T1},
    a::T1,
    β::T1
)

@register_rand_functions_continuous(
    Gumbel,
    [ICDF],
    [0x00000000],
    [T1, T1],
    [d.a, d.β]
)

@vsl_distribution_continuous(
    Gamma,
    [GNORM, GNORM_ACCURATE],
    tmp::Vector{T1},
    α::T1,
    a::T1,
    β::T1
)

@register_rand_functions_continuous(
    Gamma,
    [GNORM, GNORM_ACCURATE],
    [0x00000000, 0x40000000],
    [T1, T1, T1],
    [d.α, d.a, d.β]
)

@vsl_distribution_continuous(
    Beta,
    [CJA, CJA_ACCURATE],
    tmp::Vector{T1},
    p::T1,
    q::T1,
    a::T1,
    β::T1
)

@register_rand_functions_continuous(
    Beta,
    [CJA, CJA_ACCURATE],
    [0x00000000, 0x40000000],
    [T1, T1, T1, T1],
    [d.p, d.q, d.a, d.β]
)
