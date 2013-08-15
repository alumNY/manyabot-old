# Description:
#   say what you mean to say
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   s/<query>/<replacement>/[g]
#
# Author:
#   wayne chang

class Substitution

  constructor: (@robot) ->
    @lastLine = {}
    @pattern = /^s\/([^\/\\]*(?:\\.[^\/\\]*)*)\/([^\/\\]*(?:\\.[^\/\\]*)*)\/(.*)/
    @verbs = [ "actually meant to say", "meant to say", "really meant to say" ]

  setLastLine: (user, line) ->
    @lastLine[user] = line

  getLastLine: (user) ->
    return if @lastLine[user]? then @lastLine[user] else ''

  verb: ->
     @verbs[Math.floor(Math.random() * @verbs.length)]

module.exports = (robot) ->
  substitution = new Substitution robot
  robot.hear substitution.pattern, (msg) ->
    query = msg.match[1].replace /\\(.)/g, '$1'
    replace = msg.match[2].replace /\\(.)/g, '$1'
    flags = msg.match[3]
    lastLine = substitution.getLastLine(msg.message.user.name);
    
    try
      if flags == 'g'
        queryPattern = new RegExp(query, "g");
        response = lastLine.replace queryPattern, replace
      else
        queryPattern = new RegExp(query);
        response = lastLine.replace queryPattern, replace

      if response? && response != '' && response != lastLine
        substitution.setLastLine(msg.message.user.name, response);
        msg.send "#{msg.message.user.name} #{substitution.verb()}: #{response}"
    catch error
      msg.send "#{msg.message.user.name}, bad regex; #{error}"

  robot.hear /.*/, (msg) ->
    unless substitution.pattern.test(msg.match[0])
      substitution.setLastLine(msg.message.user.name, msg.match[0])

