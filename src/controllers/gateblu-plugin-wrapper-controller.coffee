MeshbluHttp = require 'meshblu-http'
_           = require 'lodash'
{Plugin}    = require 'meshblu-splunk-event-collector/index'

class GatebluPluginWrapperController
  received: (req, res) =>

    meshblu = new MeshbluHttp req.meshbluAuth
    splunkPlugin = new Plugin()

    @getDeviceConfig meshblu, (error, device) =>
      return res.sendStatus(error.code || 500) if error?
      splunkPlugin.onConfig device

      message = req.body
      message = req.body.payload if req.body.payload?

      splunkPlugin.once 'message', (message) =>
        console.log "sending meshblu message", message

        meshblu.message message, (error) =>
          res.sendStatus 200

      splunkPlugin.onMessage message


  getDeviceConfig: (meshblu, callback) =>
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
