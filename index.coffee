'use strict';
util           = require 'util'
{EventEmitter} = require 'events'
debug          = require('debug')('meshblu-splunk-event-collector')
_              = require 'lodash'

ERROR_BASE_URL_INVALID = "SplunkEventUrl is undefined or invalid"
ERROR_EVENT_COLLECTOR_TOKEN_INVALID = "EventCollectorToken is undefined or invalid"

subscribeList = []

MESSAGE_SCHEMA =
  type: 'object'
  properties:
    exampleBoolean:
      type: 'boolean'
      required: true
    exampleString:
      type: 'string'
      required: true

OPTIONS_SCHEMA =
  type: 'object'
  properties:
    EventCollectorToken:
      type: 'string'
      required: true
    SplunkEventUrl:
      type: 'string'
      required: true
    subscribeList:
      type: 'array'
      items:
        type: 'string'


class Plugin extends EventEmitter
  constructor: ->
    @options = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA

  onMessage: (message) =>
     @emit('message', {topic: "error", error: ERROR_BASE_URL_INVALID}) if not @options?.SplunkEventUrl?
     @emit('message', {topic: "error", error: ERROR_EVENT_COLLECTOR_TOKEN_INVALID}) if not @options?.EventCollectorToken?

  # currentList, updatedList ->
  onConfig: (device) =>
    self = @
    @setOptions device.options
    if ( !_.isEqual subscribeList, device.options.subscribeList )
      removeList = _.difference subscribeList, device.options.subscribeList
      addList = _.difference device.options.subscribeList, subscribeList
      subscribeList = device.options.subscribeList
      
      if removeList?
        _.each removeList, (unsubDevice)->
          debug 'unsubscribed', unsubDevice
          self.emit 'unsubscribe', {uuid: unsubDevice}
      if addList?
        _.each addList, (subDevice) ->
          debug 'subscribed', subDevice
          self.emit 'subscribe', {uuid: subDevice}

  setOptions: (options={}) =>
    @options = options

module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  Plugin: Plugin
