struct DynamicParameters
    wmax
    vmax
    amax
end

s_ω(p::DynamicParameters) = p.vmax/p.ωmax

function vmax(params::DynamicParameters, C::Line, vend::Float64, s::Float64)
    Δl =  length(C) - curves.l(C, s)
    min(params.vmax, sqrt(vend^2 + 2*params.amax*Δl))
end

function vmax(params::DynamicParameters, C::Arc, vend::Float64, s::Float64)
    Δl =  length(C) - curves.l(C, s)
    κ = curves.curvature(C, s)
    vmax_circle = 1./(1./params.vmax^2 + (κ/params.wmax)^2)
    min(vmax_circle, vend^2 + 2*params.amax*Δl)
end

function vmax(params::DynamicParameters, C::PolyCurve, vend::Float64, s::Float64)
    i = curves.curveindex(C, s)
    for c=C.curves[end:-1:i+1]
        vend = vmax(params, c, vend, 0.)
    end
    s_i = s
    if (i>1)
        s_i -= C.cum_s[i-1]
    end
    vmax(params, C.curves[i], vend, s_i)
end