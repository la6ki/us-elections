express = require 'express'
database = require './backend/database'
helpers = require './backend/helpers'

app = express()
app.set 'view engine', 'ejs'
app.set 'views', __dirname + '/www/views'
app.use express.static(__dirname)
getData = database.getData
getStateStyles = helpers.getStateStyles
getResultsData = helpers.getResultsData

app.get '/map', (req, res) -> res.render 'index'
app.post '/map-data', (req, res) ->
  getData (err, data) ->
    stateStyles = getStateStyles data.distributions
    resultsData = getResultsData data.results

    mapData = stateStyles: stateStyles, results: resultsData
    res.send JSON.stringify mapData

app.listen 80