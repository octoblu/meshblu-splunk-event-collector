'use strict';
util           = require 'util'
{EventEmitter} = require 'events'
debug          = require('debug')('meshblu-splunk-event-collector')
ERROR_BASE_URL_INVALID = "SplunkEventUrl is undefined or invalid"
ERROR_EVENT_COLLECTOR_TOKEN_INVALID = "EventCollectorToken is undefined or invalid"
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

class Plugin extends EventEmitter
  constructor: ->
    @options = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA

  onMessage: (message) =>
     @emit('message', {topic: "error", error: ERROR_BASE_URL_INVALID}) if not @options?.SplunkEventUrl?
     @emit('message', {topic: "error", error: ERROR_EVENT_COLLECTOR_TOKEN_INVALID}) if not @options?.EventCollectorToken?

  onConfig: (device) =>
    @setOptions device.options

  setOptions: (options={}) =>
    @options = options

module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  Plugin: Plugin
