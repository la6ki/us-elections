#require tools
mailSender = require './helpers/mail'
pollScraper = require './poll_scraping/latest_polls'
pollReformatter = require './helpers/reformat_polls'
electionSimulator = require './simulate_election'
pythonIO = require './python/input_output'
database = require './database/analysis'
steps = require 'step'

#initialize tools
sendMail = mailSender.send
scrapeLatestPolls = pollScraper.scrape
filterNewPolls = pollScraper.filterNewPolls
mailFormatPolls = pollReformatter.mail
pythonFormatPolls = pollReformatter.python
simulateElection = electionSimulator.simulate
analyzePolls = pythonIO.processInput
getPollsDB = database.getPolls
sendPollsDB = database.sendPolls
sendDistributionsDB = database.sendDistributions
sendSimulationResultsDB = database.sendResults

currentNewPolls = (newPolls) ->
  return true if Object.keys(newPolls.national).length > 0
  return true if Object.keys(newPolls.state).length > 0
  false

combinePolls = (newPolls, oldPolls) ->
  for numberCandidatesStr, polls of newPolls.national
    oldPolls.national[numberCandidatesStr].push poll for poll in polls

  for state, statePolls of newPolls.state
    for numberCandidatesStr, polls of statePolls
      oldPolls.state[state][numberCandidatesStr] ?= []
      oldPolls.state[state][numberCandidatesStr].push poll for poll in polls

  oldPolls

normalizeDistributions = (stateDistributions) ->
  for state, distributions of stateDistributions
    sum = 0
    sum += count for candidate, count of distributions
    distributions[candidate] /= sum for candidate, count of distributions

  stateDistributions

processScrapedPolls = (parameters) ->
  (err, scrapedPolls) ->
    return sendMail "error", "Scrape error: #{err}" if err

    steps(
      ->
        getPollsDB @

      (err, oldPolls) ->
        if err
          sendMail "error", "DB error: #{err}\n in get polls"
          return {}

        newPolls = filterNewPolls scrapedPolls, oldPolls
        if not currentNewPolls newPolls
          sendMail "notification", "No new polls today!"
          return {}

        allPolls = combinePolls newPolls, oldPolls
        sendPollsDB allPolls, (err) -> sendMail "error", "DB error: #{err}\n in send polls" if err
        allPolls: pythonFormatPolls(allPolls), newPolls: mailFormatPolls(newPolls)

      (err, data) ->
        return sendMail "error", "Plot processing: #{err}" if err
        return if Object.keys(data.allPolls).length == 0

        analyzePolls data.allPolls, parameters.pythonParameters, (err, distributions) ->
          return sendMail "error", "Python error: #{err}" if err

          distributions = normalizeDistributions distributions
          simulationResults = simulateElection distributions, parameters.numberOfSimulations

          sendDistributionsDB distributions, (err) -> sendMail "error", "DB error: #{err}\n in send distributions" if err
          sendSimulationResultsDB simulationResults, (err) ->
            return sendMail "error", "DB error: #{err} in send results" if err
            sendMail "notification", "Analysis finished successfully! New polls:\n\n\n\n#{data.newPolls}"
    )

analyze = (parameters) ->
  scrapeLatestPolls processScrapedPolls parameters

exports.analyze = analyze