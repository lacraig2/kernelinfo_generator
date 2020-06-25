import apt
from shutil import rmtree
from os import listdir, remove, chdir, mkdir

cache = apt.cache.Cache()
cache.update()
cache.open()

rmtree("/workspace/downloads",ignore_errors=True)
mkdir("/workspace/downloads")

package_list = [key for key in cache.keys() if "linux-image-" in key and "dbgsym" in key]
print(f"package_length: {len(package_list)}")

with open("/workspace/list","w") as f:
    for package_name in package_list:
        package = cache[package_name]
        print(f"{package_name} {package.candidate.uri}")
        f.write(f"{package_name} {package.candidate.uri}\n")
