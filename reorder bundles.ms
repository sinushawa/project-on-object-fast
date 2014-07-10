struct edgeT (ID, vID, vPos, rays, mid)  
edges=#()

struct polyVert(ID, pos)

fn compare_polyVert v1 v2 =
(
	if (v1.ID < v2.ID) then
	(
		 return -1
	)
	else
	(
		return 1
	)
)

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
			ray1 = ray V1Pos (V2Pos-V1Pos)
			ray2 = ray V2Pos (V1Pos-V2Pos)
			mid = V1Pos +((V2Pos-V1Pos)/2)
			tempEdge = edgeT ID:i vID:#(v1ID,v2ID) vPos:#(V1Pos, v2Pos) rays:#(ray1, ray2) mid:mid
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
				tempEdge = edgeT ID:tempEdges[i].ID vID:#(tempEdges[i].vID[2],tempEdges[i].vID[1]) vPos:#(tempEdges[i].vPos[2], tempEdges[i].vPos[1])  rays:#(tempEdges[i].rays[2], tempEdges[i].rays[1]) mid:tempEdges[i].mid
				append edges tempEdge
			)
			else
			(
				append edges tempEdges[i]
			)
		)
	)
)

fn project screen dir= 
(
	verticesID=#{}
	verticesPos=#()
	polyVerts=#()
	normaled = false
	norm = normalmodifier()
	if dir==1 then
	(
		testnormal = intersectray screen edges[1].rays[1]
		if testnormal == undefined then
		(
			
			norm.flip = on
			addmodifier screen norm
			normaled = true
		)
		for i in edges do
		(
			ret = intersectray screen i.rays[1]
			if ret != undefined then
			(
				pv = polyVert ID:i.vID[2] pos:ret.pos
				append polyVerts pv
			)
		)
	)
	else
	(
		testnormal = intersectray screen edges[1].rays[2]
		if testnormal == undefined then
		(
			norm.flip = on
			addmodifier screen norm
			normaled = true
		)
		for i in edges do
		(
			ret = intersectray screen i.rays[2]
			if ret != undefined then
			(
				
				pv = polyVert ID:i.vID[1] pos:Ret.pos
				append polyVerts pv
			)
		)
	)
	qsort polyVerts compare_polyVert
	for i in polyverts do
	(
		append verticesID i.ID
		append verticesPos i.pos
	)
	polyop.setVert selection[1] verticesID verticesPos node:selection[1]
	if normaled== true then
	(
		deleteModifier screen screen.modifiers.Count
	)
)

fn pickIT =
(
	screen = pickObject prompt:"select screen" select:false
	start()
	snapping = snapMode.active
	snapMode.active = true
	snapmode.setOSnapItemActive 7 3 true
	pointOnObject = pickPoint snap:#3D
	snapmode.setOSnapItemActive 7 3 false
	snapMode.active=snapping
	dist = 15000
	hold = undefined
	for i in edges do
	(
		distCalculated = pointLineDist2 i.vPos[1] i.vPos[2] pointOnObject
		if distCalculated<dist then
		(
			hold = i
			dist = distCalculated
		)
	)
	clickedDir = normalize(pointOnObject-hold.mid)
	print pointOnObject
	print hold.mid
	print clickedDir
	print hold.rays[1].dir
	res = dot clickedDir hold.rays[1].dir
	print res
	if res<0 then
	(
		project screen 2
	)
	else
	(
		project screen 1
	)
)





pickIT()