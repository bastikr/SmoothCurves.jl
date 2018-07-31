var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "SmoothCurves.jl",
    "title": "SmoothCurves.jl",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#SmoothCurves.jl-1",
    "page": "SmoothCurves.jl",
    "title": "SmoothCurves.jl",
    "category": "section",
    "text": "Create smooth curves, e.g. usable for mobile robot path following."
},

{
    "location": "index.html#Curve-Types-1",
    "page": "SmoothCurves.jl",
    "title": "Curve Types",
    "category": "section",
    "text": "Curve\nClothoid\n"
},

{
    "location": "index.html#Curve-Interface-1",
    "page": "SmoothCurves.jl",
    "title": "Curve Interface",
    "category": "section",
    "text": "smax\npoint\ndpoint\nlength\ndlength\ncurvature\ndcurvature\ntangentangle\n"
},

{
    "location": "clothoid.html#",
    "page": "Clothoid",
    "title": "Clothoid",
    "category": "page",
    "text": ""
},

{
    "location": "clothoid.html#Clothoid-1",
    "page": "Clothoid",
    "title": "Clothoid",
    "category": "section",
    "text": "using SmoothCurves # hide\n\nusing Plots # hide\n\ndmax = 1.5 # hide\np0 = [-6, 0] # hide\np1 = [0.0, 0.0] # hide\np2 = [2, 5] # hide\nC = SmoothCurves.construct_curve2(dmax, p0, p1, p2) # hide\nn0 = normalize([-(p1[2] - p0[2]), (p1[1] - p0[1])]) # hide\n\nλ = C.curves[2].λ # hide\nphi = SmoothCurves.deviation(p1-p0, p2-p1) # hide\nθ = phi/2 # hide\nFcos, Fsin = SmoothCurves.Fresnel(1, sqrt(θ)) # hide\nsmax_ = sqrt(abs(θ/λ)) # hide\nΔy = smax_/sqrt(θ)*Fsin # hide\nΔx = smax_/sqrt(θ)*Fcos # hide\nδ = Δy*tan(θ) # hide\nd = sqrt(δ^2 + Δy^2) # hide\n\nplt = plot(ticks=false, border=false, axis=false) # hide\n\n# Plot clothoids # hide\nplot!(C, lc=1, lw=2) # hide\np_begin = point(C.curves[2], 0) # hide\np_split = point(C.curves[3], 0) # hide\np_end = point(C.curves[4], 0) # hide\nscatter!([p_begin[1], p_split[1], p_end[1]], [p_begin[2], p_split[2], p_end[2]], # hide\n        color=1, label=\"\") # hide\n\n# Plot polygon lines # hide\nC_l0 = Line(p0, p1-p0, norm(p1-p0)) # hide\nC_l1 = Line(p1, p2-p1, norm(p2-p1)) # hide\nplot!(C_l0, lc=:black) # hide\nplot!(C_l1, lc=:black) # hide\n\np_annotate = p1 - (δ + 0.5*Δx)*C_l0.direction - 0.2*n0 # hide\nannotate!(p_annotate..., text(\"\\\\Delta x\", 8, :center)) # hide\n\np_annotate = p1 - 0.5*δ*C_l0.direction - 0.2*n0 # hide\nannotate!(p_annotate..., text(\"\\\\delta\", 8, :center)) # hide\n\nC_l0_extension = Line(p1, p1-p0, dot(C_l0.direction, p2-p1)) # hide\nplot!(C_l0_extension, lc=:black, ls=:dash) # hide\n\n# Plot normal to first line # hide\nC_l0_normal = Line(p1 - δ*C_l0.direction, n0, Δy) # hide\nplot!(C_l0_normal, lc=:black, ls=:solid) # hide\np_annotate = C_l0_normal.origin - 0.2*C_l0.direction + 0.5*n0*C_l0_normal.length # hide\nannotate!(p_annotate..., text(\"\\\\Delta y\", 8, :center)) # hide\n\n# Plot mindistance # hide\nC_l_mindistance = Line(p1, -C_l0.direction + C_l1.direction, sqrt(δ^2 + Δy^2)) # hide\nplot!(C_l_mindistance, lc=:black, ls=:solid) # hide\np_annotate = p1 + 0.5*C_l_mindistance.direction*C_l_mindistance.length + [0.1, 0.1] # hide\nannotate!(p_annotate..., text(\"d\", 8, :center)) # hide\n\n# Plot theta angle # hide\nr_thetaangle = 0.3 # hide\nC_thetaangle = Arc(p1 + C_l_mindistance.length*C_l_mindistance.direction, r_thetaangle, # hide\n    SmoothCurves.deviation(C_l0.direction, -n0), # hide\n    SmoothCurves.deviation(C_l0.direction, -C_l_mindistance.direction)) # hide\nplot!(C_thetaangle, lc=:black, ls=:solid) # hide\np_annotate = C_thetaangle.origin - (r_thetaangle+0.2)*normalize(C_l_mindistance.direction + n0) # hide\nannotate!(p_annotate..., text(\"\\\\theta\", 8, :center)) # hide\n\n# Plot phi angle # hide\nr_phiangle = 0.5 # hide\nC_phiangle = Arc(p1, r_phiangle, tangentangle(C_l0, 0.), tangentangle(C_l1, 0.)) # hide\nplot!(C_phiangle, lc=:black, ls=:dash) # hide\np_annotate = p1 + (r_phiangle + 0.2)*normalize(C_l0.direction + C_l1.direction) # hide\nannotate!(p_annotate..., text(\"\\\\phi\", 8, :center)) # hide"
},

