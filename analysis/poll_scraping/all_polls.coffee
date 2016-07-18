express = require 'express'
jsdom = require 'jsdom'
helpers = require './common'
constants = require '../helpers/constants'

getPolls = helpers.getPolls
removeDuplicates = helpers.removeDuplicates

DATA_SELECTOR = '#polling-data-full'
FIRST_ROW = 1

getAdditionalURLs = ($) ->
  urls = {}

  otherPollATags = $("#under-title-small").find("a")
  for a in otherPollATags
    title = $(a).text()
    pollsUrl = $(a).attr "href"
    candidateNumberStr = title.match(/\d-Way/)?[0]
    urls[candidateNumberStr.toLowerCase()] = pollsUrl if candidateNumberStr? and candidateNumberStr isnt '2-Way'

  urls

getCandidatePolls = (urls, cb) ->
  return cb null, {} if Object.keys(urls).length == 0

  polls = {}
  numScrapedURLs = 0

  for numberCandidatesStr, url of urls
    do (numberCandidatesStr, url) ->
      jsdom.env url, ['http://code.jquery.com/jquery.js'], (err, window) ->
        return cb err if err
        polls[numberCandidatesStr] = getPolls window.$, DATA_SELECTOR
        cb null, removeDuplicates(n: polls).n if ++numScrapedURLs == Object.keys(urls).length

exports.state = (statePollURLs, cb) ->
  statePolls = {}
  numScrapedURLs = 0

  for state, url of statePollURLs
    do (state, url) ->
      jsdom.env url, ['http://code.jquery.com/jquery.js'], (err, window) ->
        return cb err if err

        statePolls[state] = '2-way': getPolls window.$, DATA_SELECTOR
        additionalURLs = getAdditionalURLs window.$
        getCandidatePolls additionalURLs, (err, additionalPolls) ->
          return cb err if err
          statePolls[state][numberCandidatesStr] = polls for numberCandidatesStr, polls of additionalPolls
          cb null, removeDuplicates(statePolls) if ++numScrapedURLs == Object.keys(statePollURLs).length

exports.national = getCandidatePolls