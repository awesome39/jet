{Module}= require 'di'
{createServer}= require 'http'
localConfig= require './package'

#
# AppServer Module
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class AppServerModule extends Module

    constructor: ->
        super


        #
        # Instance of App Server
        #
        # @factory
        #
        @factory '$server', (app) ->

            createServer app



    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (injector) ->

        injector.invoke (app, $server) ->

            app.set 'server', $server
