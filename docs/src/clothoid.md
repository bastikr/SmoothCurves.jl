# Clothoid

```@example
using SmoothCurves # hide

using Plots # hide

dmax = 1.5 # hide
p0 = [-6, 0] # hide
p1 = [0.0, 0.0] # hide
p2 = 6*normalize([2, 5]) # hide
C = SmoothCurves.construction.clothoidcorner(dmax, p0, p1, p2) # hide
n0 = normalize([-(p1[2] - p0[2]), (p1[1] - p0[1])]) # hide

λ = C.curves[2].λ # hide
phi = SmoothCurves.deviation(p1-p0, p2-p1) # hide
θ = phi/2 # hide
Fcos, Fsin = SmoothCurves.fresnel(1, sqrt(θ)) # hide
smax_ = sqrt(abs(θ/λ)) # hide
Δy = smax_/sqrt(θ)*Fsin # hide
Δx = smax_/sqrt(θ)*Fcos # hide
δ = Δy*tan(θ) # hide
d = sqrt(δ^2 + Δy^2) # hide

plt = plot(ticks=false, border=false, axis=false) # hide

# Plot clothoids # hide
plot!(C, lc=1, lw=2) # hide
p_begin = startpoint(C) # hide
p_split = startpoint(C.curves[2]) # hide
p_end = endpoint(C) # hide
scatter!([p_begin[1], p_split[1], p_end[1]], [p_begin[2], p_split[2], p_end[2]], # hide
        color=1, label="") # hide

# Plot polygon lines # hide
C_l0 = LineSegment(p0, p1) # hide
C_l1 = LineSegment(p1, p2) # hide
plot!(C_l0, lc=:black) # hide
plot!(C_l1, lc=:black) # hide

p_annotate = p1 - (δ + 0.5*Δx)*direction(C_l0) - 0.2*n0 # hide
annotate!(p_annotate..., text("\\Delta x", 8, :center)) # hide

p_annotate = p1 - 0.5*δ*direction(C_l0) - 0.2*n0 # hide
annotate!(p_annotate..., text("\\delta", 8, :center)) # hide

l = length(C_l1)*dot(direction(C_l0), direction(C_l1))
C_l0_extension = LineSegment(p1, l*direction(C_l0)) # hide
plot!(C_l0_extension, lc=:black, ls=:dash) # hide

# Plot normal to first line # hide
p_ = p1 - δ*direction(C_l0)
C_l0_normal = LineSegment(p_, p_ + Δy*n0) # hide
plot!(C_l0_normal, lc=:black, ls=:solid) # hide
p_annotate = point(C_l0_normal, 0) - 0.2*direction(C_l0) + 0.5*n0*length(C_l0_normal) # hide
annotate!(p_annotate..., text("\\Delta y", 8, :center)) # hide

# Plot mindistance # hide
C_l_mindistance = LineSegment(p1, p1 - δ*direction(C_l0) + Δy*direction(C_l0_normal)) # hide
plot!(C_l_mindistance, lc=:black, ls=:solid) # hide
p_annotate = p1 + 0.5*direction(C_l_mindistance)*length(C_l_mindistance) + [0.1, 0.1] # hide
annotate!(p_annotate..., text("d", 8, :center)) # hide

# Plot theta angle # hide
r_thetaangle = 0.3 # hide
C_thetaangle = ArcSegment(p1 + length(C_l_mindistance)*direction(C_l_mindistance), r_thetaangle, # hide
    SmoothCurves.deviation(direction(C_l0), -n0), # hide
    SmoothCurves.deviation(direction(C_l0), -direction(C_l_mindistance))) # hide
plot!(C_thetaangle, lc=:black, ls=:solid) # hide
p_annotate = C_thetaangle.origin - (r_thetaangle+0.2)*normalize(direction(C_l_mindistance) + n0) # hide
annotate!(p_annotate..., text("\\theta", 8, :center)) # hide

# Plot phi angle # hide
r_phiangle = 0.5 # hide
C_phiangle = ArcSegment(p1, r_phiangle, tangentangle(C_l0, 0.), tangentangle(C_l1, 0.)) # hide
plot!(C_phiangle, lc=:black, ls=:dash) # hide
p_annotate = p1 + (r_phiangle + 0.2)*normalize(direction(C_l0) + direction(C_l1)) # hide
annotate!(p_annotate..., text("\\phi", 8, :center)) # hide
```

## Definition

The clothoid in standard orientation is defined via the general Fresnel integrals

```math
x(s) = \int_0^s \cos(\lambda t^2) \mathrm{d}t
\\
y(s) = \int_0^s \sin(\lambda t^2) \mathrm{d}t
```

## Properties

```math
l(s) = s
\\
\frac{\mathrm{d}l}{\mathrm{d}s} = 1
\\
\kappa(s) = 2 \lambda s
\\
\frac{\mathrm{d} \kappa}{\mathrm{d} s} = 2 \lambda
\\
\theta(s) = \lambda s^2
```

## Clothoid Fitting

```math
x(s) = \int_0^s \cos(\lambda t^2) \mathrm{d}t
     = \int_0^s \cos(\theta \frac{t^2}{s^2}) \mathrm{d}t
     = \frac{1}{\sqrt{\theta}} s \int_0^\sqrt{\theta} \cos(t^2) \mathrm{d}t
     = \frac{1}{\sqrt{\theta}} s \mathrm{F}_{\cos}(\sqrt{\theta})
\\
y(s) = \int_0^s \sin(\lambda t^2) \mathrm{d}t
     = \int_0^s \sin(\theta \frac{t^2}{s^2}) \mathrm{d}t
     = \frac{1}{\sqrt{\theta}} s \int_0^\sqrt{\theta} \sin(t^2) \mathrm{d}t
     = \frac{1}{\sqrt{\theta}} s \mathrm{F}_{\sin}(\sqrt{\theta})
```

Minimum distance from the corner point

```math
d = \frac{y}{\cos{\theta}}
  = s \frac{\mathrm{F}_{\sin}(\sqrt{\theta})}{\sqrt{\theta} \cos{\theta}}
```

Given a specific distance ``d`` choose parameter ``s`` to

```math
s = d \frac{\sqrt{\theta} \cos{\theta}}{\mathrm{F}_{\sin}(\sqrt{\theta})}
```

The total shift in ``x`` direction is then

```math
\mathrm{shift} = d (\sin \theta + \cos \theta \frac{\mathrm{F}_{\cos}(\sqrt{\theta})}{\mathrm{F}_{\sin}(\sqrt{\theta})})
```