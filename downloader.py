import apt
from requests import get
from subprocess import check_output
from shutil import rmtree,move
from os.path import exists,basename
from os import listdir, remove, chdir
from glob import iglob

cache = apt.cache.Cache()
cache.update()
cache.open()

rmtree("/workspace/downloads",ignore_errors=True)

package_list = [key for key in cache.keys() if "linux-image-unsigned-" in key]

for package_name in package_list:
	if not exists(f"/workpace/output/{package_name}_kernelinfo.conf"):
		print(check_output(["mkdir","/workspace/downloads"]))
		print(f"Downloading package: {package_name}")
		package = cache[package_name]
		with open(f"/workspace/downloads/{package_name}", "wb") as f:
			response = get(package.candidate.uri)
			f.write(response.content)
		chdir("/workspace/downloads")
		print(check_output(["ar", "xv", f"/workspace/downloads/{package_name}"]))
		chdir("/workspace")
		print(check_output(["tar", "-xvf", "/workspace/downloads/data.tar.xz"]))
		vmlinuxfiles = [f for f in iglob("**/vmlinux*",recursive=True)]
		if len(vmlinuxfiles):
			vmlinuxfile = vmlinuxfiles[0]
			move(vmlinuxfile,"/workspace/vmlinux")
			print(check_output(["./run.sh", "vmlinux", f"./output/{package_name}_kernelinfo.conf"]))
			remove("/workspace/vmlinux")
		else:
			print("couldn't find a vmlinux file for {package_name}")
		rmtree("/workspace/downloads",ignore_errors=True)
	else:
		print(f"Continued on from {package_name}")

