{Plugin} = require '../index'
{EventEmitter} = require 'events'
nock = require 'nock'
request = require 'request'


describe 'EventCollectorPlugin', ->

  it 'should exist', ->
    expect(Plugin).to.exist

  describe '->onMessage', ->

    describe 'when given an invalid SplunkEventUrl in the options', ->
      beforeEach ->
        @sut = new Plugin
        @messageSpy = sinon.spy()

        @message =
            skynet : "Is Genisys"
        @errorMessage =
          topic : "error"
          error : "SplunkEventUrl is undefined or invalid"
        @sut.on('message', @messageSpy)
        @sut.setOptions({})
        @sut.onMessage(@message)
      it 'should send an error message saying the SplunkEventUrl is invalid', ->
        expect(@messageSpy).to.have.been.calledWith(@errorMessage)

    describe 'when the event collector token is not set', ->
      beforeEach ->
        @sut = new Plugin
        @messageSpy = sinon.spy()
        @message =
            skynet : "It's whatever"
        @errorMessage =
          topic : "error"
          error : "EventCollectorToken is undefined or invalid"
        @sut.on('message', @messageSpy)
        @sut.setOptions({})
        @sut.onMessage(@message)
      it 'should send an error message saying the EventCollectorToken is invalid', ->
        expect(@messageSpy).to.have.been.calledWith(@errorMessage)

    xdescribe 'when there is a valid URL and Token in the config options', ->
      beforeEach ->
        @dependencies =
          request : request
        @dependencies.request.post = sinon.spy()


        @sut = new Plugin @dependencies
        @options =
          SplunkEventUrl : "https://theforceiswithyou.com"
          EventCollectorToken : "DarthVaderRules"
        @message =
          somekey : "has a value"
        @sut.setOptions(@options)
        @sut.onMessage(@message)

      it 'Should post the message to the SplunkEventUrl endpoint', ->
        expect(@dependencies.request.post).to.have.been.calledWith(@options.SplunkEventUrl,
        {
          headers :
            Authorization : "Splunk #{@options.EventCollectorToken}"
          json : true
          body :
            event : @message
          })
