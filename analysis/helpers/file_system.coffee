fs = require 'fs'
path = require 'path'

FILES_PATH = "../data/files/"

exports.writeFileSync = (fileName, contents) ->
  filePath = path.join __dirname, "#{FILES_PATH}#{fileName}"
  fs.writeFileSync filePath, contents

exports.updateExistingFile = (fileName, contents) ->
  file = path.join __dirname, "#{FILES_PATH}#{fileName}"
  fs.open file, 'a', (err, txtFile) ->
    throw err if err
    writeFileSync txtFile, contents

exports.readFileSync = (fileName) ->
  filePath = path.join __dirname, "#{FILES_PATH}#{fileName}"
  file = fs.readFileSync filePath, 'utf-8'