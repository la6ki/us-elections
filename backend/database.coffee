path = require 'path'
mongojs = require 'mongojs'
dotenv = require 'dotenv'
constants = require './constants'
steps = require 'step'

dotenv.config path: path.join(__dirname, "../.env")
db = mongojs process.env.DB_URL, constants.databaseCollections

exports.getData = (cb) ->
  steps(
    ->
      db.state_distributions.find({}).sort({_id: -1}).limit 1, @parallel()
      db.results.find({}).sort({_id: -1}).limit 1, @parallel()

    (err, distributionRes, resultsRes) ->
      return cb err if err
      distributions = distributionRes[0]
      results = resultsRes[0]

      delete distributions._id
      delete results._id

      cb null, distributions: distributions, results: results
  )