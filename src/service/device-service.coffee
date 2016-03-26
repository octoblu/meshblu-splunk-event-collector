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

class DeviceService extends EventEmitter
  constructor: (dependencies)->
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA
    @request = dependencies?.request? or require 'request'

  onReceived: ({message, config}, callback) =>
    {options} = config
    @emit('message', {topic: "error", error: ERROR_BASE_URL_INVALID}) unless options?.SplunkEventUrl?
    @emit('message', {topic: "error", error: ERROR_EVENT_COLLECTOR_TOKEN_INVALID}) unless options?.EventCollectorToken?
    @request.post options.SplunkEventUrl, {
       json : true
       rejectUnauthorized: false
       requestCert: true
       agent: false
       headers :
         Authorization: "Splunk #{options.EventCollectorToken}"
       body :
         event : message
      }, (error, response, body) =>

        console.error error
        console.log 'body', body
         return callback error, body
         @emit('message', {
           devices: ["*"]
           topic: 'error'
           errorMessage: error
         }) if error

         @emit('message', {
           devices : ["*"]
           statusCode: response.statusCode
           result: body
         }) unless error

  run: (callback) =>
    callback()


module.exports = DeviceService
