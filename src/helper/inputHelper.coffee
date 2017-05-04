class InputHelper

  @isValidStatus: (status) ->
    yesNoPattern = /^[y|Y][e|E][s|S]|[n|N][o|O]$/
    if !status.match yesNoPattern
      return false
    return true

  @isAskingForUserStatus: (input) ->
    userPattern = /^Is <[@|\!](\w+)>\s? coming\??$/i
    response = input.match userPattern
    if response?
      return response[1]
    userPattern = /^Who is coming\??$/i
    response = input.match userPattern
    if response?
      return 'channel'
    return null

  @isAskingForHelp: (input) ->
    messagePattern = /help/i
    if input.match messagePattern
      return true
    return false

  @isStatusAndFeedback: (input) ->
    messagePattern = /^(\d):\s*([\w\s\:\.\',-]+)/i
    matches = input.match messagePattern
    if matches is null
      return false
    obj =
      status: matches[1]
      message: matches[2]

  @isCreateEvent: (input) ->
    createEventPattern = /^create event.*/i
    if !input.match createEventPattern
      console.log "not create"
      return false
    console.log "create"
    return true

module.exports = InputHelper
