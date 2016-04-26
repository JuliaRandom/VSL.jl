import Base.Random: rand

abstract VSLContinuousDistribution <: VSLDistribution

macro vsl_distribution_continuous(name, methods, fields...)
    t2 = :(Union{})
    methods_symbol = [symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    for method in methods_symbol
        push!(t2.args, method)
    end
    code = quote
        immutable $name{T1<:Union{Cfloat, Cdouble}, T2<:$t2} <: VSLContinuousDistribution
            brng::BasicRandomNumberGenerator
        end
    end
    for field in fields
        push!(code.args[2].args[end].args, field)
    end
    push!(code.args[2].args[end].args, :(method::Type{T2}))
    esc(code)
end

macro register_rand_functions_continuous(name, methods, method_constants, types, arguments)
    code = quote end
    method_symbols = [symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    for ttype in (:Cfloat, :Cdouble)
        ctype = ttype == :Cfloat ? 's' : 'd'
        argtypes = [atype == :T1 ? ttype : atype for atype in types.args]
        function_name = "v$(ctype)Rng$(name)"
        for (method, constant) in zip(method_symbols, method_constants.args)
            push!(
                code.args,
                :(function rand(d::$name{$ttype, $method}, ::Type{$ttype}=$ttype)
                    r = Vector{$ttype}(1)
                    ccall(($function_name, libmkl), Cint, (Int, Ptr{Void}, Int, Ptr{$ttype}, $(argtypes...)),
                          $constant, d.brng.stream_state[1], 1, r, $(arguments.args...))
                    r[1]
                end)
            )
            push!(
                code.args,
                :(function rand!(d::$name{$ttype, $method}, A::Array{$ttype})
                    n = length(A)
                    ccall(($function_name, libmkl), Cint, (Int, Ptr{Void}, Int, Ptr{$ttype}, $(argtypes...)),
                          $constant, d.brng.stream_state[1], n, A, $(arguments.args...))
                    A
                end)
            )
            push!(
                code.args,
                :(rand(d::$name{$ttype, $method}, dims::Dims) = rand!(d, Array($ttype, dims)))
            )
        end
    end
    esc(code)
end

macro register_rand_functions_continuous_multivariate(name, methods, method_constants, types, arguments)
    code = quote end
    method_symbols = [symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    for ttype in (:Cfloat, :Cdouble)
        ctype = ttype == :Cfloat ? 's' : 'd'
        argtypes = [parse(replace("$atype", "T1", "$ttype")) for atype in types.args]
        function_name = "v$(ctype)Rng$(name)"
        for (method, constant) in zip(method_symbols, method_constants.args)
            push!(
                code.args,
                :(function rand(d::$name{$ttype, $method}, ::Type{Vector{$ttype}}=Vector{$ttype})
                    r = Matrix{$ttype}(d.dimen, 1)
                    ccall(($function_name, libmkl), Cint, (Int, Ptr{Void}, Int, Ptr{$ttype}, Int, $(argtypes...)),
                          $constant, d.brng.stream_state[1], 1, r, d.dimen, $(arguments.args...))
                    r[:, 1]
                end)
            )
            push!(
                code.args,
                :(function rand!(d::$name{$ttype, $method}, A::Array{$ttype})
                    n = length(A) ÷ d.dimen
                    ccall(($function_name, libmkl), Cint, (Int, Ptr{Void}, Int, Ptr{$ttype}, Int, $(argtypes...)),
                          $constant, d.brng.stream_state[1], n, A, d.dimen, $(arguments.args...))
                    A
                end)
            )
            push!(
                code.args,
                :(function rand(d::$name{$ttype, $method}, dims::Dims)
                    A = Array{$ttype}(d.dimen, dims...)
                    rand!(d, A)
                end)
            )
        end
    end
    esc(code)
end

@vsl_distribution_continuous(
    Uniform,
    [STD, STD_ACCURATE],
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
