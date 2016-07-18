express = require 'express'
jsdom = require 'jsdom'
helpers = require './common'
constants = require '../helpers/constants'

states = constants.states
getPolls = helpers.getPolls
getCorrespondingPoll = helpers.getCorrespondingPoll
removeDuplicates = helpers.removeDuplicates
$ = null

POLLS_URL = "http://www.realclearpolitics.com/epolls/latest_polls/"
POLLS_URL_BASE = "http://www.realclearpolitics.com"
DATA_SELECTOR_LATEST = '#table-1'
DATA_SELECTOR_ALL = '#polling-data-full'

processPollTable = (thead, tbody) ->
  date = $(thead).find("b").text()
  pollTrs = $(tbody).find("tr")

  polls = []
  for pollTr, i in pollTrs
    continue if i == 0
    pollDataTds = $(pollTr).find "td"
    type = $(pollDataTds[0]).find("a").text()
    pollster = $(pollDataTds[1]).find("a").text()
    results = $(pollDataTds[2]).find("a").text()
    url = $(pollDataTds[2]).find("a").attr('href')

    polls.push type: type, pollster: pollster, results: results, url: "#{POLLS_URL_BASE}#{url}#polls"

  dateStr: date, polls: polls

decodePollType = (typeRaw) ->
  keywords = typeRaw.split ":"
  return type: "national" if keywords[0] is "General Election"
  return type: "state", data: keywords[0] if states.indexOf(keywords[0]) != -1
  return type: "other"

getElectionPolls = (dailyPolls) ->
  nationalPolls = []
  statePolls = []

  polls = dailyPolls.polls
  for poll in polls
    pollType = decodePollType poll.type
    continue if pollType.type is "other"

    newPoll = dateStr: dailyPolls.date, pollster: poll.pollster, results: poll.results, url: poll.url
    nationalPolls.push poll if pollType.type is "national"
    if pollType.type is "state"
      newPoll.state = pollType.data
      statePolls.push newPoll

  national: nationalPolls, state: statePolls

getDailyPolls = ->
  $allPolls = $ DATA_SELECTOR_LATEST
  dailyPollTables = $allPolls.find "table"

  dailyPolls = []
  for table, i in dailyPollTables by 2
    dailyPolls.push processPollTable table, dailyPollTables[i+1]

  dailyPolls

scrapePollsFromURLList = (urlList, targetPollNumber, cb) ->
  newPolls = []
  deferred = new $.Deferred()

  for url, polls of urlList
    do (url, polls) ->
      jsdom.env url, [ 'http://code.jquery.com/jquery.js' ], (err, window) ->
        return cb err if err
        $ = window.$

        scrapedPolls = getPolls $, DATA_SELECTOR_ALL
        for poll in polls
          correspondingPoll = getCorrespondingPoll poll, scrapedPolls
          correspondingPoll.state = poll.state if poll.state
          newPolls.push correspondingPoll

        deferred.resolve newPolls if newPolls.length == targetPollNumber

  deferred

groupNationalPolls = (polls) ->
  groupedPolls = {}

  for poll in polls
    numberOfCandidates = Object.keys(poll.percentages).length
    key = "#{numberOfCandidates}-way"
    groupedPolls[key] ?= []
    groupedPolls[key].push poll

  groupedPolls

groupStatePolls = (polls) ->
  groupedPolls = {}

  for poll in polls
    state = poll.state
    numberOfCandidates = Object.keys(poll.percentages).length
    key = "#{numberOfCandidates}-way"
    groupedPolls[state] ?= {}
    groupedPolls[state][key] ?= []
    delete poll.state
    groupedPolls[state][key].push poll

  groupedPolls

getLatestPolls = (polls, cb) ->
  nationalPolls = polls.national
  statePolls = polls.state

  nationalURLs = {}
  for poll in nationalPolls
    url = poll.url
    nationalURLs[url] ?= []
    nationalURLs[url].push poll

  stateURLs = {}
  for poll in statePolls
    url = poll.url
    stateURLs[url] ?= []
    stateURLs[url].push poll

  nationalPromise = scrapePollsFromURLList nationalURLs, nationalPolls.length, cb
  statePromise = scrapePollsFromURLList stateURLs, statePolls.length, cb

  $.when(nationalPromise, statePromise).done (nationalPolls, statePolls) ->
    groupedNationalPolls = groupNationalPolls nationalPolls
    groupedStatePolls = groupStatePolls statePolls
    cb null, national: removeDuplicates(n: groupedNationalPolls).n, state: removeDuplicates(groupedStatePolls)

filterPollPool = (latestPolls, oldPolls) ->
  newPolls = {}

  for numberCandidatesStr, pollPool of latestPolls
    if not oldPolls[numberCandidatesStr]?
      newPolls[numberCandidatesStr] = pollPool
      continue

    candidatePolls = []
    for poll in pollPool
      oldPoll = getCorrespondingPoll poll, oldPolls[numberCandidatesStr]
      candidatePolls.push poll if not oldPoll?
    newPolls[numberCandidatesStr] = candidatePolls if candidatePolls.length > 0

  newPolls

exports.scrape = (cb) ->
  jsdom.env POLLS_URL, [ 'http://code.jquery.com/jquery.js' ], (err, window) ->
    return cb err if err
    $ = window.$
    electionPolls = national: [], state: []

    allDailyPolls = getDailyPolls()
    for dailyPolls in allDailyPolls
      nextElectionPolls = getElectionPolls dailyPolls
      electionPolls.national.push poll for poll in nextElectionPolls.national
      electionPolls.state.push poll for poll in nextElectionPolls.state

    getLatestPolls electionPolls, (err, latestPolls) ->
      return cb err if err
      cb null, latestPolls

exports.filterNewPolls = (latestPolls, oldPolls) ->
  newNationalPolls = filterPollPool latestPolls.national, oldPolls.national

  newStatePolls = {}
  for state, polls of latestPolls.state
    newPolls = filterPollPool polls, oldPolls.state[state]
    newStatePolls[state] = newPolls if Object.keys(newPolls).length > 0

  national: newNationalPolls, state: newStatePolls