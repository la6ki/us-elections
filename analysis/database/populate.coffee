path = require 'path'
dotenv = require 'dotenv'
mongojs = require 'mongojs'
pollScraper = require '../poll_scraping/all_polls'
helpers = require './common'
constants = require '../helpers/constants'
pollReformatter = require '../helpers/reformat_polls'
pythonIO = require '../python/input_output'
electionSimulator = require '../simulate_election'

dotenv.config path: path.join(__dirname, "../../.env")
db = mongojs process.env.DB_URL, constants.dbCollections
scrapeStatePolls = pollScraper.state
scrapeNationalPolls = pollScraper.national
insertDB = helpers.insertDB
stateURLs = constants.statePollURLs2016
nationalURLs = constants.nationalPollURLs
pythonFormatPolls = pollReformatter.python
analyzePolls = pythonIO.processInput
simulateElection = electionSimulator.simulate

normalizeDistributions = (stateDistributions) ->
  for state, distributions of stateDistributions
    sum = 0
    sum += count for candidate, count of distributions
    distributions[candidate] /= sum for candidate, count of distributions

  stateDistributions

exports.scrapeAndPolulate = (parameters) ->
  allPolls = {}

  scrapeStatePolls stateURLs, (err, polls) ->
    throw err if err
    allPolls.state = polls
    insertDB db, polls, 'state_polls', (err) ->
      throw err if err
      scrapeNationalPolls nationalURLs, (err, polls) ->
        throw err if err
        allPolls.national = polls
        insertDB db, polls, 'national_polls', (err) ->
          throw err if err

          pythonInput = pythonFormatPolls allPolls
          analyzePolls pythonInput, parameters.pythonParameters, (err, distributions) ->
            throw err if err

            distributions = normalizeDistributions distributions
            simulationResults = simulateElection distributions, parameters.numberOfSimulations

            insertDB db, distributions, 'state_distributions', (err) -> throw err if err
            insertDB db, simulationResults, 'results', (err) -> throw err if err
            console.log "Data inserted successfully!"