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

package_list = [key for key in cache.keys() if "linux-image-unsigned-" in key and "dbgsym" in key]
print(f"package_length: {len(package_list)}")

for package_name in package_list:
	fname = f"/workspace/output/{package_name}_kernelinfo.conf"
	if not exists(fname):
		print(f"file {fname} doesn't exist")
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
			print(f"./run.sh {vmlinuxfile} {fname}")
			check_output(["./run.sh", vmlinuxfile, fname])
		else:
			print(f"couldn't find a vmlinux file for {package_name}")
		rmtree("/workspace/downloads")
	else:
		print(f"Continued on from {package_name}")

