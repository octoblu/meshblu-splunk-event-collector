MeshbluHttp = require 'meshblu-http'
_           = require 'lodash'
{Plugin}    = require '../service/gateblu-plugin'

class GatebluPluginWrapperController
  received: (req, res) =>
    console.log 'received!'
    splunkPlugin = new Plugin()
    splunkPlugin.on 'message', (message) =>
      console.log "splunk gave us this message:"
      console.log JSON.stringify message, null, 2

    @getDeviceConfig req, (error, device) =>
      return res.sendStatus(error.code || 500) if error?
      splunkPlugin.onConfig device

      message = req.body
      message = req.body.payload if req.body.payload?

      splunkPlugin.onMessage message
      res.sendStatus 200

  getDeviceConfig: (req, callback) =>
    meshblu = new MeshbluHttp req.meshbluAuth
    meshblu.whoami (error, device) =>
      return callback error if error?
      callback null, device

  getReceivedEnvelope: (req, callback) =>
    @getDeviceConfig req, (error, config) =>

      envelope =
        metadata:
          auth: req.meshbluAuth
          forwardedFor: req.body.forwardedFor
          fromUuid: req.body.fromUuid
        message: message.message
        config: config

      callback null, envelope


module.exports = GatebluPluginWrapperController
