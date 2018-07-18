using RecipesBase


@recipe function f(pose::SmoothCurves.Pose)
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

@recipe function f(curve::SmoothCurves.Curve; spacing=0.1)
    aspect_ratio --> :equal
    label --> ""

    SmoothCurves.evaluate(curve, [0:spacing:length(curve);])
end
