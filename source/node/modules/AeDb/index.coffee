{Module}= require 'di'
localConfig= require './package'

#
# Db Module
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class DbModule extends Module

    constructor: ->
        super



        #
        # Db Service
        #
        # @factory
        #
        @factory 'DbService', require './services/Db'



        #
        # Instance of Db Service
        #
        # @factory
        #
        @factory '$db', (DbService) ->

            new DbService

        #
        # Instance of Db Service
        #
        # @factory
        #
        @factory 'db', ($db) ->

            $db



    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (injector) ->

        injector.invoke (app, $db, $dbMaria, $dbRedis) ->

            app.set 'db', $db

            $db.maria= $dbMaria
            $db.redis= $dbRedis
