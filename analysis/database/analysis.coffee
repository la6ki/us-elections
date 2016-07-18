path = require 'path'
mongojs = require 'mongojs'
dotenv = require 'dotenv'
constants = require '../helpers/constants'
steps = require 'step'
helpers = require './common'

dotenv.config path: path.join(__dirname, "../../.env")
db = mongojs process.env.DB_URL, constants.dbCollections
insertDB = helpers.insertDB

getPolls = (cb) ->
  steps(
    ->
      db.state_polls.find({}).sort({_id: -1}).limit 1, @parallel()
      db.national_polls.find({}).sort({_id: -1}).limit 1, @parallel()

    (err, statePollsRes, nationalPollsRes) ->
      return cb err if err
      statePolls = statePollsRes[0]
      nationalPolls = nationalPollsRes[0]

      delete statePolls._id
      delete nationalPolls._id
      
      cb null, state: statePolls, national: nationalPolls
  )

sendPolls = (polls, cb) ->
  insertDB db, polls.state, 'state_polls', cb
  insertDB db, polls.national, 'national_polls', cb

sendDistributions = (distributions, cb) ->
  insertDB db, distributions, 'state_distributions', cb

sendResults = (results, cb) ->
  insertDB db, results, 'results', cb

exports.getPolls = getPolls
exports.sendPolls = sendPolls
exports.sendDistributions = sendDistributions
exports.sendResults = sendResults