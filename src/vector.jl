export windices, net2vec, vec2net!, net2grad

function windices(m, maxnorm = false)
    pos, inds = 0, Vector{Int}[]
    for (name, p) in namedparams(m)
        if ndims(p) == 2
            @assert occursin("w", lowercase(string(name)))
            if maxnorm
                ind = eachrow(reshape((1:length(p)) .+ pos, size(p)))
                append!(inds, ind)
            else
                push!(inds, (1:length(p)) .+ pos)
            end
        end
        pos += length(p)
    end
    return inds
end

parameters_to_vector(ps)::Vector{Float32} = vcat(vec.(data.(ps))...)

function vector_to_parameters!(ps, x)
    pos = 1
    for p in ps
        pos_end = pos + length(p) - 1
        copyto!(vec(p.data), x[pos:pos_end])
        pos = pos_end + 1
    end
end

net2vec(m) = parameters_to_vector(params(m))

vec2net!(m, x) = vector_to_parameters!(params(m), x)

parameters_to_grad(ps)::Vector{Float32} = vcat(vec.(grad.(ps))...)

net2grad(m) = parameters_to_grad(params(m))