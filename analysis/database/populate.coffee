path = require 'path'
dotenv = require 'dotenv'
mongojs = require 'mongojs'
pollScraper = require '../poll_scraping/all_polls'
helpers = require './common'
constants = require '../helpers/constants'

dotenv.config path: path.join(__dirname, "../../.env")
db = mongojs process.env.DB_URL, constants.dbCollections
scrapeStatePolls = pollScraper.state
scrapeNationalPolls = pollScraper.national
insertDB = helpers.insertDB
stateURLs = constants.statePollURLs2016
nationalURLs = constants.nationalPollURLs

scrapeAndPolulate = ->
  scrapeStatePolls stateURLs, (err, polls) -> insertDB db, polls, 'state_polls'
  scrapeNationalPolls nationalURLs, (err, polls) -> insertDB db, polls, 'national_polls'

scrapeAndPolulate()