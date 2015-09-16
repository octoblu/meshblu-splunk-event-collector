{Plugin} = require '../index'
{EventEmitter} = require 'events'
nock = require 'nock'

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

    describe 'when there is a valid URL and Token in the config options', ->
      beforeEach ->
        @options =
          SplunkEventUrl: "url"
          EventCollectorToken: "1234"

        @message =
          exampleString: "Something happened!"
        @splunkEventCollector = nock(@options.splunk)
                                  .matchHeader 'Authorization', @options.EventCollectorToken
                                  .post '/services/receivers/token/event', @message
                                  .reply(200, (uri, res) ->
                                    res
                                  );

      it 'should request the Splunk Event Collector URL with a message', ->
        setTimeout ->
          @splunkEventCollector.done()
        , 5000
