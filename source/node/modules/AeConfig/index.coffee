{Module}= require 'di'
localConfig= require './package'


#
# Config Module
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class ConfigModule extends Module

    constructor: (config= {}, env= 'development') ->
        super



        @factory 'ConfigJoinService', require './services/ConfigJoin'

        @factory '$cfgJoin', (ConfigJoinService) ->
            new ConfigJoinService



        #
        # Instance of Config Service
        #
        # @factory
        #
        @factory '$cfg', ($cfgJoin) ->
            $cfgJoin {}, config, env


        #
        # Instance of Config Service
        #
        # @factory
        #
        @factory 'cfg', ($cfg) ->
            $cfg





        @factory 'env', ->
            env



    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (injector) ->

        injector.invoke (app, $cfg) ->

            app.set 'config', $cfg
