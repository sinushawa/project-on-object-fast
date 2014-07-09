struct edgeT (ID, vID, vPos, midRay)  
edges=#()

fn lineLineIntersect pA pB pC pD = 
(
	local a=pB-pA
	local b=pD-pC
	local c=pC-pA
	local cross1 = cross a b
	local cross2 = cross c b
	pA + ( a*( (dot cross2 cross1)/((length cross1)^2) ) )
)

fn pointLineDist2 pA pB pC = 
(
	local vAB=pB-pA
	local vAC=pC-pA
	(length (cross vAB vAC))/(length vAB)
)

tool ExtendTrim
(
	on mousePoint clickno do
	(
		local coordSysTM = Inverse(getViewTM())
		local viewPt = coordSysTM.row4
		clickRay = ray viewPt (worldPoint-viewPt)
		pointOnObject = intersectray selection[1] clickray
		print pointOnObject
		dist = 15000
		hold
		for i in edges do
		(
			distCalculated = pointLineDist2 i.vPos[1] i.vPos[2] pointOnObject.pos
			if distCalculated<dist then
			(
				hold = i
				dist = distCalculated
			)
		)
		res = dot (pointOnObject.pos-hold.midRay.Pos) hold.midRay.dir
		if res<0 OR
	)
)

fn start =
(
	undo on
	(
		edgesID = polyop.getEdgeSelection selection[1]
		edges=#()
		for i in edgesID do
		(
			
			V1ID=(polyop.getEdgeVerts selection[1] i)[1]
			V2ID=(polyop.getEdgeVerts selection[1] i)[2]
			V1Pos=polyop.getVert selection[1] V1ID node:selection[1]
			V2Pos=polyop.getVert selection[1] V2ID node:selection[1]
			mid = (V1Pos+V2Pos)/2
			dir = normalize(V2Pos-V1Pos)
			tempEdge = edgeT ID:i vID:#(v1ID,v2ID) vPos:#(V1Pos, v2Pos) midRay:(ray mid dir)
			append edges tempEdge
		)
		tempEdges = edges
		edges = #()
		vect1 = tempEdges[1].vPos[2] - tempEdges[1].vPos[1]
		append edges tempEdges[1]
		for i=2 to tempEdges.Count do
		(
			vect2 = tempEdges[i].vPos[2] - tempEdges[i].vPos[1]
			if (dot vect1 vect2)<0 then
			(
				tempEdge = edgeT ID:tempEdges[i].ID vID:#(tempEdges[i].vID[2],tempEdges[i].vID[1]) vPos:#(tempEdges[i].vPos[2], tempEdges[i].vPos[1])  midRay:(ray tempEdges[i].midRay.pos -tempEdges[i].midRay.dir)
				append edges tempEdge
			)
			else
			(
				append edges tempEdges[i]
			)
		)
	)
)
start()
starttool ExtendTrim