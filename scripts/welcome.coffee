# Description:
#   Gives a warm welcome to new and old users

module.exports = (robot) ->
  robot.enter (response) ->
    whois = whoIs(response.message.user.name, robot)
    response.send "Welcome to #hackny, #{response.message.user.name}. #{whois}"

whoIs = (name, robot) ->
  users = robot.usersForFuzzyName(name)
  if users.length is 1
    user = users[0]
    user.roles = user.roles or [ ]
    if user.roles.length > 0
      "#{name} is #{user.roles.join(", ")}."
    else
      "#{name} is an individual and unique snowflake."
  else
    "#{name} is an individual and unique snowflake"
       


