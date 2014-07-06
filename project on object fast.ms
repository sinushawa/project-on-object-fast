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

fn start obj inversion=
(
	undo on
	(
		ED = polyop.getEdgeSelection selection[1]
		verticesID=#{}
		verticesPos=#()
		polyVerts=#()
		for i in ED do
		(
			V1ID=(polyop.getEdgeVerts selection[1] i)[1]
			V2ID=(polyop.getEdgeVerts selection[1] i)[2]
			V1Pos=polyop.getVert selection[1] V1ID node:selection[1]
			V2Pos=polyop.getVert selection[1] V2ID node:selection[1]
			if inversion!=true then
			(
				ray1= ray V2Pos (V2Pos-V1Pos)
				ray2 = ray V1Pos (v1Pos-V2Pos)
			)
			else
			(
				ray1= ray V2Pos (V1Pos-V2Pos)
				ray2 = ray V1Pos (v2Pos-V1Pos)
			)
			Ret1=intersectRay obj ray1
			if Ret1!=undefined do
			(
				pv = polyVert ID:v2ID pos:Ret1.pos
				append polyVerts pv
				--polyop.setVert selection[1] #{v2ID} Ret1.pos node:selection[1]
			)
			Ret2=intersectRay obj ray2
			if Ret2!=undefined do
			(
				pv = polyVert ID:v1ID pos:Ret2.pos
				append polyVerts pv
				--polyop.setVert selection[1] #{v1ID} Ret2.pos node:selection[1]
			)
		)
		qsort polyVerts compare_polyVert
		for i in polyverts do
		(
			append verticesID i.ID
			append verticesPos i.pos
		)
		polyop.setVert selection[1] verticesID verticesPos node:selection[1]
	)
)

rollout SelspecFaces "Project polys on surface" width:250 height:80
(
	pickbutton chooseIT "Select screen" tooltip:"select object on which to project"
	checkbutton inversebutt "invert" checked:false
	
	on chooseIT picked obj do
	(
		inversion = inversebutt.checked
		if ((classOf selection[1]) != Editable_Poly) then
		(
			messageBox "this function only works on editable poly"
		)
		else
		(
			start obj inversion
		)
	)
)
SelspecFacesfloat = newRolloutFloater "Max devs suck" 250 90
addRollout SelspecFaces SelspecFacesfloat