Adapt.adapt_(::Type{<:Array{T}}, xs::Array) where T <: AbstractFloat = 
    isbits(xs) ? xs : convert(Array{T}, xs)

float32(m) = mapleaves(x -> Flux.adapt(Array{Float32}, x), m)

forwardmode(m) = mapleaves(Flux.data, m)