'use strict';
util           = require 'util'
{EventEmitter} = require 'events'
debug          = require('debug')('meshblu-splunk-event-collector')

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
  constructor: (dependencies)->
    @options = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA
    @request = dependencies?.request? or require 'request'

  onMessage: (message) =>
    debug 'onMessage', message
    @emit('message', {topic: "error", error: ERROR_BASE_URL_INVALID}) if not @options?.SplunkEventUrl?
    @emit('message', {topic: "error", error: ERROR_EVENT_COLLECTOR_TOKEN_INVALID}) if not @options?.EventCollectorToken?
    @request.post @options.SplunkEventUrl, {
       json : true
       rejectUnauthorized: false
       requestCert: true
       agent: false
       headers :
         Authorization: "Splunk #{@options.EventCollectorToken}"
       body :
         event : message
      }, (error, response, body) ->

         @emit('message', {
           devices: ["*"],
           topic: 'error',
           errorMessage: error
         }) if error

         @emit('message', {
           devices : ["*"],
           statusCode: response.statusCode,
           result: body
         }) unless error

  onConfig: (device) =>
    debug 'onConfig', device
    @setOptions device.options

  setOptions: (options={}) =>
    @options = options

module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  Plugin: Plugin
