using RecipesBase

using .Pose


@recipe function f(pose::Pose)
    aspect_ratio --> :equal
    arrow --> true
    seriescolor --> 1
    label --> ""

    @series begin
        x = [pose.x, pose.x + cos(pose.phi)]
        y = [pose.y, pose.y + sin(pose.phi)]
        x, y
    end
    @series begin
        x = [pose.x, pose.x - sin(pose.phi)]
        y = [pose.y, pose.y + cos(pose.phi)]
        x, y
    end
end

@recipe function f(curve::Curve; spacing=0.1)
    aspect_ratio --> :equal
    label --> ""

    n = round(length(curve)/spacing, RoundUp)
    svec = linspace(0., smax(curve), n)
    points = point.(curve, svec)
    [p[1] for p in points], [p[2] for p in points]
end
