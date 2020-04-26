HERE=`pwd`
INCLUDE=`realpath ./output`
INCLUDEJSON=`realpath ./output_json`

docker run -v $INCLUDE:/workspace/output_kernelinfo -v $INCLUDEJSON:/workspace/output_json  -it kernelinfobuilder
