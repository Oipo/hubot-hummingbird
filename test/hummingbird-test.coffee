Helper = require('hubot-test-helper')

scriptHelper = new Helper('../src/hummingbird.coffee')

expect = require('chai').expect

describe 'hummingbird', ->
  this.timeout(5000)
  this.slow(2750)

  before ->
    @room = scriptHelper.createRoom()

  after ->
    @room.destroy()

  context 'user requests steins gate to hubot', ->

    it 'should say baka', ->
      @room.user.say('alice', '@hubot hummingbird-list 0').then =>
        expect(@room.messages.length).to.eql 2
        expect(@room.messages[1][1]).to.contain 'Baka.'

    it 'should reply to user', (done) ->
      @room.user.say('alice', '@hubot hummingbird-search steins gate').then =>
        ((room) ->
          setTimeout (->
            expect(room.messages.length).to.eql 4
            expect(room.messages[2]).to.eql ['alice', '@hubot hummingbird-search steins gate']
            expect(room.messages[3][1]).to.contain 'Found'
            done()
          ), 2500)(@room)

    it 'should list the first possible entry', ->
      @room.user.say('alice', '@hubot hummingbird-list 0').then =>
        expect(@room.messages.length).to.eql 6
        expect(@room.messages[5][1]).to.contain 'more info'

    it 'should not allow negative numbers', ->
      @room.user.say('alice', '@hubot hummingbird-list -1').then =>
        expect(@room.messages.length).to.eql 8
        expect(@room.messages[7][1]).to.contain 'negative'

    it 'should not allow zero arguments', ->
      @room.user.say('alice', '@hubot hummingbird-list').then =>
        expect(@room.messages.length).to.eql 9

    it 'should not allow string arguments', ->
      @room.user.say('alice', '@hubot hummingbird-list wakarimashita').then =>
        expect(@room.messages.length).to.eql 11
        expect(@room.messages[10][1]).to.contain 'not a number'

    it 'should not allow index higher than search results', ->
      @room.user.say('alice', '@hubot hummingbird-list 9999999').then =>
        expect(@room.messages.length).to.eql 13

        expect(@room.messages[12][1]).to.contain 'Not enough'