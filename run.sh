HERE=`pwd`
INCLUDE=`realpath ./output`

docker run -v $INCLUDE:/workspace/output kernelinfobuilder bash -c "python3 ./downloader.py" 
