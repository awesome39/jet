{Module}= require 'di'

#
# Log Module
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class LogModule extends Module

    constructor: ->
        super



        #
        # Log Service
        #
        # @factory
        #
        #@factory 'LogService', require './services/Log'



        #
        # Instance of Log Service
        #
        # @factory
        #
        #@factory '$log', (LogService) ->
        #    new LogService

        #
        # Instance of Log Service
        #
        # @factory
        #
        #@factory 'log', ($log) ->
        #    $log



    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (injector) ->

        injector.invoke (app, App) ->

            app.set 'view engine', 'jade'

            app.use App.static "#{__dirname}/../../../pub/assets"


            app.get '/', (req, res, next) ->
                console.log 'AUTH OR NO', req.isAuthenticated()
                res.redirect '/welcome/'
                #if do req.isAuthenticated
                #    res.redirect '/engine/'
                #else
                #    res.redirect '/welcome/'
