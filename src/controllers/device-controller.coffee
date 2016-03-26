MeshbluHttp = require 'meshblu-http'
_           = require 'lodash'

class DeviceController
  constructor: ({@service}) ->

  received: (req, res) =>
    console.log 'received!'
    @getReceivedEnvelope req, (error, envelope) =>
      return res.sendStatus(error.code || 500) if error?
      @service.onReceived envelope, =>
        return res.sendStatus(error.code || 500) if error?
        res.sendStatus 200

  getDeviceConfig: (req, callback) =>
    meshblu = new MeshbluHttp req.meshbluAuth
    meshblu.whoami (error, device) =>
      return callback error if error?
      callback null, device

  getReceivedEnvelope: (req, callback) =>
    @getDeviceConfig req, (error, config) =>
      message = req.body
      message = req.body.payload if req.body.payload?
      envelope =
        metadata:
          auth: req.meshbluAuth
          forwardedFor: req.body.forwardedFor
          fromUuid: req.body.fromUuid
        message: message.message
        config: config

      callback null, envelope


module.exports = DeviceController
