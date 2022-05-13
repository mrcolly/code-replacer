#!/bin/bash

usage() {  
    echo "Usage: $0 [-g <git repository to clone>] [-b <git branch name>] [-i <input folder>]"
    echo "-g and -i are mutually exclusive" 1>&2
    exit 1
}

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    usage
fi

while getopts ":g:b:i:" o; do
    case "${o}" in
        g)
            GIT=${OPTARG};;
        b)
            GIT_BRANCH=${OPTARG};;
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

GIT_INPUT=input
mkdir -p output

function cleanup {
  rm -rf ${GIT_INPUT}
}

trap cleanup EXIT

if [ ! -z ${GIT} ]; then
    cd "$(dirname "$0")"
    rm -rf ${GIT_INPUT};
    mkdir -p ${GIT_INPUT};
    cd ${GIT_INPUT};
    if [ ! -z ${GIT_BRANCH} ]; then
        git clone ${GIT} -b ${GIT_BRANCH}
    else
        git clone ${GIT}
    fi
    rm -rf .git
    cd ..
    node index.js ${GIT_INPUT}
fi

if [ ! -z ${INPUT} ]; then
    if [ ! -d ${INPUT} ]; then
        echo "folder ${INPUT} does not exist!"
        exit 1
    fi
    cd "$(dirname "$0")"
    node index.js ${INPUT}
fi