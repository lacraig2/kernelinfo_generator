import apt
from requests import get
from subprocess import check_output
from shutil import rmtree,move
from os.path import exists,basename
from os import listdir, remove, chdir, mkdir
from glob import iglob

cache = apt.cache.Cache()
cache.update()
cache.open()

rmtree("/workspace/downloads",ignore_errors=True)

package_list = [key for key in cache.keys() if "linux-image-" in key and "dbgsym" in key]
print(f"package_length: {len(package_list)}")

for package_name in package_list:
	fname_kernelinfo = f"/workspace/output_kernelinfo/{package_name}_kernelinfo.conf"
	fname_kerneljson = f"/workspace/output_json/{package_name}.json"

	if not exists(fname_kernelinfo) or not exists(fname_kerneljson):
		print(f"file {fname_kernelinfo} or {fname_kerneljson} doesn't exist")
		mkdir("/workspace/downloads")
		package = cache[package_name]
		print(f"Downloading package: {package_name}")
		with open(f"/workspace/downloads/{package_name}", "wb") as f:
			response = get(package.candidate.uri)
			f.write(response.content)
		print("Download completed")
		chdir("/workspace/downloads")
		print(f"ar x /workspace/downloads/{package_name}")
		check_output(["ar", "x", f"/workspace/downloads/{package_name}"])
		print("tar -xf /workspace/downloads/data.tar.xz")
		check_output(["tar", "-xf", "/workspace/downloads/data.tar.xz"])
		chdir("/workspace")
		vmlinuxfiles = [f for f in iglob("**/vmlinux*",recursive=True)]
		if len(vmlinuxfiles):
			vmlinuxfile = vmlinuxfiles[0]
			fileinfo = check_output(["file", vmlinuxfile])
			if b"debug_info" in fileinfo:
				if not exists(fname_kernelinfo):
					print(f"./run.sh {vmlinuxfile} {fname_kernelinfo}")
					check_output(["./run.sh", vmlinuxfile, fname_kernelinfo])
				if not exists(fname_kerneljson):
					print(f"/root/go/src/github.com/volatilityfoundation/dwarf2json/dwarf2json linux --elf {vmlinuxfile}")
					with open(fname_kerneljson,"wb") as f:
						f.write(check_output(["/root/go/src/github.com/volatilityfoundation/dwarf2json/dwarf2json","linux","--elf",vmlinuxfile]))
		else:
			print(f"couldn't find a vmlinux file for {package_name}")
		rmtree("/workspace/downloads")
	else:
		print(f"Continued on from {package_name}")

