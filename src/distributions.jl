import Base.Random: rand

abstract VSLDistribution <: AbstractRNG

macro vsl_distribution_continuous(name, methods, fields...)
    t2 = :(Union{})
    methods_symbol = [symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    for method in methods_symbol
        push!(t2.args, method)
    end
    code = quote
        immutable $name{T1<:Union{Cfloat, Cdouble}, T2<:$t2} <: VSLDistribution
            brng::BasicRandomNumberGenerator
            method::Type{T2}
        end
    end
    for field in fields
        push!(code.args[2].args[end].args, field)
    end
    esc(code)
end

macro register_rand_functions_continuous(name, methods, method_constants, types, arguments)
    code = quote end
    method_symbols = [symbol(string("VSL_RNG_METHOD_", method)) for method in methods.args]
    for ttype in (:Cfloat, :Cdouble)
        ctype = ttype == :Cfloat ? 'f' : 'd'
        argtypes = [atype == :T1 ? ttype : atype for atype in types.args]
        function_name = "v$(ctype)Rng$(name)"
        for (method, constant) in zip(method_symbols, method_constants.args)
            push!(
                code.args,
                :(function rand(d::$name{$ttype, $method}, ::Type{$ttype}=$ttype)
                    r = Vector{$ttype}(1)
                    ccall(($function_name, libmkl), Cint, (Cint, Ptr{Void}, Cint, Ptr{$ttype}, $(argtypes...)),
                          $constant, d.brng.stream_state[1], 1, r, $(arguments.args...))
                    r[1]
                end)
            )
            push!(
                code.args,
                :(function rand!(d::$name{$ttype, $method}, A::Array{$ttype})
                    n = length(A)
                    ccall(($function_name, libmkl), Cint, (Cint, Ptr{Void}, Cint, Ptr{$ttype}, $(argtypes...)),
                          $constant, d.brng.stream_state[1], n, A, $(arguments.args...))
                    A
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
#rand(d::Uniform{Cfloat, VSL_RNG_METHOD_STD}, brng::BasicRandomNumberGenerator)

