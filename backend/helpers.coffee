constants = require './constants'

LOWER_BOUND_PARAM = 2
STEEPNESS_PARAM = 2

abbreviations = constants.stateAbbreviations
candidateColors = constants.candidateColors

calculateEntropy = (probabilities) ->
  entropy = 0

  for prob in probabilities
    logProb = Math.log2(prob)
    logProb = 0 if logProb == -Infinity
    term = -(prob*logProb)
    entropy += term

  entropy

nEntropyToAlpha = (nEntropy) ->
  1 / (1 + LOWER_BOUND_PARAM*Math.pow(nEntropy, STEEPNESS_PARAM))

calculateStateColor = (candidate, probabilities) ->
  entropy = calculateEntropy probabilities
  numberOfCandidates = probabilities.length
  maxEntropy = Math.log2 numberOfCandidates

  colorRGB = candidateColors[candidate]
  nEntropy = entropy/maxEntropy
  alpha = nEntropyToAlpha nEntropy

  "rgba(#{colorRGB.r}, #{colorRGB.g}, #{colorRGB.b}, #{alpha})"

calculateStateStyle = (state, distribution) ->
  maxProb = 0
  probabilities = []
  for candidate, prob of distribution
    probabilities.push prob
    if prob > maxProb
      maxProb = prob
      winnerCandidate = candidate

  color = calculateStateColor winnerCandidate, probabilities

  fill: color

calculateWinProbabilities = (simulationResults) ->
  majorityWins = simulationResults.majorityWins
  pluralityWins = simulationResults.pluralityWins
  numSimulations = simulationResults.numSimulations

  pluralityProbabilities = {}
  for candidate, count of pluralityWins
    pluralityProbabilities[candidate] = count/numSimulations

  majorityProbabilities = {}
  for candidate, count of majorityWins
    majorityProbabilities[candidate] = count/numSimulations

  majority: majorityProbabilities, plurality: pluralityProbabilities

exports.getStateStyles = (distributions) ->
  styles = {}

  for state, distribution of distributions
    abbreviation = abbreviations[state].toUpperCase()
    styles[abbreviation] = calculateStateStyle state, distribution

  styles

exports.getResultsData = (resultsRaw) ->
  winProbabilities = calculateWinProbabilities resultsRaw.simulationResults

  winProbabilities: winProbabilities, expectedDelegates: resultsRaw.expectedDelegates