{
    "location": "clothoid.html#Definition-1",
    "page": "Clothoid",
    "title": "Definition",
    "category": "section",
    "text": "The clothoid in standard orientation is defined via the general Fresnel integralsx(s) = int_0^s cos(lambda t^2) mathrmdt\n\ny(s) = int_0^s sin(lambda t^2) mathrmdt"
},

{
    "location": "clothoid.html#Properties-1",
    "page": "Clothoid",
    "title": "Properties",
    "category": "section",
    "text": "l(s) = s\n\nfracmathrmdlmathrmds = 1\n\nkappa(s) = 2 lambda s\n\nfracmathrmd kappamathrmd s = 2 lambda\n\ntheta(s) = lambda s^2"
},

{
    "location": "clothoid.html#Clothoid-Fitting-1",
    "page": "Clothoid",
    "title": "Clothoid Fitting",
    "category": "section",
    "text": "x(s) = int_0^s cos(lambda t^2) mathrmdt\n     = int_0^s cos(theta fract^2s^2) mathrmdt\n     = frac1sqrttheta s int_0^sqrttheta cos(t^2) mathrmdt\n     = frac1sqrttheta s mathrmF_cos(sqrttheta)\n\ny(s) = int_0^s sin(lambda t^2) mathrmdt\n     = int_0^s sin(theta fract^2s^2) mathrmdt\n     = frac1sqrttheta s int_0^sqrttheta sin(t^2) mathrmdt\n     = frac1sqrttheta s mathrmF_sin(sqrttheta)Minimum distance from the corner pointd = fracycostheta\n  = s fracmathrmF_sin(sqrttheta)sqrttheta costhetaGiven a specific distance d choose parameter s tos = d fracsqrttheta costhetamathrmF_sin(sqrttheta)The total shift in x direction is thenmathrmshift = d (sin theta + cos theta fracmathrmF_cos(sqrttheta)mathrmF_sin(sqrttheta))"
},

{
    "location": "api.html#",
    "page": "API",
    "title": "API",
    "category": "page",
    "text": ""
},

{
    "location": "api.html#API-1",
    "page": "API",
    "title": "API",
    "category": "section",
    "text": "Depth=1"
},

{
    "location": "api.html#SmoothCurves.Curve",
    "page": "API",
    "title": "SmoothCurves.Curve",
    "category": "type",
    "text": "Abstract base class for all specialized curve types.\n\n\n\n"
},

{
    "location": "api.html#Curve-Types-1",
    "page": "API",
    "title": "Curve Types",
    "category": "section",
    "text": "Curve"
},

{
    "location": "api.html#SmoothCurves.smax",
    "page": "API",
    "title": "SmoothCurves.smax",
    "category": "function",
    "text": "smax(C::Curve)\n\nMaximum parameter s for which the given curve mathcalC is defined.\n\n\n\n"
},

{
    "location": "api.html#SmoothCurves.point",
    "page": "API",
    "title": "SmoothCurves.point",
    "category": "function",
    "text": "point(C::Curve, s)\n\nPoint (x, y) of the curve mathcalC at s. Returns a StaticArrays.SVector.\n\n\n\n"
},

{
    "location": "api.html#SmoothCurves.dpoint",
    "page": "API",
    "title": "SmoothCurves.dpoint",
    "category": "function",
    "text": "dpoint(C::Curve, s)\n\nDerivative fracdC(s)ds of the curve mathcalC at s. Returns a StaticArrays.SVector.\n\n\n\n"
},

{
    "location": "api.html#Base.length",
    "page": "API",
    "title": "Base.length",
    "category": "function",
    "text": "length(C::Curve, s)\n\nLength of the given curve mathcalC between 0 and s.\n\n\n\nlength(C::Curve)\n\nTotal length of the given curve. Equal to length(C, smax(C)).\n\n\n\n"
},

{
    "location": "api.html#SmoothCurves.dlength",
    "page": "API",
    "title": "SmoothCurves.dlength",
    "category": "function",
    "text": "dlength(C::Curve, s)\n\nDerivative fracdlds at s.\n\n\n\n"
},

{
    "location": "api.html#SmoothCurves.curvature",
    "page": "API",
    "title": "SmoothCurves.curvature",
    "category": "function",
    "text": "curvature(C::Curve, s)\n\nCurvature of the Curve mathcalC at s.\n\n\n\n"
},

{
    "location": "api.html#SmoothCurves.dcurvature",
    "page": "API",
    "title": "SmoothCurves.dcurvature",
    "category": "function",
    "text": "dcurvature(C::Curve, s)\n\nDerivative fracdds of the curve mathcalC at s.\n\n\n\n"
},

{
    "location": "api.html#SmoothCurves.tangentangle",
    "page": "API",
    "title": "SmoothCurves.tangentangle",
    "category": "function",
    "text": "tangentangle(C::Curve, s)\n\nAngle between the tangent of the curve mathcalC at s and the x-axis. Always between - and .\n\n\n\n"
},

{
    "location": "api.html#Curve-Interface-1",
    "page": "API",
    "title": "Curve Interface",
    "category": "section",
    "text": "smax\npoint\ndpoint\nlength\ndlength\ncurvature\ndcurvature\ntangentangle"
},

{
    "location": "api.html#Curve-specific-functions-1",
    "page": "API",
    "title": "Curve specific functions",
    "category": "section",
    "text": ""
},

{
    "location": "api.html#Arc-1",
    "page": "API",
    "title": "Arc",
    "category": "section",
    "text": "sign"
},

]}
