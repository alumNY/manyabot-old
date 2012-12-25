# Inspect the data in redis easily
#
# take <item> - Give hubot an item to hold
#

ODDS = 1/12

class BagOfHolding
  constructor: (@robot) ->
    @bag = []
    @capacity = 15

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.bag
        @bag = @robot.brain.data.bag
        @capacity ?= @robot.brain.data.bagSize

        updateSize = ->
          @robot.brain.data.bagSize = @capacity += 1

  take: (item) ->
    x = Math.random()
    if x < ODDS
      @robot.brain.data.bagSize = @capacity += 1
    has = @bag.some (obj) ->
      return obj.toLowerCase() is item.toLowerCase()
    if has
      @robot.brain.data.bag = @bag
      return "I already have one of those."
    else if @bag.length >= @capacity
      pos = Math.floor(Math.random() * @bag.length)
      drop = @bag.splice(pos, 1, item)
      @robot.brain.data.bag = @bag
      return "Took " + item + " and dropped " + drop + "."
    else
      @bag.push item
      @robot.brain.data.bag = @bag
      return "Took " + item + "."

module.exports = (robot) ->
  bag = new BagOfHolding robot
  robot.respond /take (.*)$/i, (msg) ->
    msg.send bag.take msg.match[1].trim()
