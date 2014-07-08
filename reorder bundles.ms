struct edgeT (ID, vID, vPos)  
edges=#()

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
			tempEdge = edgeT ID:i vID:#(v1ID,v2ID) vPos:#(V1Pos, v2Pos)
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
				tempEdge = edgeT ID:tempEdges[i].ID vID:#(tempEdges[i].vID[2],tempEdges[i].vID[1]) vPos:#(tempEdges[i].vPos[2], tempEdges[i].vPos[1])
				append edges tempEdge
			)
			else
			(
				append edges tempEdges[i]
			)
		)
		print edges
	)
)
start()