import apt
from requests import get
from subprocess import check_output
from shutil import rmtree,move
from os.path import exists,basename
from os import listdir, remove, chdir, mkdir
from glob import iglob
from multiprocessing import Pool
from sys import argv

import struct

bits = 8* struct.calcsize("P")

def adjust_file(oldfile, newfileoutdir):
    with open(oldfile,"r") as f:
        content = f.readlines()[1:-1]
        for i in range(len(content)):
            content[i] = content[i].replace("f_path.", "f_path_")
        findir = basename(oldfile)
        if "linux-image-unsigned" in oldfile:
            qq = findir[21:-23]
        else:
            qq = findir[12:-23]
        print(qq)
        content.insert(0,f"[ubuntu:{qq}:{bits}]\n")
        with open(f"{newfileoutdir}ubuntu:{qq}:{bits}.conf","w") as g:
            g.write("".join(content))
        


if len(argv) == 2:
    package_name, package_uri = argv[1].split()

    fname_kernelinfo = f"/workspace/output_kernelinfo/{package_name}_kernelinfo.conf"
    fname_kerneljson = f"/workspace/output_json/{package_name}.json"

    if not exists(fname_kernelinfo) or not exists(fname_kerneljson):
        print(f"file {fname_kernelinfo} or {fname_kerneljson} doesn't exist")
        mkdir(f"/workspace/downloads/{package_name}")
        print(f"Downloading package: {package_name}")
        with open(f"/workspace/downloads/{package_name}/{package_name}", "wb") as f:
            response = get(package_uri)
            f.write(response.content)
        print("Download completed")
        chdir(f"/workspace/downloads/{package_name}")
        print(f"ar x /workspace/downloads/{package_name}/{package_name}")
        print(check_output(["ar", "x", f"/workspace/downloads/{package_name}/{package_name}"]))
        print(f"tar -xf /workspace/downloads/{package_name}/data.tar.xz")
        print(check_output(["tar", "-xf", f"/workspace/downloads/{package_name}/data.tar.xz"]))
        vmlinuxfiles = [f for f in iglob("**/vmlinux*",recursive=True)]
        if len(vmlinuxfiles):
            vmlinuxfile = vmlinuxfiles[0]
            fileinfo = check_output(["file", vmlinuxfile])
            print(f"{fileinfo} {b'debug_info' in fileinfo}")
            if b"debug_info" in fileinfo:
                if not exists(fname_kernelinfo):
                    print(f"/workspace/run.sh {vmlinuxfile} {fname_kernelinfo}")
                    check_output(["/workspace/run.sh", vmlinuxfile, fname_kernelinfo])
                    adjust_file(fname_kernelinfo, "/workspace/output_kernelinfo/")

                if not exists(fname_kerneljson):
                    print(f"/dwarf2json linux --elf {vmlinuxfile}")
                    with open(fname_kerneljson,"wb") as f:
                        f.write(check_output(["/dwarf2json","linux","--elf",vmlinuxfile]))
        else:
            print(f"couldn't find a vmlinux file for {package_name}")
        rmtree(f"/workspace/downloads/{package_name}")
    else:
        print(f"Continued on from {package_name}")
else:
    for i in range(len(argv)):
        print(f"{i} {argv[i]}")
    print("Needs 2 arguments")
