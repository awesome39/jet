{Module}= require 'di'
localConfig= require('./package.json').config

#
# Db Redis Module
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class DbRedisModule extends Module

    constructor: (config= {}, env= 'development') ->
        super



        #
        # Db Redis Service
        #
        # @factory
        #
        @factory 'DbRedisService', require './services/DbRedis'



        #
        # Instance of Db Redis Service
        #
        # @factory
        #
        @factory '$dbRedis', ($cfg, $db, DbRedisService, log) ->

            new DbRedisService $cfg.db.redis



    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (injector, cfg, $db, $cfgJoin, env) ->

        config= $cfgJoin cfg, localConfig, env

        console.log 'conf', config

        if config.db.redis

            $db.redis= injector.invoke ($dbRedis) ->
                $dbRedis
