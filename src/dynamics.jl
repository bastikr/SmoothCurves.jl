struct DynamicParameters
    ωmax
    vmax
    amax
end

s_ω(p::DynamicParameters) = p.vmax/p.ωmax

