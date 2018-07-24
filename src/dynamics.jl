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
    κ = curves.curvature(C)
    vmax_circle = 1./sqrt(1./params.vmax^2 + (κ/params.wmax)^2)
    min(vmax_circle, sqrt(vend^2 + 2*params.amax*Δl))
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

function vmax(params::DynamicParameters, C::Clothoid, vend::Float64, s::Float64)
    smax = curves.smax(C)
    κ = curves.curvature(C, smax)
    vend_local = 1./sqrt(1./params.vmax^2 + (κ/params.wmax)^2)
    vend = min(vend, vend_local)

    Δl =  length(C) - curves.l(C, s)
    κ = curves.curvature(C, s)
    vmax_local = 1./sqrt(1./params.vmax^2 + (κ/params.wmax)^2)
    min(vmax_local, sqrt(vend^2 + 2*params.amax*Δl))
end

function vmax_forward(params::DynamicParameters, C::Line, vstart::Float64, s::Float64)
    Δl =  curves.l(C, s)
    min(params.vmax, sqrt(vstart^2 + 2*params.amax*Δl))
end

function vmax_forward(params::DynamicParameters, C::Arc, vstart::Float64, s::Float64)
    Δl =  curves.l(C, s)
    κ = curves.curvature(C)
    vmax_circle = 1./(1./params.vmax^2 + (κ/params.wmax)^2)
    min(vmax_circle, vstart^2 + 2*params.amax*Δl)
end

function vmax_forward(params::DynamicParameters, C::Clothoid, vstart::Float64, s::Float64)
    κ = curves.curvature(C, 0.)
    vstart_local = 1./sqrt(1./params.vmax^2 + (κ/params.wmax)^2)
    vstart = min(vstart, vstart_local)

    Δl =  curves.l(C, s)
    κ = curves.curvature(C, s)
    vmax_local = 1./sqrt(1./params.vmax^2 + (κ/params.wmax)^2)
    min(vmax_local, sqrt(vstart^2 + 2*params.amax*Δl))
end

function vmax_forward(params::DynamicParameters, C::PolyCurve, vstart::Float64, s::Float64)
    i = curves.curveindex(C, s)
    for c=C.curves[1:i-1]
        vstart = vmax_forward(params, c, vstart, curves.smax(c))
    end
    s_i = s
    if (i>1)
        s_i -= C.cum_s[i-1]
    end
    vmax_forward(params, C.curves[i], vstart, s_i)
end
