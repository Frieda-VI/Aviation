--// Bezier Util \\--

--// https://developer.roblox.com/en-us/articles/Bezier-curves Acquire a basic knowledge
--// https://youtu.be/am-K2Gn2GTg : HUGE Thanks to BRicey for the extended knowledge on how bezier curves work!

local BezierCurve = {}
BezierCurve.__index = BezierCurve

function BezierCurve.Quadratic(TimePeriod, Point1, Point2, Point3)
	return (1 - TimePeriod) ^ 2 * Point1 + 2 * (1 - TimePeriod) * TimePeriod * Point2 + TimePeriod ^ 2 * Point3
end

function BezierCurve.Cubic(TimePeriod, Point1, Point2, Point3, Point4)
	return (1 - TimePeriod) ^ 3 * Point1
		+ 3 * (1 - TimePeriod) ^ 2 * TimePeriod * Point2
		+ 3 * (1 - TimePeriod) * TimePeriod ^ 2 * Point3
		+ TimePeriod ^ 3 * Point4
end

function CreateLookupTable(NumberSegments: number, ...): { number }
	local DistanceSum = 0
	local SUMS = {}
	local Step = 1 / NumberSegments

	for Integer = 0, 1, Step do
		local FirstPoint = BezierCurve.Cubic(Integer, ...)
		local SecondPoint = BezierCurve.Cubic(Integer + Step, ...)
		local Distance = (SecondPoint - FirstPoint).Magnitude

		table.insert(SUMS, DistanceSum)
		DistanceSum += Distance
	end
	return SUMS
end

function ReMap(Number, PreviousMin, PreviousMax, Min, Max): number
	return (Min + ((Max - Min) * ((Number - PreviousMin) / (PreviousMax - PreviousMin))))
end

function BezierCurve.new(SegmentsNumber: number, Point1: Vector3, Point2: Vector3, Point3: Vector3, Point4: Vector3)
	return setmetatable({
		Points = {
			Point1,
			Point2,
			Point3,
			Point4,
		},
		DistanceLookup = CreateLookupTable(SegmentsNumber, Point1, Point2, Point3, Point4),
	}, BezierCurve)
end

function BezierCurve:Calculate(TimePeriod: number): Vector3
	TimePeriod = TimePeriod or 0

	local DistanceLookup = self.DistanceLookup
	local ArcLength = DistanceLookup[#DistanceLookup]
	local TargetDistance = ArcLength * TimePeriod

	for Integer, Distance in pairs(DistanceLookup) do
		local NextDistance = DistanceLookup[Integer + 1]
		if TargetDistance >= Distance and TargetDistance < NextDistance then
			return BezierCurve.Cubic(
				ReMap(
					TargetDistance,
					Distance,
					NextDistance,
					Integer / #DistanceLookup,
					(Integer + 1) / #DistanceLookup
				),
				unpack(self.Points)
			)
		end
	end
end

return BezierCurve
