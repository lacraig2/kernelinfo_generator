#!/bin/bash
python3 cache_reader.py
#cat list | xargs -P`nproc` -n 1 -I{} python3 downloader.py {}
cat list | parallel -u -j `nproc`  python3 downloader.py
