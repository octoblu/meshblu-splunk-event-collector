url                            = require 'url'
MeshbluAuth                    = require 'express-meshblu-auth'
# DeviceController             = require './controllers/device-controller'
GatebluPluginWrapperController = require './controllers/gateblu-plugin-wrapper-controller'

class Router
  constructor: ({@meshbluConfig}, dependencies={}) ->
    # @deviceController = new DeviceController {service}
    @deviceController = new GatebluPluginWrapperController()

  route: (app) =>
    meshbluAuth = MeshbluAuth @meshbluConfig
    app.use meshbluAuth
    app.post '/events/received', @deviceController.received

module.exports = Router
