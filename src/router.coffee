url                   = require 'url'
MeshbluAuth           = require 'express-meshblu-auth'
DeviceController      = require './controllers/device-controller'

class Router
  constructor: ({service, @serviceUrl, @meshbluConfig}, dependencies={}) ->
    throw new Error "a service is required in order to make a channeldevice" unless service?
    throw new Error "a serviceUrl is required in order to make a channeldevice" unless @serviceUrl?
    @deviceController = new DeviceController {service, @serviceUrl}

  route: (app) =>
    meshbluAuth = MeshbluAuth @meshbluConfig
    app.use meshbluAuth
    app.post '/events/received', @deviceController.received

module.exports = Router
