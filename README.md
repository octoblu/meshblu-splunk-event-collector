#Meshblu Splunk Event Collector

This plugin allows you to send meshblu messages from your devices to Splunk using
the Event Collector API

###Pre-requisites:
A working splunk instance
A meshblu device
Node and NPM installed on your machine.

How to use:
1. Register a new Meshblu device using meshblu.json
  - Set the following properties on the options field
   SplunkEventBaseUrl = [Your splunk instance url]
   EventCollectorToken = [Event Collector Token created in Splunk]
2. Subscribe to your existing devices using your registered device from step 1
3. Start the plugin using 'npm start'
