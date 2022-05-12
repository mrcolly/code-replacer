# code replacer

this project is designed to replace every occurrences of words, based on a configuration, in:
+ directory names
+ file names
+ file content

from an input directory or a git project

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)

## Installation

required:
+ [npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)

```sh
npm i
chmod 755 start.sh
```

## Usage

add your configuration at `configuration.config.json`

+ to replace from a directory
```
./start.sh -i <directory path>
```

+ to replace from a git project
```
./start.sh -g <git repo> -b <optional git branch>
```