DAYS_PER_MONTH = 1: 31, 2: 29, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30
POLL_POLLSTER_INDEX = 0
POLL_DATES_INDEX = 1
POLL_SAMPLE_INDEX = 2
POLL_MOE_INDEX = 3
ELECTION_MONTH = 11
ELECTION_DAY = 8
FIRST_ROW = 1

allCandidates = require('../helpers/constants').candidates

sameYearTest = ->
  currentMonth = 12

  (month) ->
    return no if month > currentMonth + 5
    currentMonth = month
    yes

parsePollDate = (rawDates) ->
  return 'final' if rawDates.length < 3

  firstDate = rawDates.split(' ')[0]
  secondDate = rawDates.split(' ')[2]

  firstDateM = parseInt firstDate.split('/')[0]
  firstDateD = parseInt firstDate.split('/')[1]
  secondDateM = parseInt secondDate.split('/')[0]
  secondDateD = parseInt secondDate.split('/')[1]

  if firstDateM == secondDateM
    pollDate = month: firstDateM, day: Math.round firstDateD + (secondDateD - firstDateD) / 2
  else
    daysCurrentMonth = DAYS_PER_MONTH[firstDateM]
    dayGap = Math.round (daysCurrentMonth - firstDateD + secondDateD) / 2
    day = (dayGap + daysCurrentMonth) % daysCurrentMonth
    day = daysCurrentMonth if day == 0
    month = if day > firstDateD then firstDateM else secondDateM
    pollDate = month: month, day: day

  pollDate

validPoll = (poll) ->
  currentMonth = new Date().getMonth() + 1
  date = poll.date
  return no if isNaN date.day
  return no if isNaN date.month
  return no if date.month > ELECTION_MONTH
  return no if date.month == ELECTION_MONTH and date.day >= ELECTION_DAY
  return no if date.month > currentMonth
  return no if isNaN poll.sample
  for candidate, percentage of poll.percentages
    return no if isNaN percentage

  return yes

processPolls = ($, pollTrs, candidates, firstCandidateIndex) ->
  polls = []

  sameYear = sameYearTest()
  for pollTr in pollTrs
    candidatePercentages = {}
    tds = $(pollTr).find 'td'

    if pollsterVal = $(tds[POLL_POLLSTER_INDEX]).find("a")[0]
      pollster = pollsterVal.textContent
    else
      pollster = $(tds[POLL_POLLSTER_INDEX]).text()

    date = parsePollDate $(tds[POLL_DATES_INDEX]).text()
    break if not sameYear date.month

    sample = parseInt $(tds[POLL_SAMPLE_INDEX]).text().split(' ')[0]

    for k in [firstCandidateIndex...tds.length-1]
      candidate = candidates[k - firstCandidateIndex]
      candidatePercentages[candidate] = parseFloat $(tds[k]).text()

    poll = pollster: pollster, date: date, sample: sample, percentages: candidatePercentages
    continue if not validPoll poll

    polls.push poll

  polls

getFirstCandidateIndex = ($, labelsTr) ->
  ths = $(labelsTr).find 'th'
  for th, i in ths
    cellText = $(th).text().split(" ")[0]
    return i if allCandidates.indexOf(cellText) != -1

getPollCandidates = ($, labelsTr, firstCandidateIndex) ->
  candidates = []

  ths = $(labelsTr).find 'th'
  for th, i in ths
    if i >= firstCandidateIndex
      candidates.push $(th).text().split(" ")[0]
      return candidates if i == ths.length - 2

getNumbersOfCandidates = (polls) ->
  candidateStrings = Object.keys polls
  numbersOfCandidates = (parseInt str[0] for str in candidateStrings)
  sorted = numbersOfCandidates.sort (a, b) -> a > b

  sorted

pollstersSame = (pollster1, pollster2) ->
  pollster1 = pollster1.replace ' ', ''
  pollster1 = pollster1.replace '*', ''
  pollster2 = pollster2.replace ' ', ''
  pollster2 = pollster2.replace '*', ''
  return true if pollster1 is pollster2
  return true if pollster1.indexOf(pollster2) != -1
  return true if pollster2.indexOf(pollster1) != -1
  return false

twoPollsSame = (poll1, poll2, sameNumberCandidates) ->
  return false if not pollstersSame poll1.pollster, poll2.pollster
  if sameNumberCandidates
    return false if Object.keys(poll1.percentages).length != Object.keys(poll1.percentages).length
  if poll1.sample? and poll2.sample?
    return false if poll1.sample != poll2.sample
    return false if poll1.date.month != poll2.date.month
    return false if poll1.date.day != poll2.date.day

  if sameNumberCandidates
    for candidate, percentage of poll1.percentages
      if poll2.percentages[candidate]?
        return false if poll2.percentages[candidate] != percentage

  return true

reformatPoll = (poll) ->
  pollResults = poll.results.split ', '
  pollPercentages = {}

  for result in pollResults
    candidate = result.split(' ')[0]
    percentage = result.split(' ')[1]
    pollPercentages[candidate] = parseFloat percentage

  percentages: pollPercentages, pollster: poll.pollster

getCorrespondingPoll = (poll, pollPool, sameNumberCandidates = true) ->
  newPoll = if poll.results? then reformatPoll poll else poll

  for p in pollPool
    return p if twoPollsSame p, newPoll, sameNumberCandidates

  return null

exports.getCorrespondingPoll = getCorrespondingPoll

exports.getPolls = ($, dataSelector) ->
  pollData = $(dataSelector)[0]
  pollTrs = $(pollData).find("tr")
  firstCandidateIndex = getFirstCandidateIndex $, pollTrs[0]
  candidates = getPollCandidates $, pollTrs[0], firstCandidateIndex
  polls = processPolls $, pollTrs[FIRST_ROW..pollTrs.length - 1], candidates, firstCandidateIndex

  polls

exports.removeDuplicates = (allPolls) ->
  for indicator, polls of allPolls
    numbersOfCandidates = getNumbersOfCandidates polls
    for number, i in numbersOfCandidates
      break if i == numbersOfCandidates.length - 1

      numbersStr1 = "#{number}-way"
      polls1 = polls[numbersStr1]
      numbersStr2 = "#{numbersOfCandidates[i+1]}-way"
      polls2 = polls[numbersStr2]

      for poll in polls2
        correspondingPoll = getCorrespondingPoll poll, polls1, false
        polls1.splice polls1.indexOf(correspondingPoll), 1 if correspondingPoll?

      #ad hoc temporary solution
      if i == 0 and numbersOfCandidates[i+2]?
        numbersStr3 = "#{numbersOfCandidates[i+2]}-way"
        polls3 = polls[numbersStr3]
        for poll in polls3
          correspondingPoll = getCorrespondingPoll poll, polls1, false
          polls1.splice polls1.indexOf(correspondingPoll), 1 if correspondingPoll?

  allPolls