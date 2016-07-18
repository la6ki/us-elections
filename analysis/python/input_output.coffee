path = require 'path'
dotenv = require 'dotenv'
pythonShell = require 'python-shell'

dotenv.config path: path.join(__dirname, "../../.env")
python = new pythonShell path.join(__dirname, "input_output.py"), pythonPath: process.env.PATH_TO_PYTHON

sendInput = (data, parameters) ->
  input = data: data, parameters: parameters
  inputStr = JSON.stringify(input)

  python.send inputStr

input = (data, parameters, cb) ->
  sendInput data, parameters

  python.on 'message', (outputString) ->
    output = JSON.parse outputString
    cb null, output.data

  python.end (err) -> cb err if err

exports.processInput = input