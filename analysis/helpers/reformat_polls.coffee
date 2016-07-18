exports.mail = (allPolls) ->
  allPollsStr = ""

  if Object.keys(allPolls.national).length > 0
    pollNumber = 1
    nationalPollsStr = "National polls:\n\n"
    for numberCandidatesStr, polls of allPolls.national
      for poll in polls
        pollStr = "Date: #{poll.date.day}/#{poll.date.month}, Pollster: #{poll.pollster}\n"
        pollStr += "Results: "
        for candidate, percentage of poll.percentages
          pollStr += "#{candidate}: #{percentage}, "

        statePollsStr += "#{pollNumber++}:\n#{pollStr.slice 0, -2}\n"

  if Object.keys(allPolls.state).length > 0
    statePollsStr = "State polls:\n\n"
    pollNumber = 1
    for state, statePolls of allPolls.state
      for numberCandidatesStr, polls of statePolls
        for poll in polls
          pollStr = "Date: #{poll.date.day}/#{poll.date.month}, Pollster: #{poll.pollster}, State: #{state}\n"
          pollStr += "Results: "
          for candidate, percentage of poll.percentages
            pollStr += "#{candidate}: #{percentage}, "

          statePollsStr += "#{pollNumber++}:\n#{pollStr.slice 0, -2}\n"

  allPollsStr += nationalPollsStr if nationalPollsStr
  allPollsStr += "\n\n" if nationalPollsStr
  allPollsStr += statePollsStr if statePollsStr

  allPollsStr

exports.python = (allPolls) ->
  delete allPolls.national._id if allPolls.national._id?
  delete allPolls.state._id if allPolls.state._id?

  nationalPollsP = []
  for numberCandidatesStr, polls of allPolls.national
    nationalPollsP.push nationalPoll for nationalPoll in polls

  statePollsP = {}
  for state, statePolls of allPolls.state
    newStatePollsP = []
    for numberCandidatesStr, polls of statePolls
      newStatePollsP.push statePoll for statePoll in polls
    statePollsP[state] = newStatePollsP if newStatePollsP.length > 0

  state: statePollsP, national: nationalPollsP