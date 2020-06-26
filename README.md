This docker container sets up an environment to download all ubuntu debug kernel packages and process them.

To use:

- `./build-$ARCH.sh` x86_64 or i386
- `./run-$ARCH.sh` for either architecture
- `./run_downloads.sh` - This generates a list of files to download with `cache_reaser.py` and then uses GNU Parallels to run `downloader.py` in parallel.
