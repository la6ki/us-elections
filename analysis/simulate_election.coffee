constants = require './helpers/constants'

stateDelegates = constants.stateDelegates
allCandidates = constants.candidates

DELEGATE_THRESHOLD = 270
NUM_CANDIDATES_HOUSE = 3

initializeResultsObject = (distributions) ->
  results =
    delegateCounts: {}
    majorityWins: {}
    pluralityWins: {}
    noMajorityTopCandidates: {}

  for candidate in allCandidates
    results.delegateCounts[candidate] = {}
    results.delegateCounts[candidate][k] = 0 for k in [0..538]
    results.majorityWins[candidate] = 0
    results.pluralityWins[candidate] = 0

  results

getCandidateDelegates = (distributions) ->
  delegates = {}

  for state, distribution of distributions
    cumProb = 0
    randNum = Math.random()
    for candidate, prob of distribution
      delegates[candidate] ?= 0
      cumProb += prob
      if randNum <= cumProb
        delegates[candidate] += stateDelegates[state]
        break

  delegates

getDirectWinner = (candidateDelegates) ->
  directWinner = null

  for candidate, delegates of candidateDelegates
    if delegates >= DELEGATE_THRESHOLD
      directWinner = candidate
      break

  directWinner

getTopCandidates = (candidateDelegates) ->
  candidates = Object.keys candidateDelegates
  candidates.sort (c1, c2) -> candidateDelegates[c2] - candidateDelegates[c1]

  topDelegates = []
  firstPlaceCandidates = []
  maxDelegates = candidateDelegates[candidates[0]]
  for candidate, i in candidates
    break if i == NUM_CANDIDATES_HOUSE
    topDelegates.push candidate
    firstPlaceCandidates.push candidate if candidateDelegates[candidate] == maxDelegates

  code: topDelegates.join('_'), firstPlaceCandidates: firstPlaceCandidates.sort().join('_')

simulateElection = (distributions, nSimulations) ->
  results = initializeResultsObject distributions

  for k in [1..nSimulations]
    delegates = getCandidateDelegates distributions
    results.delegateCounts[candidate][count]++ for candidate, count of delegates
    directWinner = getDirectWinner delegates

    if directWinner?
      results.majorityWins[directWinner]++
      results.pluralityWins[directWinner]++
    else
      topCandidates = getTopCandidates delegates
      results.noMajorityTopCandidates[topCandidates.code] ?= 0
      results.noMajorityTopCandidates[topCandidates.code]++

      firstPlaceCandidates = topCandidates.firstPlaceCandidates #can be more than one, in case of a tie
      results.pluralityWins[firstPlaceCandidates] ?= 0
      results.pluralityWins[firstPlaceCandidates]++

  results

calculateExpectedDelegates = (distributions) ->
  expectedDelegates = {}

  for state, distribution of distributions
    for candidate, probability of distribution
      expectedDelegates[candidate] ?= 0
      expectedDelegates[candidate] += probability * stateDelegates[state]

  expectedDelegates

simulate = (distributions, numSimulations) ->
  expectedDelegates: calculateExpectedDelegates distributions
  simulationResults: simulateElection distributions, numSimulations
  numSimulations: numSimulations

exports.simulate = simulate