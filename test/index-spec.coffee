{Plugin} = require '../index'
{EventEmitter} = require 'events'

describe 'EventCollectorPlugin', ->

  it 'should exist', ->
    expect(Plugin).to.exist

  describe '->onMessage', ->

    describe 'when given an invalid SplunkEventBaseUrl in the options', ->
      beforeEach ->
        @sut = new Plugin
        @messageSpy = sinon.spy()

        @message =
            skynet : "Is Genisys"
        @errorMessage =
          topic : "error"
          error : "SplunkEventBaseUrl is undefined or invalid"
        @sut.on('message', @messageSpy)
        @sut.setOptions({})
        @sut.onMessage(@message)
      it 'should send an error message saying the SplunkEventBaseUrl is invalid', ->
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
