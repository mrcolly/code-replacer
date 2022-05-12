#!/bin/bash

usage() {  
    echo "Usage: $0 [-g <git repository to clone>] [-i <input folder>]"
    echo "only one argument allowed" 1>&2
    exit 1
}

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    usage;
fi

while getopts ":g:i:" o; do
    case "${o}" in
        g)
            GIT=${OPTARG};;
        i)
            INPUT=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z ${GIT} ] && [ -z ${INPUT} ]; then
    usage
fi

if [ ! -z ${GIT} ] && [ ! -z ${INPUT} ]; then
    usage
fi

GIT_INPUT=input;
mkdir -p output;

function cleanup {
  rm -rf ${GIT_INPUT};
}

trap cleanup EXIT;

if [ ! -z ${GIT} ]; then
    cd "$(dirname "$0")"
    rm -rf ${GIT_INPUT};
    mkdir -p ${GIT_INPUT};
    cd ${GIT_INPUT};
    git clone ${GIT};
    cd ..;
    node index.js ${GIT_INPUT};
fi

if [ ! -z ${INPUT} ]; then
    if [ ! -d "${INPUT}" ]; then
    echo "folder ${INPUT} does not exist!"
    exit 1
    fi
    cd "$(dirname "$0")"
    node index.js ${INPUT};
fi