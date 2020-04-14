from subprocess import check_output
from shutil import rmtree,move
from os.path import exists,basename
from os import listdir, remove, chdir
from glob import iglob

rmtree("/workspace/downloads",ignore_errors=True)

lines = check_output(["apt-cache", "search", "linux-image-unsigned-*"]).decode().split("\n")
for line in lines:
	if line:
		package_name = line.split(" - ")[0]
		if "dbgsym" in package_name:
			print(f"Downloading package: {package_name}")
			print(check_output(["apt-get", "-y", "install", "--download-only", package_name]))
			print(check_output(["mkdir","/workspace/downloads"]))
			download_file = [df for df in listdir("/var/cache/apt/archives/") if "linux-image-unsigned" in df][0]
			move(f"/var/cache/apt/archives/{download_file}",f"/workspace/downloads/{basename(download_file)}")
			chdir("./downloads")
			print(check_output(["ar", "xv", f"/workspace/downloads/{basename(download_file)}"]))
			chdir("..")
			print(check_output(["tar", "-xvf", "/workspace/downloads/data.tar.xz"]))
			vmlinuxfile = [f for f in iglob("**/vmlinux*",recursive=True)][0]
			move(vmlinuxfile,"./vmlinux")
			print(check_output(["./run.sh", "vmlinux", f"./output/{package_name}_kernelinfo.conf"]))
			remove("./vmlinux")
			rmtree("/workspace/downloads",ignore_errors=True)

