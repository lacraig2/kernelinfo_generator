HERE=`pwd`
INCLUDE=`realpath ./output`

docker run -v $INCLUDE:/workspace/output -it kernelinfobuilder
