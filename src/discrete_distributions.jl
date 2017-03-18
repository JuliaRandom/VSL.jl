import Base.Random: rand, rand!

abstract type VSLDiscreteDistribution <: VSLDistribution end

macro vsl_distribution_discrete(name, methods, rtype, properties...)
    t = :(Union{})
    method_symbols = [Symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    for method in method_symbols
        push!(t.args, method)
    end
    code = quote
        mutable struct $name{T<:$t} <: VSLDiscreteDistribution
            brng::BasicRandomNumberGenerator
            ii::Int
            tmp::Vector{$rtype}
        end
    end
    fields = code.args[2].args[end].args
    for property in properties
        push!(fields, property)
    end
    push!(fields, :(method::Type{T}))

    push!(code.args, :(
        $name{T<:$t}(brng::BasicRandomNumberGenerator, $(properties...), method::Type{T}) =
        $name(brng, BUFFER_LENGTH, Vector{$rtype}(BUFFER_LENGTH), $([property.args[1] for property in properties]...), method)
    ))

    push!(code.args, :(
        $name(brng::BasicRandomNumberGenerator, $(properties...)) =
        $name(brng, $([property.args[1] for property in properties]...), $(method_symbols[1]))
    ))

    esc(code)
end

macro register_rand_functions_discrete(typename, name, methods, method_constants, rtype, types, arguments)
    code = quote end
    method_symbols = [Symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    function_name = "viRng$(name)"
    for (method, constant) in zip(method_symbols, method_constants.args)
        push!(
            code.args,
            :(function rand(d::$typename{$method}, ::Type{$rtype}=$rtype)
                d.ii += 1
                if d.ii > BUFFER_LENGTH
                    ccall(($function_name, libmkl), Cint, (Int, Ptr{Void}, Int, Ptr{$rtype}, $(types.args...)),
                        $constant, d.brng.stream_state[1], BUFFER_LENGTH, d.tmp, $(arguments.args...))
                    d.ii = 1
                end
                d.tmp[d.ii]
            end)
        )
        push!(
            code.args,
            :(function rand!(d::$typename{$method}, A::Array{$rtype})
                n = length(A)
                t = BUFFER_LENGTH - d.ii
                if n <= t
                    copy!(A, 1, d.tmp, d.ii + 1, n)
                    d.ii = d.ii + n
                    return A
                end
                copy!(A, 1, d.tmp, d.ii + 1, t)
                d.ii = BUFFER_LENGTH
                ccall(($function_name, libmkl), Cint, (Int, Ptr{Void}, Int, Ptr{$rtype}, $(types.args...)),
                    $constant, d.brng.stream_state[1], n - t, view(A, t+1:n), $(arguments.args...))
                A
            end)
        )
        push!(
            code.args,
            :(rand(d::$typename{$method}, dims::Dims) = rand!(d, Array{$rtype}(dims)))
        )
    end 
    esc(code)
end

@vsl_distribution_discrete(
    UniformDiscrete,
    [STD],
    Cint,
    a::Cint,
    b::Cint
)

@register_rand_functions_discrete(
    UniformDiscrete,
    Uniform,
    [STD],
    [0x00000000],
    Cint,
    [Cint, Cint],
    [d.a, d.b]
)

@vsl_distribution_discrete(
    UniformBits,
    [STD],
    Cuint,
)

@register_rand_functions_discrete(
    UniformBits,
    UniformBits,
    [STD],
    [0x00000000],
    Cuint,
    [],
    []
)

@vsl_distribution_discrete(
    UniformBits32,
    [STD],
    Cuint,
)

@register_rand_functions_discrete(
    UniformBits32,
    UniformBits32,
    [STD],
    [0x00000000],
    Cuint,
    [],
    []
)

@vsl_distribution_discrete(
    UniformBits64,
    [STD],
    UInt64,
)

@register_rand_functions_discrete(
    UniformBits64,
    UniformBits64,
    [STD],
    [0x00000000],
    UInt64,
    [],
    []
)

@vsl_distribution_discrete(
    Bernoulli,
    [ICDF],
    Cint,
    p::Cdouble
)

@register_rand_functions_discrete(
    Bernoulli,
    Bernoulli,
    [ICDF],
    [0x00000000],
    Cint,
    [Cdouble],
    [d.p]
)

@vsl_distribution_discrete(
    Geometric,
    [ICDF],
    Cint,
    p::Cdouble
)

@register_rand_functions_discrete(
    Geometric,
    Geometric,
    [ICDF],
    [0x00000000],
    Cint,
    [Cdouble],
    [d.p]
)

@vsl_distribution_discrete(
    Binomial,
    [BTPE],
    Cint,
    ntrial::Cint,
    p::Cdouble
)

@register_rand_functions_discrete(
    Binomial,
    Binomial,
    [BTPE],
    [0x00000000],
    Cint,
    [Cint, Cdouble],
    [d.ntrial, d.p]
)

@vsl_distribution_discrete(
    Hypergeometric,
    [H2PE],
    Cint,
    l::Cint,
    s::Cint,
    m::Cint
)

@register_rand_functions_discrete(
    Hypergeometric,
    Hypergeometric,
    [H2PE],
    [0x00000000],
    Cint,
    [Cint, Cint, Cint],
    [d.l, d.s, d.m]
)

@vsl_distribution_discrete(
    Poisson,
    [PTPE, POISNORM],
    Cint,
    λ::Cdouble
)

@register_rand_functions_discrete(
    Poisson,
    Poisson,
    [PTPE, POISNORM],
    [0x00000000, 0x00000001],
    Cint,
    [Cdouble],
    [d.λ]
)

@vsl_distribution_discrete(
    PoissonV,
    [POISNORM],
    Cint,
    λ::Vector{Cdouble}
)

@register_rand_functions_discrete(
    PoissonV,
    PoissonV,
    [POISNORM],
    [0x00000000],
    Cint,
    [Ptr{Cdouble}],
    [d.λ]
)

@vsl_distribution_discrete(
    NegBinomial,
    [NBAR],
    Cint,
    a::Cdouble,
    p::Cdouble
)

@register_rand_functions_discrete(
    NegBinomial,
    NegBinomial,
    [NBAR],
    [0x00000000],
    Cint,
    [Cdouble, Cdouble],
    [d.a, d.p]
)
