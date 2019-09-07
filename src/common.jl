import Random: AbstractRNG, rand, rand!

abstract type VSLDistribution{T} <: AbstractRNG end

rand(d::VSLDistribution{T}, dims::Integer...) where T = rand(d, T, Dims(dims))

function rand(d::VSLDistribution{T}, ::Type{X}) where {T, X}
    error("Only $(T) type is supported for $d.")
end

function rand!(d::VSLDistribution{T}, A::AbstractArray{K}, ::Type{X}=T) where {T, K, X}
    # T !== K || T !== X
    error("Only $(T) type is supported for $d.")
end
