_             = require 'lodash'
dashdash      = require 'dashdash'
MeshbluConfig = require 'meshblu-config'
Service       = require '.'
Server        = require './src/server'

service = new Service(
  serviceUrl: process.env.SERVICE_URL
)

service.run (error)=>
  throw error if error?
  server = new Server {port: process.env.PORT || 80, service}
  server.run (error) =>
    return @panic error if error?
    {address,port} = server.address()


process.on 'SIGTERM', =>
  console.log 'SIGTERM caught, exiting'
  server.stop =>
    process.exit 0
