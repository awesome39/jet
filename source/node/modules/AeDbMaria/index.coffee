{Module}= require 'di'
localConfig= require './package'



#
# Db Maria Module
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class DbMariaModule extends Module

    constructor: ->
        super



        #
        # Db Maria Service
        #
        # @factory
        #
        @factory 'DbMariaService', require './services/DbMaria'



        #
        # Instance of Db Maria Service
        #
        # @factory
        #
        @factory '$dbMaria', ($cfg, $cfgJoin, env, $db, DbMariaService) ->

            config= $cfgJoin $cfg, localConfig.config, env

            new DbMariaService config.db.maria
