from os import listdir

outputdir = "outputi386/"
newoutputdir = "newoutput32/"
bits = 32

for findir in listdir(outputdir):
	with open(outputdir+findir,"r") as f:
		content = f.readlines()[1:-1]
		for i in range(len(content)):
			content[i] = content[i].replace("f_path.","f_path_")
		print(findir)
		if "linux-image-unsigned" in findir:
			qq = findir[21:-23]
		else:
			qq = findir[12:-23]
		print(qq)
		content.insert(0,f"[ubuntu:{qq}:{bits}]\n")
		with open(f"{newoutputdir}ubuntu:{qq}:{bits}.conf","w") as g:
			g.write("".join(content))
