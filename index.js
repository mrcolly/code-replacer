const fs = require('fs-extra');
const path = require('path');
const rif = require('replace-in-file');

const inputDir = "input"
const outputDir = "output"
const configuration = JSON.parse(fs.readFileSync("configuration/config.json"));

const getAllFiles = function(dirPath, arrayOfFiles) {
    files = fs.readdirSync(dirPath)
  
    arrayOfFiles = arrayOfFiles || []
  
    files.forEach(file => {
      let filename = dirPath + "/" + file;
      if (fs.statSync(filename).isDirectory()) {
        arrayOfFiles.push(path.join(__dirname, filename))
        arrayOfFiles = getAllFiles(filename, arrayOfFiles)
      } else {
        arrayOfFiles.push(path.join(__dirname, filename))
      }
    })
    return arrayOfFiles
}

const rename = function(file, configuration) {
    
    for(key in configuration){
        rename(file, key, configuration[key]);
    }

    function rename(file, key, value){
        fileDir = path.dirname(file)
        fileName = path.basename(file);
        if(fileName.includes(key)){
            fs.renameSync(file, path.join(fileDir, fileName.replace(key, value)))
        }
    }
}

const replace = function(file, configuration) {

    if (fs.statSync(file).isDirectory()) {
        return;
    }
    
    rifConfiguration = buildRifConfiguration(file, configuration)

    console.log(JSON.stringify(rifConfiguration))

    rif.replaceInFileSync(rifConfiguration);

    function buildRifConfiguration(file, configuration){
        keys = []
        values = []
        for(key in configuration){
            keys.push(new RegExp(key, "g"));
            values.push(configuration[key])
        }

        return {
            files: file,
            from: keys,
            to: values
          }
    }
}

if(fs.readdirSync(inputDir)){
    console.log("input folder is empty")
    process.exit(1);
}

console.log("empty output folder")
fs.emptyDirSync(outputDir)

console.log("copying files to output")
fs.copySync(inputDir, outputDir, { overwrite: true }, function (err) {         
    console.error(err)
});

console.log(`renaming files according to configuration \n${JSON.stringify(configuration, 2, 2)}`);
getAllFiles(outputDir).reverse().forEach(file =>
    rename(file, configuration)
)

console.log("replace file content")
getAllFiles(outputDir).forEach(file =>
    replace(file, configuration)
)


