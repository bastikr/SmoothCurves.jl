using RecipesBase

import .Pose


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

@recipe function f(curve::Curve; e=0.01)
    aspect_ratio --> :equal
    label --> ""

    # n = round(Int, length(curve)/spacing, RoundUp)
    # svec = range(0., stop=smax(curve), length=n)
    # points = point.(curve, svec)

    points = point.(curve, samples(curve, e))
    [p[1] for p in points], [p[2] for p in points]
end
