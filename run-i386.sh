INCLUDE=`realpath ./outputi386`
INCLUDEJSON=`realpath ./outputi386_json`

docker run -v $INCLUDE:/workspace/output_kernelinfo -v $INCLUDEJSON:/workspace/output_json  -it kernelinfobuilder_32
