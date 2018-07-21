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

@recipe function f(curve::curves.Curve; spacing=0.1)
    aspect_ratio --> :equal
    label --> ""

    n = round(length(curve)/spacing, RoundUp)
    svec = linspace(0., curves.smax(curve), n)
    points = curves.point.(curve, svec)
    curves.x.(points), curves.y.(points)
end
